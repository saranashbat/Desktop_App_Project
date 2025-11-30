// lib/widgets/filter_dropdown.dart
import 'package:flutter/material.dart';
import '../utils/constants.dart';

class FilterDropdown extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const FilterDropdown({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
        border: Border.all(color: AppColors.divider),
      ),
      child: DropdownButton<String>(
        hint: Text(hint, style: AppTextStyles.bodySecondary),
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        items: items
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item, style: AppTextStyles.body),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}