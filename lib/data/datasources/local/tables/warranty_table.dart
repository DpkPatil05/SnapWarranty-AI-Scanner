import 'package:drift/drift.dart';

@DataClassName('WarrantyEntry')
class Warranties extends Table {
  late final id = text()();
  late final productName = text()();
  late final purchaseDate = dateTime()();
  late final warrantyDurationMonths = integer().nullable()(); // Made nullable
  late final receiptImagePath = text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
