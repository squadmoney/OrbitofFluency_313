import 'package:flutter/cupertino.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import 'onboarding_illustration.dart';

class OnboardingSlide extends StatelessWidget {
  final Color circleColor;
  final String centerSvg;
  final String topLeftSvg;
  final String bottomRightSvg;
  final String title;
  final String body;

  const OnboardingSlide({
    super.key,
    required this.circleColor,
    required this.centerSvg,
    required this.topLeftSvg,
    required this.bottomRightSvg,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OnboardingIllustration(
            circleColor: circleColor,
            centerSvg: centerSvg,
            topLeftSvg: topLeftSvg,
            bottomRightSvg: bottomRightSvg,
          ),
          const SizedBox(height: 48),
          Text(
            title,
            style: AppTypography.h2SemiBold.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            body,
            style: AppTypography.bodyRegular.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
