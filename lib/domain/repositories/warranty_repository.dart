import 'dart:io';
import '../entities/warranty_item.dart';

abstract class WarrantyRepository {
  /// Calls the AI API to extract data from a receipt image
  Future<WarrantyItem> extractWarrantyFromImage(File receiptImage);

  /// Saves the parsed item to local storage
  Future<void> saveWarranty(WarrantyItem item);

  /// Fetches all saved warranties
  Future<List<WarrantyItem>> getAllWarranties();

  /// Deletes a warranty item
  Future<void> deleteWarranty(String id);

  /// Updates an existing warranty item
  Future<void> updateWarranty(WarrantyItem item);

  /// Syncs all data to Google Drive
  Future<void> syncToDrive();

  /// Restores data from Google Drive
  Future<void> restoreFromDrive();
}
