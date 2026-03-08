import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Tappable area that either shows a styled placeholder or a loaded local image.
class ImagePickerArea extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onTap;

  const ImagePickerArea({
    super.key,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath != null && imagePath!.isNotEmpty) {
      return _LoadedImageArea(imagePath: imagePath!, onTap: onTap);
    }
    return _EmptyImageArea(onTap: onTap);
  }
}

// ---------------------------------------------------------------------------
// Empty state — white card with accent icon circle
// ---------------------------------------------------------------------------

class _EmptyImageArea extends StatelessWidget {
  final VoidCallback onTap;

  const _EmptyImageArea({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          boxShadow: AppShadows.card,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: AppColors.accentLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  CupertinoIcons.camera,
                  size: 26,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(height: AppSpacing.itemGap),
              Text(
                'Add a photo',
                style: AppTypography.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Loaded image state — card with gradient overlay
// ---------------------------------------------------------------------------

class _LoadedImageArea extends StatelessWidget {
  final String imagePath;
  final VoidCallback onTap;

  const _LoadedImageArea({
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        height: 196,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          boxShadow: AppShadows.card,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(
              File(imagePath),
              key: ValueKey(imagePath),
              fit: BoxFit.cover,
              gaplessPlayback: true,
              errorBuilder: (_, _, _) => const _ImageError(),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color(0x80000000), Color(0x00000000)],
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      CupertinoIcons.camera,
                      size: 16,
                      color: CupertinoColors.white,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Tap to change',
                      style: AppTypography.small.copyWith(
                        color: CupertinoColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Error state
// ---------------------------------------------------------------------------

class _ImageError extends StatelessWidget {
  const _ImageError();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.inputBg,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              CupertinoIcons.exclamationmark_triangle,
              color: AppColors.textSecondary,
              size: 28,
            ),
            const SizedBox(height: AppSpacing.smallGap),
            Text(
              'Could not load image',
              style: AppTypography.small,
            ),
          ],
        ),
      ),
    );
  }
}
