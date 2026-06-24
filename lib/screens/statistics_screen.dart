import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/expense_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../utils/app_categories.dart';
import '../utils/currency_formatter.dart';
import '../widgets/empty_state.dart';
import '../widgets/expense_chart.dart';
import '../widgets/summary_card.dart';
import 'add_expense_screen.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  void _openAddExpenseScreen(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const AddExpenseScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, _) {
        final monthExpenses = provider.currentMonthExpenses;
        final totalsByCategory = provider.currentMonthTotalsByCategory;
        final sortedTotals = totalsByCategory.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        final total = provider.currentMonthTotal;
        final topCategory = sortedTotals.isEmpty
            ? null
            : categoryById(sortedTotals.first.key);
        final averageExpense = monthExpenses.isEmpty
            ? 0.0
            : total / monthExpenses.length;

        return Scaffold(
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(64),
            child: _StatsAppBar(),
          ),
          body: provider.isLoading && provider.expenses.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : monthExpenses.isEmpty
              ? SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 140),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EmptyState(
                          title: 'Brak danych',
                          message: 'Dodaj wydatek, aby zobaczyć statystyki.',
                          icon: Icons.pie_chart_rounded,
                          buttonText: 'Dodaj pierwszy wydatek',
                          onPressed: () => _openAddExpenseScreen(context),
                        ),
                      ],
                    ),
                  ),
                )
              : SafeArea(
                  top: false,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 140),
                    children: [
                      SummaryCard(
                        total: total,
                        expenseCount: monthExpenses.length,
                      ),
                      const SizedBox(height: 20),
                      _StatsSummaryCard(
                        expenseCount: monthExpenses.length,
                        averageExpense: averageExpense,
                        topCategoryName: topCategory?.name ?? 'Brak',
                      ),
                      const SizedBox(height: 20),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Wydatki według kategorii',
                                style: appSubheadingStyle,
                              ),
                              const SizedBox(height: space12),
                              ExpenseChart(totalsByCategory: totalsByCategory),
                              const SizedBox(height: space12),
                              for (final entry in sortedTotals)
                                _CategoryTotalTile(
                                  categoryId: entry.key,
                                  amount: entry.value,
                                  total: total,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class _StatsAppBar extends StatelessWidget {
  const _StatsAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Statystyki'),
          SizedBox(height: 2),
          Text(
            'Analiza aktualnego miesiąca',
            style: TextStyle(
              color: appMutedTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      toolbarHeight: 64,
    );
  }
}

class _CategoryTotalTile extends StatelessWidget {
  const _CategoryTotalTile({
    required this.categoryId,
    required this.amount,
    required this.total,
  });

  final String categoryId;
  final double amount;
  final double total;

  @override
  Widget build(BuildContext context) {
    final category = categoryById(categoryId);

    final percent = total == 0 ? 0 : (amount / total * 100).round();

    return Padding(
      padding: const EdgeInsets.only(bottom: space12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: category.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(radius12),
            ),
            child: Icon(category.icon, color: category.color, size: 20),
          ),
          const SizedBox(width: space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category.name, style: appBodyStyle),
                const SizedBox(height: 3),
                Text('$percent% wydatków', style: appCaptionStyle),
              ],
            ),
          ),
          Text(
            formatCurrency(amount),
            style: appBodyStyle.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _StatsSummaryCard extends StatelessWidget {
  const _StatsSummaryCard({
    required this.expenseCount,
    required this.averageExpense,
    required this.topCategoryName,
  });

  final int expenseCount;
  final double averageExpense;
  final String topCategoryName;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Podsumowanie', style: appSubheadingStyle),
            const SizedBox(height: space12),
            _SummaryRow(label: 'Liczba wydatków', value: '$expenseCount'),
            _SummaryRow(
              label: 'Średni wydatek',
              value: formatCurrency(averageExpense),
            ),
            _SummaryRow(label: 'Top kategoria', value: topCategoryName),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: space8),
      child: Row(
        children: [
          Expanded(child: Text(label, style: appCaptionStyle)),
          Text(
            value,
            style: appBodyStyle.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
