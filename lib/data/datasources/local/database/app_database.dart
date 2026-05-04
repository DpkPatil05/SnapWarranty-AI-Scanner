// ignore_for_file: experimental_api
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../../../models/warranty_item_model.dart';
import '../converters/datetime_converter.dart';
import '../dao/warranty_dao.dart';

part 'app_database.g.dart';

@TypeConverters([DateTimeConverter])
@Database(version: 1, entities: [WarrantyItemModel])
abstract class AppDatabase extends FloorDatabase {
  WarrantyDao get warrantyDao;
}
