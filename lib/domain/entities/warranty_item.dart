class WarrantyItem {
  final String id;
  final String productName;
  final DateTime purchaseDate;
  final int? warrantyDurationMonths; // Made nullable
  final String? receiptImagePath;

  WarrantyItem({
    required this.id,
    required this.productName,
    required this.purchaseDate,
    this.warrantyDurationMonths,
    this.receiptImagePath,
  });

  // Derived business logic
  DateTime? get expirationDate {
    if (warrantyDurationMonths == null) return null;
    return purchaseDate.add(Duration(days: warrantyDurationMonths! * 30));
  }

  bool get isExpired {
    final expiry = expirationDate;
    if (expiry == null) return false;
    return DateTime.now().isAfter(expiry);
  }

  WarrantyItem copyWith({
    String? productName,
    DateTime? purchaseDate,
    int? warrantyDurationMonths,
    String? receiptImagePath,
  }) {
    return WarrantyItem(
      id: id,
      productName: productName ?? this.productName,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      warrantyDurationMonths:
          warrantyDurationMonths ?? this.warrantyDurationMonths,
      receiptImagePath: receiptImagePath ?? this.receiptImagePath,
    );
  }
}
