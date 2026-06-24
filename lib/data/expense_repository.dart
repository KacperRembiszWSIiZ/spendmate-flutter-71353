import 'package:sqflite/sqflite.dart';

import '../models/expense.dart';
import 'database_helper.dart';

class ExpenseRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<List<Expense>> getAllExpenses() async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      DatabaseHelper.expensesTable,
      orderBy: 'date DESC, createdAt DESC',
    );
    return maps.map(Expense.fromMap).toList();
  }

  Future<void> addExpense(Expense expense) async {
    final db = await _databaseHelper.database;
    await db.insert(
      DatabaseHelper.expensesTable,
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateExpense(Expense expense) async {
    final db = await _databaseHelper.database;
    await db.update(
      DatabaseHelper.expensesTable,
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<void> deleteExpense(String id) async {
    final db = await _databaseHelper.database;
    await db.delete(
      DatabaseHelper.expensesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Expense>> getExpensesByMonth(DateTime month) async {
    final db = await _databaseHelper.database;
    final start = DateTime(month.year, month.month);
    final end = DateTime(month.year, month.month + 1);
    final maps = await db.query(
      DatabaseHelper.expensesTable,
      where: 'date >= ? AND date < ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'date DESC, createdAt DESC',
    );
    return maps.map(Expense.fromMap).toList();
  }

  Future<Map<String, double>> getTotalsByCategory(DateTime month) async {
    final db = await _databaseHelper.database;
    final start = DateTime(month.year, month.month);
    final end = DateTime(month.year, month.month + 1);
    final rows = await db.rawQuery(
      '''
      SELECT categoryId, SUM(amount) AS total
      FROM ${DatabaseHelper.expensesTable}
      WHERE date >= ? AND date < ?
      GROUP BY categoryId
      ''',
      [start.toIso8601String(), end.toIso8601String()],
    );

    return {
      for (final row in rows)
        row['categoryId'] as String: (row['total'] as num?)?.toDouble() ?? 0,
    };
  }

  Future<double> getTotalForMonth(DateTime month) async {
    final db = await _databaseHelper.database;
    final start = DateTime(month.year, month.month);
    final end = DateTime(month.year, month.month + 1);
    final rows = await db.rawQuery(
      '''
      SELECT SUM(amount) AS total
      FROM ${DatabaseHelper.expensesTable}
      WHERE date >= ? AND date < ?
      ''',
      [start.toIso8601String(), end.toIso8601String()],
    );

    return (rows.first['total'] as num?)?.toDouble() ?? 0;
  }
}
