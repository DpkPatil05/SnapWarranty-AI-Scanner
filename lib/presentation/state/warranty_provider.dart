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

// --- 3. Repository ---
@riverpod
WarrantyRepository warrantyRepository(Ref ref) {
  return WarrantyRepositoryImpl(
    remoteDataSource: ref.watch(geminiDataSourceProvider),
    localDao: ref.watch(warrantyDaoProvider),
  );
}

// --- 4. Notifier ---
@riverpod
class WarrantyList extends _$WarrantyList {
  @override
  FutureOr<List<WarrantyItem>> build() async {
    final repository = ref.watch(warrantyRepositoryProvider);
    return repository.getAllWarranties();
  }

  Future<void> scanAndAddWarranty(File image) async {
    dev.log('Starting scanAndAddWarranty', name: 'WarrantyList');
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(warrantyRepositoryProvider);
      dev.log('Extracting warranty from image...', name: 'WarrantyList');
      final newItem = await repository.extractWarrantyFromImage(image);
      dev.log('Extraction success: ${newItem.productName}', name: 'WarrantyList');
      
      dev.log('Saving warranty to local DB...', name: 'WarrantyList');
      await repository.saveWarranty(newItem);
      dev.log('Save success', name: 'WarrantyList');
      
      // Refresh state
      ref.invalidateSelf();
    } catch (e, st) {
      dev.log('Error in scanAndAddWarranty', name: 'WarrantyList', error: e, stackTrace: st);
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteWarranty(String id) async {
    dev.log('Deleting warranty: $id', name: 'WarrantyList');
    try {
      final repository = ref.read(warrantyRepositoryProvider);
      await repository.deleteWarranty(id);
      dev.log('Delete success', name: 'WarrantyList');
      ref.invalidateSelf();
    } catch (e, st) {
      dev.log('Error in deleteWarranty', name: 'WarrantyList', error: e, stackTrace: st);
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateWarranty(WarrantyItem item) async {
    dev.log('Updating warranty: ${item.id}', name: 'WarrantyList');
    try {
      final repository = ref.read(warrantyRepositoryProvider);
      await repository.updateWarranty(item);
      dev.log('Update success', name: 'WarrantyList');
      ref.invalidateSelf();
    } catch (e, st) {
      dev.log('Error in updateWarranty', name: 'WarrantyList', error: e, stackTrace: st);
      state = AsyncValue.error(e, st);
    }
  }
}
