enum WasteType {
  plastic('Plastic'),
  glass('Glass'),
  paper('Paper'),
  metal('Metal'),
  other('Other');

  const WasteType(this.label);

  final String label;

  static WasteType fromString(String value) {
    return WasteType.values.firstWhere(
      (type) => type.name == value || type.label == value,
      orElse: () => WasteType.other,
    );
  }
}
