import 'package:flutter/cupertino.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class AppPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSpacing.buttonHeight,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
        color: AppColors.accent,
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const CupertinoActivityIndicator(color: AppColors.background)
            : Text(
                label,
                style: AppTypography.buttonSemiBold.copyWith(
                  color: CupertinoColors.white,
                ),
              ),
      ),
    );
  }
}
