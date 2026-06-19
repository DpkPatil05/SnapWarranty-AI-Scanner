import 'dart:io';
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
  return GeminiRemoteDataSource();
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
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(warrantyRepositoryProvider);
      final newItem = await repository.extractWarrantyFromImage(image);
      await repository.saveWarranty(newItem);
      
      // Refresh state
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteWarranty(String id) async {
    try {
      final repository = ref.read(warrantyRepositoryProvider);
      await repository.deleteWarranty(id);
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
