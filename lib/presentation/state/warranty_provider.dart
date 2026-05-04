import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/warranty_item.dart';
import '../../domain/repositories/warranty_repository.dart';
import '../../data/repositories/warranty_repository_impl.dart';
import '../../data/datasources/local/database/app_database.dart';
import '../../data/datasources/remote/gemini_remote_datasource.dart';

// --- 1. Database Provider ---
// We define this here, but we will override it in main.dart after it finishes initializing async.
final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('databaseProvider must be overridden in main.dart');
});

// --- 2. Data Sources ---
final geminiDataSourceProvider = Provider((ref) {
  // ⚠️ IMPORTANT: Paste your actual Gemini API key from Google AI Studio here
  return GeminiRemoteDataSource(apiKey: 'YOUR_GEMINI_API_KEY_HERE');
});

final warrantyDaoProvider = Provider((ref) {
  return ref.watch(databaseProvider).warrantyDao;
});

// --- 3. Repository ---
final warrantyRepositoryProvider = Provider<WarrantyRepository>((ref) {
  return WarrantyRepositoryImpl(
    remoteDataSource: ref.watch(geminiDataSourceProvider),
    localDao: ref.watch(warrantyDaoProvider),
  );
});

// --- 4. State Notifier ---
class WarrantyNotifier extends StateNotifier<AsyncValue<List<WarrantyItem>>> {
  final WarrantyRepository _repository;

  WarrantyNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadWarranties(); // Automatically fetch from Floor DB on startup
  }

  Future<void> loadWarranties() async {
    try {
      final items = await _repository.getAllWarranties();
      state = AsyncValue.data(items);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> scanAndAddWarranty(File image) async {
    state = const AsyncValue.loading(); // Triggers the loading spinner in UI
    try {
      final newItem = await _repository.extractWarrantyFromImage(image);
      await _repository.saveWarranty(newItem);
      await loadWarranties(); // Refresh the list
    } catch (e, st) {
      state = AsyncValue.error("Failed to parse receipt: $e", st);
      await loadWarranties(); // Revert to previous list if it fails
    }
  }

  Future<void> deleteWarranty(String id) async {
    await _repository.deleteWarranty(id);
    await loadWarranties();
  }
}

// --- 5. The Provider the UI will listen to ---
final warrantyListProvider =
    StateNotifierProvider<WarrantyNotifier, AsyncValue<List<WarrantyItem>>>((
      ref,
    ) {
      return WarrantyNotifier(ref.watch(warrantyRepositoryProvider));
    });
