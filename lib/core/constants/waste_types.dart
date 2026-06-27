import 'package:flutter/material.dart';

enum WasteType {
  PET_bottles(
    'PET bottles',
    Icons.local_drink_outlined,
    Color(0xFF007BFF),
  ), // Bright Blue
  Household_plastic_items(
    'Household plastic',
    Icons.shopping_basket_outlined,
    Color(0xFFFF8C00), // Dark Orange
  ),
  E_waste('E-waste', Icons.devices_outlined, Color(0xFF9400D3)), // Dark Violet
  Glass('Glass', Icons.wine_bar_outlined, Color(0xFF00A86B)), // Jade Green
  Alluminum(
    'Aluminum/Tin',
    Icons.inventory_2_outlined,
    Color(0xFF6C757D),
  ), // Steel Grey
  Other('Other', Icons.category_outlined, Color(0xFFDC3545)); // Crimson Red

  const WasteType(this.label, this.icon, this.color);

  final String label;
  final IconData icon;
  final Color color;

  static WasteType fromString(String value) {
    return WasteType.values.firstWhere(
      (type) => type.name == value || type.label == value,
    );
  }
}
