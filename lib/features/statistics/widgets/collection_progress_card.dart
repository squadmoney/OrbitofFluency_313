import 'package:flutter/cupertino.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../models/collection.dart';

class CollectionProgressCard extends StatelessWidget {
  final CardCollection collection;
  final int mastered;

  const CollectionProgressCard({
    super.key,
    required this.collection,
    required this.mastered,
  });

  @override
  Widget build(BuildContext context) {
    final int total = collection.cards.length;
    final double progress = total > 0 ? mastered / total : 0.0;
    final int percent = (progress * 100).round();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.listCardRadius),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProgressCardHeader(
            emoji: collection.emoji,
            name: collection.name,
            percent: percent,
          ),
          const SizedBox(height: AppSpacing.itemGap),
          _ProgressBar(
            progress: progress,
            color: collection.color,
          ),
          const SizedBox(height: AppSpacing.smallGap),
          _ProgressFooter(mastered: mastered, total: total),
        ],
      ),
    );
  }
}

class _ProgressCardHeader extends StatelessWidget {
  final String emoji;
  final String name;
  final int percent;

  const _ProgressCardHeader({
    required this.emoji,
    required this.name,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(inherit: false, fontSize: 24)),
        const SizedBox(width: AppSpacing.smallGap),
        Expanded(
          child: Text(
            name,
            style: AppTypography.bodyRegular.copyWith(
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: AppSpacing.smallGap),
        _PercentBadge(percent: percent),
      ],
    );
  }
}

class _PercentBadge extends StatelessWidget {
  final int percent;

  const _PercentBadge({required this.percent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.badgeBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$percent%',
        style: AppTypography.caption.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double progress;
  final Color color;

  const _ProgressBar({required this.progress, required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: SizedBox(
        height: 6,
        child: Stack(
          children: [
            // Background track
            Container(
              width: double.infinity,
              color: AppColors.badgeBg,
            ),
            // Fill
            FractionallySizedBox(
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressFooter extends StatelessWidget {
  final int mastered;
  final int total;

  const _ProgressFooter({required this.mastered, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(mastered.toString(), style: AppTypography.small),
        Text('$mastered of $total', style: AppTypography.small),
      ],
    );
  }
}
