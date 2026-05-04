import 'dart:io';
import '../entities/warranty_item.dart';
import '../repositories/warranty_repository.dart';

class ExtractWarrantyUseCase {
  final WarrantyRepository repository;

  // Constructor injection makes this highly testable
  ExtractWarrantyUseCase(this.repository);

  Future<WarrantyItem> execute(File image) async {
    // We can add validation logic here later if needed before hitting the repo
    return await repository.extractWarrantyFromImage(image);
  }
}
