import 'package:flutter/material.dart';

enum WasteType {
  PET_bottles('PET bottles', Icons.local_drink_outlined),
  Household_plastic_items('Household plastic', Icons.shopping_basket_outlined),
  E_waste('E-waste', Icons.devices_outlined),
  Glass('Glass', Icons.wine_bar_outlined),
  Alluminum('Aluminum/Tin', Icons.inventory_2_outlined),
  Other('Other', Icons.category_outlined);

  const WasteType(this.label, this.icon);

  final String label;
  final IconData icon;

  static WasteType fromString(String value) {
    return WasteType.values.firstWhere(
      (type) => type.name == value || type.label == value,
    );
  }
}
