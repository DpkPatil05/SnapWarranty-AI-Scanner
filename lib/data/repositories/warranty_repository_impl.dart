import 'dart:io';
import 'package:uuid/uuid.dart';
import '../../domain/entities/warranty_item.dart';
import '../../domain/repositories/warranty_repository.dart';
import '../datasources/local/dao/warranty_dao.dart';
import '../datasources/remote/gemini_remote_datasource.dart';
import '../models/warranty_item_model.dart';

class WarrantyRepositoryImpl implements WarrantyRepository {
  final GeminiRemoteDataSource remoteDataSource;
  final WarrantyDao localDao;

  WarrantyRepositoryImpl({
    required this.remoteDataSource,
    required this.localDao,
  });

  @override
  Future<WarrantyItem> extractWarrantyFromImage(File receiptImage) async {
    final jsonMap = await remoteDataSource.extractDataFromReceipt(receiptImage);
    final id = const Uuid().v4();
    return WarrantyItemModel.fromJson(jsonMap, id, receiptImage.path);
  }

  @override
  Future<void> saveWarranty(WarrantyItem item) async {
    final model = WarrantyItemModel(
      id: item.id,
      productName: item.productName,
      purchaseDate: item.purchaseDate,
      warrantyDurationMonths: item.warrantyDurationMonths,
      receiptImagePath: item.receiptImagePath,
    );
    await localDao.insertWarranty(model.toEntry());
  }

  @override
  Future<List<WarrantyItem>> getAllWarranties() async {
    final entries = await localDao.findAllWarranties();
    return entries.map((e) => WarrantyItemModel.fromEntry(e)).toList();
  }

  @override
  Future<void> deleteWarranty(String id) async {
    await localDao.deleteWarrantyById(id);
  }

  @override
  Future<void> updateWarranty(WarrantyItem item) async {
    final model = WarrantyItemModel(
      id: item.id,
      productName: item.productName,
      purchaseDate: item.purchaseDate,
      warrantyDurationMonths: item.warrantyDurationMonths,
      receiptImagePath: item.receiptImagePath,
    );
    await localDao.insertWarranty(
      model.toEntry(),
    ); // insertOrReplace handles update
  }
}
