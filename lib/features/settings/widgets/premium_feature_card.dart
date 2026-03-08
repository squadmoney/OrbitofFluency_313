import 'package:flutter/cupertino.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// A single premium feature item card with icon circle and label.
class PremiumFeatureCard extends StatelessWidget {
  final String label;

  const PremiumFeatureCard({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.listCardRadius),
      ),
      child: Row(
        children: [
          const _FeatureIconCircle(),
          const SizedBox(width: AppSpacing.itemGap),
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodyRegular.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureIconCircle extends StatelessWidget {
  const _FeatureIconCircle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: AppColors.accentLight,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(
          CupertinoIcons.checkmark_alt,
          size: 14,
          color: AppColors.accent,
        ),
      ),
    );
  }
}
