import 'package:wms/features/waste/domain/entities/waste_item.dart';

abstract interface class WasteRepository {
  Stream<List<WasteItem>> watchAll();

  Future<List<WasteItem>> getAll();

  Future<WasteItem?> getById(int id);

  Future<int> insert(WasteItem item);

  Future<void> delete(int id);

  Future<void> deleteAll();
}
