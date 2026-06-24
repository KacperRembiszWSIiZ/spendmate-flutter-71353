import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../utils/app_categories.dart';
import '../utils/currency_formatter.dart';
import '../utils/date_formatter.dart';

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({required this.expense, required this.onTap, super.key});

  final Expense expense;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final category = categoryById(expense.categoryId);

    return Card(
      child: InkWell(
        borderRadius: cardRadius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(space16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(radius12),
                ),
                child: Icon(category.icon, color: category.color, size: 24),
              ),
              const SizedBox(width: space16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      expense.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: appBodyStyle.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${category.name} • ${formatDate(expense.date)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: appCaptionStyle.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: space12),
              Text(
                formatCurrency(expense.amount),
                style: appSubheadingStyle.copyWith(
                  fontSize: 18,
                  color: appPrimaryDarkColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
