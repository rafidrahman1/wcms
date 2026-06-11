import 'package:wms/core/constants/waste_types.dart';
import 'package:wms/features/waste/data/database/app_database.dart';
import 'package:wms/features/waste/domain/entities/waste_item.dart';

extension WasteItemRowMapper on WasteItemRow {
  WasteItem toEntity() {
    return WasteItem(
      id: id,
      memberId: memberId,
      weight: weight,
      type: WasteType.fromString(type),
      imagePath: imagePath,
      createdAt: createdAt,
    );
  }
}

extension WasteItemEntityMapper on WasteItem {
  WasteItemsCompanion toCompanion() {
    return WasteItemsCompanion.insert(
      memberId: memberId,
      weight: weight,
      type: type.name,
      imagePath: imagePath,
      createdAt: createdAt,
    );
  }
}
