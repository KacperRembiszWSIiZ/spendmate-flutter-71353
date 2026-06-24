import 'package:flutter/foundation.dart';

import '../data/expense_repository.dart';
import '../models/expense.dart';

class ExpenseProvider extends ChangeNotifier {
  ExpenseProvider(this._repository);

  final ExpenseRepository _repository;

  final List<Expense> _expenses = [];
  bool _isLoading = false;

  List<Expense> get expenses => List.unmodifiable(_expenses);
  bool get isLoading => _isLoading;

  Future<void> loadExpenses() async {
    _setLoading(true);
    try {
      final loadedExpenses = await _repository.getAllExpenses();
      _expenses
        ..clear()
        ..addAll(loadedExpenses);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addExpense(Expense expense) async {
    await _repository.addExpense(expense);
    await loadExpenses();
  }

  Future<void> updateExpense(Expense expense) async {
    await _repository.updateExpense(expense);
    await loadExpenses();
  }

  Future<void> deleteExpense(String id) async {
    await _repository.deleteExpense(id);
    await loadExpenses();
  }

  List<Expense> get currentMonthExpenses {
    final now = DateTime.now();
    return _expenses.where((expense) {
      return expense.date.year == now.year && expense.date.month == now.month;
    }).toList();
  }

  double get currentMonthTotal {
    return currentMonthExpenses.fold<double>(
      0,
      (sum, expense) => sum + expense.amount,
    );
  }

  Map<String, double> get currentMonthTotalsByCategory {
    final totals = <String, double>{};
    for (final expense in currentMonthExpenses) {
      totals.update(
        expense.categoryId,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }
    return totals;
  }

  Expense? findById(String id) {
    for (final expense in _expenses) {
      if (expense.id == id) {
        return expense;
      }
    }
    return null;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
