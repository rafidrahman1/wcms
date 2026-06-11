import 'package:wms/core/constants/waste_types.dart';

class WasteItem {
  const WasteItem({
    this.id,
    required this.memberId,
    required this.weight,
    required this.type,
    required this.imagePath,
    required this.createdAt,
  });

  final int? id;
  final String memberId;
  final double weight;
  final WasteType type;
  final String imagePath;
  final DateTime createdAt;
}
