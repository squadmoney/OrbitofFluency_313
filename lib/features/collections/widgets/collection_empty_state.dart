import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../features/navigation/providers/navigation_provider.dart';

class CollectionEmptyState extends ConsumerWidget {
  const CollectionEmptyState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const _IllustrationCircle(),
          const SizedBox(height: AppSpacing.sectionGap),
          Text(
            'You don\'t have any cards yet',
            style: AppTypography.h3Medium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.smallGap),
          Text(
            'Add your first card',
            style: AppTypography.caption,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: AppPrimaryButton(
              label: 'Create Card',
              onPressed: () {
                ref.read(currentTabIndexProvider.notifier).state = 2;
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _IllustrationCircle extends StatelessWidget {
  const _IllustrationCircle();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Teal circle
          Container(
            width: 192,
            height: 192,
            decoration: const BoxDecoration(
              color: AppColors.teal,
              shape: BoxShape.circle,
            ),
          ),
          // Floating card — top left
          Positioned(
            top: 10,
            left: 10,
            child: _FloatingCard(
              icon: CupertinoIcons.book,
              rotation: -0.15,
            ),
          ),
          // Floating card — top right
          Positioned(
            top: 20,
            right: 5,
            child: _FloatingCard(
              icon: CupertinoIcons.scope,
              rotation: 0.12,
            ),
          ),
          // Floating card — bottom center
          Positioned(
            bottom: 5,
            right: 25,
            child: _FloatingCard(
              icon: CupertinoIcons.pencil,
              rotation: 0.08,
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingCard extends StatelessWidget {
  final IconData icon;
  final double rotation;

  const _FloatingCard({
    required this.icon,
    required this.rotation,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppShadows.card,
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 22,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
