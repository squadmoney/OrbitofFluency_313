import 'package:flutter/cupertino.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_typography.dart';
import 'swipe_action_button.dart';

class SwipeControls extends StatelessWidget {
  final VoidCallback onRepeat;
  final VoidCallback onGotIt;

  const SwipeControls({
    super.key,
    required this.onRepeat,
    required this.onGotIt,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SwipeActionButton(
          color: AppColors.error,
          icon: CupertinoIcons.arrow_counterclockwise,
          iconSize: 24,
          shadows: const [
            BoxShadow(
              color: Color(0x0D000000),
              offset: Offset(0, 1),
              blurRadius: 2,
            ),
          ],
          onPressed: onRepeat,
        ),
        Text(
          'Swipe to decide',
          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
        ),
        SwipeActionButton(
          color: AppColors.success,
          icon: CupertinoIcons.checkmark,
          iconSize: 28,
          shadows: AppShadows.greenGlow,
          onPressed: onGotIt,
        ),
      ],
    );
  }
}
