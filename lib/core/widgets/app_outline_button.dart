import 'package:flutter/cupertino.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class AppOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double iconSize;

  const AppOutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.iconSize = AppSpacing.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSpacing.buttonHeight,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
        color: const Color(0x00000000), // transparent
        onPressed: onPressed,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.accent, width: 1),
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: iconSize, color: AppColors.accent),
                  const SizedBox(width: 10),
                ],
                Text(
                  label,
                  style: AppTypography.buttonSemiBold
                      .copyWith(color: AppColors.accent),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
