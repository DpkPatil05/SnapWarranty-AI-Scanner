import 'package:floor/floor.dart';
import '../../../models/warranty_item_model.dart';

@dao
abstract class WarrantyDao {
  @Query('SELECT * FROM warranties')
  Future<List<WarrantyItemModel>> findAllWarranties();

  @Query('SELECT * FROM warranties WHERE id = :id')
  Stream<WarrantyItemModel?> findWarrantyById(String id);

  @insert
  Future<void> insertWarranty(WarrantyItemModel warranty);

  @Query('DELETE FROM warranties WHERE id = :id')
  Future<void> deleteWarrantyById(String id);
}
