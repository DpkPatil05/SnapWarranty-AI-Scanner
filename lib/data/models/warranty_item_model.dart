import '../../domain/entities/warranty_item.dart';
import '../datasources/local/database/app_database.dart';

class WarrantyItemModel extends WarrantyItem {
  WarrantyItemModel({
    required super.id,
    required super.productName,
    required super.purchaseDate,
    required super.warrantyDurationMonths,
    super.receiptImagePath,
  });

  factory WarrantyItemModel.fromJson(
    Map<String, dynamic> json,
    String id,
    String imagePath,
  ) {
    return WarrantyItemModel(
      id: id,
      productName: json['productName'] ?? 'Unknown Product',
      purchaseDate: DateTime.parse(json['purchaseDate']),
      warrantyDurationMonths: json['warrantyDurationMonths'] ?? 12,
      receiptImagePath: imagePath,
    );
  }

  factory WarrantyItemModel.fromEntry(WarrantyEntry entry) {
    return WarrantyItemModel(
      id: entry.id,
      productName: entry.productName,
      purchaseDate: entry.purchaseDate,
      warrantyDurationMonths: entry.warrantyDurationMonths,
      receiptImagePath: entry.receiptImagePath,
    );
  }

  WarrantyEntry toEntry() {
    return WarrantyEntry(
      id: id,
      productName: productName,
      purchaseDate: purchaseDate,
      warrantyDurationMonths: warrantyDurationMonths,
      receiptImagePath: receiptImagePath,
    );
  }
}
