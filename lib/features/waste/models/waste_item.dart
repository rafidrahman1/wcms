import 'package:drift/drift.dart';
import 'package:wms/core/constants/waste_types.dart';
import 'package:wms/features/waste/data/database/app_database.dart';

class WasteItem {
  const WasteItem({this.id, required this.memberId, this.memberName, required this.weight, required this.type, required this.imagePath, required this.createdAt});

  final int? id;
  final String memberId;
  final String? memberName;
  final double weight;
  final WasteType type;
  final String imagePath;
  final DateTime createdAt;
}

extension WasteItemRowMapper on WasteItemRow {
  WasteItem toWasteItem() {
    return WasteItem(id: id, memberId: memberId, memberName: memberName, weight: weight, type: WasteType.fromString(type), imagePath: imagePath, createdAt: createdAt);
  }
}

extension WasteItemCompanionMapper on WasteItem {
  WasteItemsCompanion toCompanion() {
    return WasteItemsCompanion.insert(memberId: memberId, memberName: Value(memberName), weight: weight, type: type.name, imagePath: imagePath, createdAt: createdAt);
  }
}
