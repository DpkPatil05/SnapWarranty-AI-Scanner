// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warranty_dao.dart';

// ignore_for_file: type=lint
mixin _$WarrantyDaoMixin on DatabaseAccessor<AppDatabase> {
  $WarrantiesTable get warranties => attachedDatabase.warranties;
  WarrantyDaoManager get managers => WarrantyDaoManager(this);
}

class WarrantyDaoManager {
  final _$WarrantyDaoMixin _db;
  WarrantyDaoManager(this._db);
  $$WarrantiesTableTableManager get warranties =>
      $$WarrantiesTableTableManager(_db.attachedDatabase, _db.warranties);
}
