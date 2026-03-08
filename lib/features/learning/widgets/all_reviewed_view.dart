import 'package:flutter/cupertino.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class AllReviewedView extends StatelessWidget {
  final VoidCallback onReviewAgain;

  const AllReviewedView({super.key, required this.onReviewAgain});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const _CelebrationIcon(),
          const SizedBox(height: 12),
          Text(
            'All cards reviewed!',
            style: AppTypography.h3Medium.copyWith(color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Great job! Come back later for new review sessions.',
            style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _ReviewAgainButton(onPressed: onReviewAgain),
        ],
      ),
    );
  }
}

class _CelebrationIcon extends StatelessWidget {
  const _CelebrationIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128,
      height: 128,
      decoration: const BoxDecoration(
        color: AppColors.card,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 4),
            blurRadius: 6,
          ),
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 10),
            blurRadius: 15,
          ),
        ],
      ),
      child: const Center(
        child: Icon(CupertinoIcons.sparkles, size: 64, color: AppColors.accent),
      ),
    );
  }
}

class _ReviewAgainButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ReviewAgainButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 247,
      height: AppSpacing.buttonHeight,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
        color: AppColors.accent,
        onPressed: onPressed,
        child: Text(
          'Review Again',
          style: AppTypography.buttonSemiBold.copyWith(
            color: AppColors.background,
          ),
        ),
      ),
    );
  }
}
