import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../utils/currency_formatter.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({required this.total, this.expenseCount, super.key});

  final double total;
  final int? expenseCount;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: appSoftTealColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.payments_rounded,
                    size: 19,
                    color: appPrimaryColor,
                  ),
                ),
                const SizedBox(width: space12),
                Expanded(
                  child: Text(
                    'Wydatki w tym miesiącu',
                    style: appCaptionStyle.copyWith(fontSize: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: space16),
            Text(
              formatCurrency(total),
              style: appAmountStyle.copyWith(
                fontSize: 32,
                color: appPrimaryDarkColor,
              ),
            ),
            if (expenseCount != null) ...[
              const SizedBox(height: 6),
              Text(_expenseCountText(expenseCount!), style: appCaptionStyle),
            ],
          ],
        ),
      ),
    );
  }

  String _expenseCountText(int count) {
    if (count == 1) {
      return '1 wydatek';
    }
    return '$count wydatków';
  }
}
