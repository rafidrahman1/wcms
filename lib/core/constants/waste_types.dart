enum WasteType {
  PET_bottles('PET bottles'),
  Household_plastic_items('Household plastic items'),
  E_waste('E-waste'),
  Glass('Glass'),
  Alluminum('Alluminum/Tin cans');

  const WasteType(this.label);

  final String label;

  static WasteType fromString(String value) {
    return WasteType.values.firstWhere(
      (type) => type.name == value || type.label == value,
    );
  }
}
