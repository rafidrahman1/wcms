import 'package:wms/core/utils/image_storage.dart';
import 'package:wms/features/waste/data/database/app_database.dart';
import 'package:wms/features/waste/models/waste_item.dart';

class WasteRepository {
  WasteRepository(this._database);

  final AppDatabase _database;

  Stream<List<WasteItem>> watchAll() {
    return _database.watchAllWasteItems().map(
          (rows) => rows.map((row) => row.toWasteItem()).toList(),
        );
  }

  Future<WasteItem?> getById(int id) async {
    final row = await _database.getWasteItemById(id);
    return row?.toWasteItem();
  }

  Future<int> insert(WasteItem item) {
    return _database.insertWasteItem(item.toCompanion());
  }

  Future<void> delete(int id) async {
    final item = await getById(id);
    await _database.deleteWasteItem(id);
    await deleteWasteImage(item?.imagePath);
  }

  Future<void> deleteAll() async {
    final rows = await _database.getAllWasteItems();
    await _database.deleteAllWasteItems();
    for (final row in rows) {
      await deleteWasteImage(row.imagePath);
    }
  }
}
