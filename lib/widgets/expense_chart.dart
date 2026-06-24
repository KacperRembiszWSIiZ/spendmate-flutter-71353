import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../utils/app_categories.dart';

class ExpenseChart extends StatelessWidget {
  const ExpenseChart({required this.totalsByCategory, super.key});

  final Map<String, double> totalsByCategory;

  @override
  Widget build(BuildContext context) {
    final total = totalsByCategory.values.fold<double>(
      0,
      (sum, value) => sum + value,
    );

    if (total <= 0) {
      return const SizedBox.shrink();
    }

    final visibleEntries = totalsByCategory.entries
        .where((entry) => entry.value > 0)
        .toList();

    if (visibleEntries.length == 1) {
      final category = categoryById(visibleEntries.first.key);
      return SizedBox(
        height: 62,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(category.icon, color: category.color, size: 18),
                const SizedBox(width: space8),
                Expanded(child: Text(category.name, style: appCaptionStyle)),
                const Text('100%', style: appCaptionStyle),
              ],
            ),
            const SizedBox(height: space8),
            ClipRRect(
              borderRadius: BorderRadius.circular(radius12),
              child: LinearProgressIndicator(
                value: 1,
                minHeight: 8,
                backgroundColor: category.color.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation<Color>(category.color),
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 170,
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 40,
          sectionsSpace: 3,
          sections: [
            for (final entry in visibleEntries)
              PieChartSectionData(
                value: entry.value,
                title: '${(entry.value / total * 100).round()}%',
                radius: 52,
                color: categoryById(entry.key).color,
                titleStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
