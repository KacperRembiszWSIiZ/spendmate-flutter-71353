import 'package:flutter/material.dart';

import '../models/expense_category.dart';

const List<ExpenseCategory> appCategories = [
  ExpenseCategory(
    id: 'food',
    name: 'Jedzenie',
    icon: Icons.restaurant_rounded,
    color: Color(0xFFE76F51),
  ),
  ExpenseCategory(
    id: 'transport',
    name: 'Transport',
    icon: Icons.directions_car_rounded,
    color: Color(0xFF2A9D8F),
  ),
  ExpenseCategory(
    id: 'bills',
    name: 'Rachunki',
    icon: Icons.receipt_long_rounded,
    color: Color(0xFF457B9D),
  ),
  ExpenseCategory(
    id: 'shopping',
    name: 'Zakupy',
    icon: Icons.shopping_bag_rounded,
    color: Color(0xFFF4A261),
  ),
  ExpenseCategory(
    id: 'health',
    name: 'Zdrowie',
    icon: Icons.local_hospital_rounded,
    color: Color(0xFFE63946),
  ),
  ExpenseCategory(
    id: 'entertainment',
    name: 'Rozrywka',
    icon: Icons.movie_rounded,
    color: Color(0xFF8E7DBE),
  ),
  ExpenseCategory(
    id: 'education',
    name: 'Edukacja',
    icon: Icons.school_rounded,
    color: Color(0xFF118AB2),
  ),
  ExpenseCategory(
    id: 'other',
    name: 'Inne',
    icon: Icons.more_horiz_rounded,
    color: Color(0xFF6C757D),
  ),
];

ExpenseCategory categoryById(String id) {
  return appCategories.firstWhere(
    (category) => category.id == id,
    orElse: () => appCategories.last,
  );
}
