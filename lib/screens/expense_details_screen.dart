import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/expense_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../utils/app_categories.dart';
import '../utils/currency_formatter.dart';
import '../utils/date_formatter.dart';
import '../utils/receipt_image_helper.dart';
import '../widgets/empty_state.dart';

class ExpenseDetailsScreen extends StatelessWidget {
  const ExpenseDetailsScreen({required this.expenseId, super.key});

  final String expenseId;

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Usunąć wydatek?'),
          content: const Text('Tej operacji nie można cofnąć.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Anuluj'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Usuń'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    await context.read<ExpenseProvider>().deleteExpense(expenseId);

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, _) {
        final expense = provider.findById(expenseId);

        if (expense == null) {
          return const Scaffold(
            body: EmptyState(
              title: 'Nie znaleziono wydatku',
              message: 'Ten wydatek został usunięty albo nie istnieje.',
            ),
          );
        }

        final category = categoryById(expense.categoryId);

        return Scaffold(
          appBar: AppBar(title: const Text('Szczegóły wydatku')),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                color: category.color.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                category.icon,
                                color: category.color,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    expense.title,
                                    style: appSubheadingStyle.copyWith(
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(category.name, style: appCaptionStyle),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _DetailRow(
                          label: 'Kwota',
                          value: formatCurrency(expense.amount),
                        ),
                        const Divider(height: 18),
                        _DetailRow(
                          label: 'Data wydatku',
                          value: formatDate(expense.date),
                        ),
                        const Divider(height: 18),
                        _DetailRow(
                          label: 'Data utworzenia',
                          value: formatDate(expense.createdAt),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: space16),
                FutureBuilder<bool>(
                  future: receiptImageExists(expense.receiptImagePath),
                  builder: (context, snapshot) {
                    final imageExists = snapshot.data ?? false;
                    if (!imageExists) {
                      return const SizedBox.shrink();
                    }

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(space16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Paragon',
                              style: appSubheadingStyle.copyWith(fontSize: 17),
                            ),
                            const SizedBox(height: space12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(radius16),
                              child: Image.file(
                                File(expense.receiptImagePath!),
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const SizedBox(
                                    height: 140,
                                    child: Center(
                                      child: Text(
                                        'Nie można wyświetlić zdjęcia paragonu.',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: space24),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: appDangerColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(56),
                  ),
                  onPressed: () => _confirmDelete(context),
                  icon: const Icon(Icons.delete_rounded),
                  label: const Text('Usuń wydatek'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(label, style: appCaptionStyle)),
          Text(
            value,
            style: appBodyStyle.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
