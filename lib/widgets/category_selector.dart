import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_text_styles.dart';
import '../utils/app_categories.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({
    required this.selectedCategoryId,
    required this.onChanged,
    super.key,
  });

  final String? selectedCategoryId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 7,
      runSpacing: 7,
      children: [
        for (final category in appCategories)
          InkWell(
            borderRadius: chipRadius,
            onTap: () => onChanged(category.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: selectedCategoryId == category.id
                    ? appPrimaryColor
                    : appCardColor,
                borderRadius: chipRadius,
                border: Border.all(
                  color: selectedCategoryId == category.id
                      ? appPrimaryColor
                      : appBorderColor,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    category.icon,
                    size: 17,
                    color: selectedCategoryId == category.id
                        ? Colors.white
                        : category.color,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    category.name,
                    style: appCaptionStyle.copyWith(
                      fontSize: 15,
                      color: selectedCategoryId == category.id
                          ? Colors.white
                          : appTextColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
