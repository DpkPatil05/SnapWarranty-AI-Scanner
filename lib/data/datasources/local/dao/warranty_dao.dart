import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../tables/warranty_table.dart';

part 'warranty_dao.g.dart';

@DriftAccessor(tables: [Warranties])
class WarrantyDao extends DatabaseAccessor<AppDatabase>
    with _$WarrantyDaoMixin {
  WarrantyDao(super.db);

  Future<List<WarrantyEntry>> findAllWarranties() => select(warranties).get();

  Stream<WarrantyEntry?> findWarrantyById(String id) {
    return (select(
      warranties,
    )..where((t) => t.id.equals(id))).watchSingleOrNull();
  }

  Future<void> insertWarranty(WarrantyEntry entry) =>
      into(warranties).insert(entry, mode: InsertMode.insertOrReplace);

  Future<void> deleteWarrantyById(String id) {
    return (delete(warranties)..where((t) => t.id.equals(id))).go();
  }
}
