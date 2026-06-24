import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'data/expense_repository.dart';
import 'providers/expense_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ExpenseProvider(ExpenseRepository())..loadExpenses(),
      child: const SpendMateApp(),
    ),
  );
}
