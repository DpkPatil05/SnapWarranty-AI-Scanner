class WarrantyItem {
  final String id;
  final String productName;
  final DateTime purchaseDate;
  final int warrantyDurationMonths;
  final String? receiptImagePath;

  WarrantyItem({
    required this.id,
    required this.productName,
    required this.purchaseDate,
    required this.warrantyDurationMonths,
    this.receiptImagePath,
  });

  // Derived business logic can live here
  DateTime get expirationDate {
    return purchaseDate.add(Duration(days: warrantyDurationMonths * 30));
  }

  bool get isExpired {
    return DateTime.now().isAfter(expirationDate);
  }
}
