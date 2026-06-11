import 'package:wms/core/utils/image_storage.dart';
import 'package:wms/features/waste/data/database/app_database.dart';
import 'package:wms/features/waste/data/models/waste_item_model.dart';
import 'package:wms/features/waste/domain/entities/waste_item.dart';
import 'package:wms/features/waste/domain/repositories/waste_repository.dart';

class WasteRepositoryImpl implements WasteRepository {
  WasteRepositoryImpl(this._database);

  final AppDatabase _database;

  @override
  Stream<List<WasteItem>> watchAll() {
    return _database.watchAllWasteItems().map(
          (rows) => rows.map((row) => row.toEntity()).toList(),
        );
  }

  @override
  Future<List<WasteItem>> getAll() async {
    final rows = await _database.getAllWasteItems();
    return rows.map((row) => row.toEntity()).toList();
  }

  @override
  Future<WasteItem?> getById(int id) async {
    final row = await _database.getWasteItemById(id);
    return row?.toEntity();
  }

  @override
  Future<int> insert(WasteItem item) {
    return _database.insertWasteItem(item.toCompanion());
  }

  @override
  Future<void> delete(int id) async {
    final item = await getById(id);
    await _database.deleteWasteItem(id);
    await ImageStorage.deleteImage(item?.imagePath);
  }

  @override
  Future<void> deleteAll() async {
    final items = await getAll();
    await _database.deleteAllWasteItems();
    for (final item in items) {
      await ImageStorage.deleteImage(item.imagePath);
    }
  }
}
