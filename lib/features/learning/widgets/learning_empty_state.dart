import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../features/navigation/providers/navigation_provider.dart';

class LearningEmptyState extends ConsumerWidget {
  const LearningEmptyState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _EmptyIcon(),
          const SizedBox(height: 12),
          Text(
            'No cards to learn yet',
            style: AppTypography.h3Medium.copyWith(color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Create a collection and add some cards\nto start learning.',
            style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64),
            child: AppPrimaryButton(
              label: 'Create Collection',
              onPressed: () {
                ref.read(currentTabIndexProvider.notifier).state = 1;
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyIcon extends StatelessWidget {
  const _EmptyIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128,
      height: 128,
      decoration: const BoxDecoration(
        color: AppColors.card,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 4),
            blurRadius: 6,
          ),
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 10),
            blurRadius: 15,
          ),
        ],
      ),
      child: const Center(
        child: Icon(CupertinoIcons.collections, size: 56, color: AppColors.accent),
      ),
    );
  }
}
