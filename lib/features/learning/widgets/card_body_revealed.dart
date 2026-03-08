import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_outline_button.dart';

class CardBodyRevealed extends StatelessWidget {
  final String word;
  final String collection;
  final VoidCallback onToggleDescription;

  const CardBodyRevealed({
    super.key,
    required this.word,
    required this.collection,
    required this.onToggleDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _WordAndCategory(
          word: word,
          collection: collection,
        ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.08, end: 0, duration: 300.ms),
        const SizedBox(height: 24),
        const _FeedbackSection()
            .animate()
            .fadeIn(duration: 300.ms, delay: 100.ms)
            .slideY(begin: 0.08, end: 0, duration: 300.ms, delay: 100.ms),
        const SizedBox(height: 24),
        AppOutlineButton(
              label: 'Hide description',
              onPressed: onToggleDescription,
              icon: CupertinoIcons.eye_slash,
              iconSize: 20,
            )
            .animate()
            .fadeIn(duration: 300.ms, delay: 200.ms)
            .slideY(begin: 0.08, end: 0, duration: 300.ms, delay: 200.ms),
      ],
    );
  }
}

class _WordAndCategory extends StatelessWidget {
  final String word;
  final String collection;

  const _WordAndCategory({required this.word, required this.collection});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
         word,
          style: AppTypography.h1Bold.copyWith(color: AppColors.textPrimary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          // collection,
          collection,
          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _FeedbackSection extends StatelessWidget {
  const _FeedbackSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'How well did you remember?',
          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        const _SwipeLegendRow(),
      ],
    );
  }
}

class _SwipeLegendRow extends StatelessWidget {
  const _SwipeLegendRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const _LegendItem(
          color: AppColors.error,
          label: 'Swipe left — Repeat',
        ),
        const SizedBox(width: 24),
        const _LegendItem(
          color: AppColors.success,
          label: 'Swipe right — Got it',
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
