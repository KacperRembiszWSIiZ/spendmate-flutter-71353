import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/expense_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../widgets/empty_state.dart';
import '../widgets/expense_card.dart';
import '../widgets/summary_card.dart';
import 'add_expense_screen.dart';
import 'expense_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openAddExpenseScreen(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const AddExpenseScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, _) {
        final expenses = provider.expenses;

        return Scaffold(
          appBar: AppBar(
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SpendMate'),
                SizedBox(height: 2),
                Text(
                  'Twoje wydatki pod kontrolą',
                  style: TextStyle(
                    color: appMutedTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            toolbarHeight: 64,
          ),
          body: RefreshIndicator(
            onRefresh: provider.loadExpenses,
            child: provider.isLoading && expenses.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : SafeArea(
                    top: false,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
                      children: [
                        SummaryCard(
                          total: provider.currentMonthTotal,
                          expenseCount: provider.currentMonthExpenses.length,
                        ),
                        const SizedBox(height: space24),
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Historia wydatków',
                                style: TextStyle(
                                  color: appTextColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            if (expenses.isNotEmpty)
                              Text(
                                '${expenses.length} pozycji',
                                style: appCaptionStyle,
                              ),
                          ],
                        ),
                        const SizedBox(height: space12),
                        if (expenses.isEmpty)
                          EmptyState(
                            title: 'Brak wydatków',
                            message:
                                'Dodaj pierwszy wydatek i zobacz podsumowanie miesiąca.',
                            icon: Icons.receipt_long_rounded,
                            buttonText: 'Dodaj pierwszy wydatek',
                            onPressed: () => _openAddExpenseScreen(context),
                          )
                        else
                          for (final expense in expenses) ...[
                            ExpenseCard(
                              expense: expense,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => ExpenseDetailsScreen(
                                      expenseId: expense.id,
                                    ),
                                  ),
                                );
                              },
                            ),
                            if (expense != expenses.last)
                              const SizedBox(height: space12),
                          ],
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
