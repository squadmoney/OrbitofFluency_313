import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbitoffluency/premka.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Full-width "Buy Premium" CTA button with icon on the left.
class PremiumCtaButton extends ConsumerWidget {
  final VoidCallback onPressed;

  const PremiumCtaButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(premProvider);
    return SizedBox(
      width: double.infinity,
      height: AppSpacing.buttonHeight,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
        color: AppColors.accent,
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isPremium ? '💡' : '🧠',
              style: const TextStyle(inherit: false, fontSize: 20),
            ),
            const SizedBox(width: AppSpacing.smallGap),
            Text(
              isPremium ? 'Premium Active' : 'Buy Premium for \$0,99',
              style: AppTypography.buttonSemiBold,
            ),
          ],
        ),
      ),
    );
  }
}
