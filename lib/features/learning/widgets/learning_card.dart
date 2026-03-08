import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import 'card_body_hidden.dart';
import 'card_body_revealed.dart';

class LearningCard extends StatelessWidget {
  final String word;
  final String collection;
  final String? imagePath;
  final bool isDescriptionShown;
  final VoidCallback onToggleDescription;

  const LearningCard({
    super.key,
    required this.word,
    required this.collection,
    required this.imagePath,
    required this.isDescriptionShown,
    required this.onToggleDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: AppShadows.learningCard,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CardImageArea(imagePath: imagePath),
          _CardBody(
            word: word,
            collection: collection,
            isDescriptionShown: isDescriptionShown,
            onToggleDescription: onToggleDescription,
          ),
        ],
      ),
    );
  }
}

class _CardImageArea extends StatelessWidget {
  final String? imagePath;

  const _CardImageArea({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    if (imagePath == null) {
      return const SizedBox(height: 259, child: _ImagePlaceholder());
    }

    return SizedBox(
      height: 259,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(
            File(imagePath!),
            key: ValueKey(imagePath),
            fit: BoxFit.cover,
            gaplessPlayback: true,
            errorBuilder: (_, _, _) => const _ImagePlaceholder(),
          ),
          // const ColoredBox(color: AppColors.imageOverlay),
        ],
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE8EFF9),
            Color(0xFFD6E0F0),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          CupertinoIcons.photo,
          size: 40,
          color: Color(0xFFB8C5D6),
        ),
      ),
    );
  }
}

class _CardBody extends StatelessWidget {
  final String word;
  final String collection;
  final bool isDescriptionShown;
  final VoidCallback onToggleDescription;

  const _CardBody({
    required this.word,
    required this.collection,
    required this.isDescriptionShown,
    required this.onToggleDescription,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.cardPadding,
          AppSpacing.sectionGap,
          AppSpacing.cardPadding,
          AppSpacing.cardPadding,
        ),
        child: isDescriptionShown
            ? CardBodyRevealed(
                word: word,
                collection: collection,
                onToggleDescription: onToggleDescription,
              )
            : CardBodyHidden(
                collection: collection,
                onToggleDescription: onToggleDescription,
              ),
      ),
    );
  }
}
