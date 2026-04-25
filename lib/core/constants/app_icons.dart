
import 'package:flutter/material.dart';
import 'item_categories.dart';

class AppIcons {
  static IconData byCategory(String category) {
    switch (category.toLowerCase()) {
    case ItemCategories.water:
    return Icons.water_drop;
    case ItemCategories.food:
    return Icons.fastfood;
    case ItemCategories.medicine:
    return Icons.medical_services;
    case ItemCategories.clothes:
    return Icons.checkroom;
    case ItemCategories.cash:
    return Icons.volunteer_activism;
    case ItemCategories.hygiene:
    return Icons.clean_hands;
    case ItemCategories.babyFood:
    return Icons.child_care;
      case ItemCategories.blanket:
        return Icons.bed;
      default:
        return Icons.inventory_2;
    }
  }
}