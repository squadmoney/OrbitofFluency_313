import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../models/flash_card.dart';

class CardListItem extends StatelessWidget {
  final FlashCard card;
  final VoidCallback? onTap;
  final VoidCallback? onMore;
  final int? dragIndex;

  const CardListItem({
    super.key,
    required this.card,
    this.onTap,
    this.onMore,
    this.dragIndex,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppSpacing.listCardRadius),
          boxShadow: AppShadows.card,
        ),
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Row(
          children: [
            _CardImage(imagePath: card.imagePath),
            const SizedBox(width: AppSpacing.itemGap),
            Expanded(
              child: _CardTextContent(
                word: card.word,
                description: card.description,
              ),
            ),
            const SizedBox(width: AppSpacing.smallGap),
            _ActionsColumn(
              onMore: onMore,
              dragIndex: dragIndex,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionsColumn extends StatelessWidget {
  final VoidCallback? onMore;
  final int? dragIndex;

  const _ActionsColumn({
    this.onMore,
    this.dragIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          minimumSize: const Size(28, 28),
          onPressed: onMore,
          child: const Icon(
            CupertinoIcons.ellipsis,
            color: AppColors.textSecondary,
            size: AppSpacing.iconSizeSm,
          ),
        ),
        const SizedBox(height: 4),
        if (dragIndex != null)
          ReorderableDragStartListener(
            index: dragIndex!,
            child: const Icon(
              CupertinoIcons.line_horizontal_3,
              color: AppColors.textSecondary,
              size: AppSpacing.iconSizeSm,
            ),
          ),
      ],
    );
  }
}

class _CardImage extends StatelessWidget {
  final String? imagePath;

  const _CardImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 64,
        height: 64,
        child: imagePath != null
            ? Image.file(
                File(imagePath!),
                key: ValueKey(imagePath),
                fit: BoxFit.cover,
                gaplessPlayback: true,
                errorBuilder: (_, _, _) => const _ImageFallback(),
              )
            : const _ImageFallback(),
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.inputBg,
      alignment: Alignment.center,
      child: const Icon(
        CupertinoIcons.photo,
        color: AppColors.textSecondary,
        size: 24,
      ),
    );
  }
}

class _CardTextContent extends StatelessWidget {
  final String word;
  final String? description;

  const _CardTextContent({
    required this.word,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          word,
          style: AppTypography.bodyBold,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (description != null && description!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            description!,
            style: AppTypography.small.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
