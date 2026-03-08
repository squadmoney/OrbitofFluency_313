import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../models/collection.dart';

class CollectionGridCard extends StatelessWidget {
  final CardCollection collection;
  final VoidCallback onTap;

  const CollectionGridCard({super.key, required this.collection, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border(left: BorderSide(color: collection.color, width: 6)),
        ),
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _EmojiCircle(emoji: collection.emoji),
            const SizedBox(height: AppSpacing.itemGap),
            Text(
              collection.name,
              style: AppTypography.bodyRegular.copyWith(color: AppColors.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.smallGap),
            _CardCountBadge(count: collection.cards.length),
          ],
        ),
      ),
    );
  }
}

class _EmojiCircle extends StatelessWidget {
  final String emoji;

  const _EmojiCircle({required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(color: AppColors.badgeBg, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(emoji, style: const TextStyle(inherit: false, fontSize: 20)),
    );
  }
}

class _CardCountBadge extends StatelessWidget {
  final int count;

  const _CardCountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: AppColors.badgeBg, borderRadius: BorderRadius.circular(AppSpacing.tagRadius)),
      child: Text('$count Card${count == 1 ? '' : 's'}', style: AppTypography.small),
    );
  }
}
