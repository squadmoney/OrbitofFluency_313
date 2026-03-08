import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../navigation/providers/navigation_provider.dart';

class StatisticsEmptyState extends ConsumerWidget {
  const StatisticsEmptyState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _IllustrationCircle(),
              const SizedBox(height: AppSpacing.sectionGap),
              Text(
                'No data available yet',
                style: AppTypography.h3Medium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.smallGap),
              Text(
                'Complete at least one training session to see your progress and results.',
                style: AppTypography.caption,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sectionGap),
              AppPrimaryButton(
                label: 'Start training',
                onPressed: () {
                  ref.read(currentTabIndexProvider.notifier).state = 0;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IllustrationCircle extends StatelessWidget {
  const _IllustrationCircle();

  @override
  Widget build(BuildContext context) {
    const double circleSize = 192;
    const double boxSize = 240;
    const double centerOffset = (boxSize - circleSize) / 2;

    return SizedBox(
      width: boxSize,
      height: boxSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background coral circle
          Positioned(
            left: centerOffset,
            top: centerOffset,
            child: Container(
              width: circleSize,
              height: circleSize,
              decoration: const BoxDecoration(
                color: AppColors.coral,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Center card — trending up icon
          Positioned(
            left: (boxSize - 80) / 2,
            top: (boxSize - 80) / 2,
            child: const _FloatingIconCard(
              size: 80,
              borderRadius: 16,
              icon: CupertinoIcons.graph_circle_fill,
              iconSize: 40,
              shadows: AppShadows.iconCard,
            ),
          ),

          // Top-left card — clock icon
          Positioned(
            left: 8,
            top: 8,
            child: const _FloatingIconCard(
              size: 56,
              borderRadius: 12,
              icon: CupertinoIcons.clock_fill,
              iconSize: 28,
              shadows: AppShadows.smallIcon,
            ),
          ),

          // Bottom-right card — flame icon
          Positioned(
            right: 8,
            bottom: 8,
            child: const _FloatingIconCard(
              size: 56,
              borderRadius: 12,
              icon: CupertinoIcons.flame_fill,
              iconSize: 28,
              shadows: AppShadows.smallIcon,
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingIconCard extends StatelessWidget {
  final double size;
  final double borderRadius;
  final IconData icon;
  final double iconSize;
  final List<BoxShadow> shadows;

  const _FloatingIconCard({
    required this.size,
    required this.borderRadius,
    required this.icon,
    required this.iconSize,
    required this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: shadows,
      ),
      child: Center(
        child: Icon(
          icon,
          size: iconSize,
          color: AppColors.coral,
        ),
      ),
    );
  }
}
