import '../../domain/entities/warranty_item.dart';
import '../datasources/local/database/app_database.dart';

class WarrantyItemModel extends WarrantyItem {
  WarrantyItemModel({
    required super.id,
    required super.productName,
    required super.purchaseDate,
    super.warrantyDurationMonths,
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
      purchaseDate:
          DateTime.tryParse(json['purchaseDate'] ?? '') ?? DateTime.now(),
      warrantyDurationMonths: json['warrantyDurationMonths'], // Can be null
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
