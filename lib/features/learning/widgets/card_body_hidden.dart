import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_outline_button.dart';

class CardBodyHidden extends StatelessWidget {
  final String collection;
  final VoidCallback onToggleDescription;

  const CardBodyHidden({
    super.key,
    required this.collection,
    required this.onToggleDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _CollectionTitleWithUnderline(collection: collection)
            .animate()
            .fadeIn(duration: 300.ms),
        const SizedBox(height: 24),
        AppOutlineButton(
          label: 'Show description',
          onPressed: onToggleDescription,
          icon: CupertinoIcons.eye,
          iconSize: 20,
        )
            .animate()
            .fadeIn(duration: 300.ms, delay: 100.ms),
      ],
    );
  }
}

class _CollectionTitleWithUnderline extends StatelessWidget {
  final String collection;

  const _CollectionTitleWithUnderline({required this.collection});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          collection,
          style: AppTypography.h3Medium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        _AccentUnderline(text: collection),
      ],
    );
  }
}

class _AccentUnderline extends StatelessWidget {
  final String text;

  const _AccentUnderline({required this.text});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final semiboldStyle = AppTypography.h3Medium.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        );
        final textPainter = TextPainter(
          text: TextSpan(text: text, style: semiboldStyle),
          textDirection: TextDirection.ltr,
          maxLines: 1,
        )..layout(maxWidth: constraints.maxWidth);

        final textWidth = textPainter.size.width;

        return Container(
          width: textWidth,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(100),
          ),
        );
      },
    );
  }
}
