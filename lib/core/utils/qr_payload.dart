import 'dart:convert';

import 'package:wms/features/waste/domain/entities/waste_item.dart';

abstract final class QrPayload {
  static const appId = 'WMS-Mobile';

  static String encodeJson(WasteItem item) {
    return jsonEncode({
      'app': appId,
      'uid': item.id.toString(),
      'memberId': item.memberId,
      'weight': item.weight,
      'type': item.type.name,
      'loggedAt': item.createdAt.toIso8601String(),
    });
  }
}
