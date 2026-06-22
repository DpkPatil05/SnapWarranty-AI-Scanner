import 'dart:io';
import 'dart:developer' as dev;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/warranty_item.dart';
import '../../domain/repositories/warranty_repository.dart';
import '../../data/repositories/warranty_repository_impl.dart';
import '../../data/datasources/local/database/app_database.dart';
import '../../data/datasources/local/dao/warranty_dao.dart';
import '../../data/datasources/remote/gemini_remote_datasource.dart';
import '../../data/datasources/remote/drive/drive_sync_datasource.dart';
import '../../data/datasources/local/notification_service.dart';

part 'warranty_provider.g.dart';

// --- 1. Database Provider ---
@Riverpod(keepAlive: true)
AppDatabase database(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
}

// --- 2. Data Sources ---
@riverpod
GeminiRemoteDataSource geminiDataSource(Ref ref) {
  final apiKey = dotenv.env['GEMINI_API_KEY'];
  if (apiKey == null) {
    throw Exception('GEMINI_API_KEY not found in .env file');
  }
  return GeminiRemoteDataSource(apiKey: apiKey);
}

@riverpod
WarrantyDao warrantyDao(Ref ref) {
  final db = ref.watch(databaseProvider);
  return WarrantyDao(db);
}

@Riverpod(keepAlive: true)
DriveSyncDataSource driveSyncDataSource(Ref ref) {
  // Enforce the singleton instance to preserve the authenticated session state
  return DriveSyncDataSource.instance;
}

@riverpod
NotificationService notificationService(Ref ref) {
  return NotificationService();
}

// --- 3. Repository ---
@riverpod
WarrantyRepository warrantyRepository(Ref ref) {
  return WarrantyRepositoryImpl(
    remoteDataSource: ref.watch(geminiDataSourceProvider),
    localDao: ref.watch(warrantyDaoProvider),
    driveSyncDataSource: ref.watch(driveSyncDataSourceProvider),
  );
}

// --- 4. Notifier ---
@riverpod
class WarrantyList extends _$WarrantyList {
  @override
  FutureOr<List<WarrantyItem>> build() async {
    final repository = ref.watch(warrantyRepositoryProvider);

    // Since session restoration happens globally during initialization in main.dart,
    // this build method loads the local database state instantly without blocking.
    return repository.getAllWarranties();
  }

  Future<void> scanAndAddWarranty(File image) async {
    dev.log('Starting scanAndAddWarranty', name: 'WarrantyList');
    try {
      final repository = ref.read(warrantyRepositoryProvider);
      dev.log('Extracting warranty from image...', name: 'WarrantyList');
      final newItem = await repository.extractWarrantyFromImage(image);
      dev.log(
        'Extraction success: ${newItem.productName}',
        name: 'WarrantyList',
      );

      dev.log('Saving warranty to local DB...', name: 'WarrantyList');
      await repository.saveWarranty(newItem);
      dev.log('Save success', name: 'WarrantyList');

      // Schedule Notification
      if (newItem.expirationDate != null) {
        await ref
            .read(notificationServiceProvider)
            .scheduleExpiryReminder(
              id: newItem.id,
              productName: newItem.productName,
              expirationDate: newItem.expirationDate!,
            );
      }

      ref.invalidateSelf();
    } catch (e, st) {
      dev.log(
        'Error in scanAndAddWarranty',
        name: 'WarrantyList',
        error: e,
        stackTrace: st,
      );
      // We only set the error state if the extraction actually fails
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteWarranty(String id) async {
    dev.log('Deleting warranty: $id', name: 'WarrantyList');
    try {
      final repository = ref.read(warrantyRepositoryProvider);
      await repository.deleteWarranty(id);

      // Cancel Notification
      await ref.read(notificationServiceProvider).cancelReminder(id);

      dev.log('Delete success', name: 'WarrantyList');
      ref.invalidateSelf();
    } catch (e, st) {
      dev.log(
        'Error in deleteWarranty',
        name: 'WarrantyList',
        error: e,
        stackTrace: st,
      );
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateWarranty(WarrantyItem item) async {
    dev.log('Updating warranty: ${item.id}', name: 'WarrantyList');
    try {
      final repository = ref.read(warrantyRepositoryProvider);
      await repository.updateWarranty(item);

      // Reschedule Notification
      if (item.expirationDate != null) {
        await ref
            .read(notificationServiceProvider)
            .scheduleExpiryReminder(
              id: item.id,
              productName: item.productName,
              expirationDate: item.expirationDate!,
            );
      } else {
        await ref.read(notificationServiceProvider).cancelReminder(item.id);
      }

      dev.log('Update success', name: 'WarrantyList');
      ref.invalidateSelf();
    } catch (e, st) {
      dev.log(
        'Error in updateWarranty',
        name: 'WarrantyList',
        error: e,
        stackTrace: st,
      );
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> syncToDrive() async {
    try {
      final repository = ref.read(warrantyRepositoryProvider);
      await repository.syncToDrive();
    } catch (e, st) {
      dev.log('Sync Error', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<void> restoreFromDrive() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(warrantyRepositoryProvider);
      await repository.restoreFromDrive();

      // Reschedule all reminders after restore
      final allItems = await repository.getAllWarranties();
      for (final item in allItems) {
        if (item.expirationDate != null) {
          await ref
              .read(notificationServiceProvider)
              .scheduleExpiryReminder(
                id: item.id,
                productName: item.productName,
                expirationDate: item.expirationDate!,
              );
        }
      }

      ref.invalidateSelf();
    } catch (e, st) {
      dev.log('Restore Error', error: e, stackTrace: st);
      state = AsyncValue.error(e, st);
    }
  }
}

// --- 5. Search Provider ---
@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;
}

// --- 6. Filtered Warranty Provider ---
@riverpod
FutureOr<List<WarrantyItem>> filteredWarranties(Ref ref) async {
  final warrantiesAsync = ref.watch(warrantyListProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();

  return warrantiesAsync.when(
    data: (list) {
      if (query.isEmpty) return list;
      return list
          .where((item) => item.productName.toLowerCase().contains(query))
          .toList();
    },
    loading: () => [],
    error: (e, st) => [],
  );
}

// --- 7. UI State Providers ---
@riverpod
class DocumentScanning extends _$DocumentScanning {
  @override
  bool build() => false;

  void setScanning(bool value) => state = value;
}
