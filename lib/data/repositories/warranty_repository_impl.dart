import 'dart:io';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/warranty_item.dart';
import '../../domain/repositories/warranty_repository.dart';
import '../datasources/local/dao/warranty_dao.dart';
import '../datasources/local/database/app_database.dart';
import '../datasources/remote/drive/drive_sync_datasource.dart';
import '../datasources/remote/gemini_remote_datasource.dart';
import '../models/warranty_item_model.dart';
import 'package:path_provider/path_provider.dart';

class WarrantyRepositoryImpl implements WarrantyRepository {
  final GeminiRemoteDataSource remoteDataSource;
  final WarrantyDao localDao;
  final DriveSyncDataSource driveSyncDataSource;

  WarrantyRepositoryImpl({
    required this.remoteDataSource,
    required this.localDao,
    required this.driveSyncDataSource,
  });

  @override
  Future<WarrantyItem> extractWarrantyFromImage(File receiptImage) async {
    final jsonMap = await remoteDataSource.extractDataFromReceipt(receiptImage);

    // AI Validation Check
    final isValid = jsonMap['isReceiptOrWarranty'] as bool? ?? false;
    if (!isValid) {
      throw Exception(
        "This doesn't look like a receipt or warranty document. Please try again with a clear photo of your receipt.",
      );
    }

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
    await localDao.insertWarranty(model.toEntry());
  }

  @override
  Future<void> syncToDrive() async {
    final entries = await localDao.findAllWarranties();
    await driveSyncDataSource.syncWarranties(entries);
  }

  @override
  Future<void> restoreFromDrive() async {
    final metadata = await driveSyncDataSource.downloadMetadata();
    final appDir = await getApplicationDocumentsDirectory();

    for (final json in metadata) {
      final entry = WarrantyEntry.fromJson(json);

      String? localImagePath;
      if (entry.receiptImagePath != null) {
        final fileName = entry.receiptImagePath!.split('/').last;
        final localFile = File('${appDir.path}/$fileName');

        if (!await localFile.exists()) {
          await driveSyncDataSource.downloadImage(fileName, appDir.path);
        }
        localImagePath = localFile.path;
      }

      final concreteEntry = entry.copyWith(
        receiptImagePath: Value(localImagePath),
      );
      await localDao.insertWarranty(concreteEntry);
    }
  }
}
