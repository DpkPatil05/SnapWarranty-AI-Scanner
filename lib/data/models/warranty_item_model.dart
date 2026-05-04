import 'package:floor/floor.dart';
import '../../domain/entities/warranty_item.dart';

@Entity(tableName: 'warranties', primaryKeys: ['id'])
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
}
