import 'package:flutter/cupertino.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class StatChipsRow extends StatelessWidget {
  final int mastered;
  final int dayStreak;
  final int total;

  const StatChipsRow({
    super.key,
    required this.mastered,
    required this.dayStreak,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatChip(
            icon: CupertinoIcons.checkmark_circle_fill,
            iconColor: AppColors.teal,
            value: mastered.toString(),
            label: 'Mastered',
          ),
        ),
        const SizedBox(width: AppSpacing.itemGap),
        Expanded(
          child: _StatChip(
            icon: CupertinoIcons.flame_fill,
            iconColor: AppColors.orange,
            value: dayStreak.toString(),
            label: 'Day Streak',
          ),
        ),
        const SizedBox(width: AppSpacing.itemGap),
        Expanded(
          child: _StatChip(
            icon: CupertinoIcons.arrow_up_right,
            iconColor: AppColors.accent,
            value: total.toString(),
            label: 'Total',
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatChip({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(height: AppSpacing.smallGap),
          Text(value, style: AppTypography.h3Medium),
          const SizedBox(height: 2),
          Text(label, style: AppTypography.small),
        ],
      ),
    );
  }
}
