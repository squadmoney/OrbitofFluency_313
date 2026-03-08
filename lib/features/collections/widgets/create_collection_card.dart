import 'package:flutter/cupertino.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class CreateCollectionCard extends StatelessWidget {
  final VoidCallback onTap;

  const CreateCollectionCard({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: const Border(
            left: BorderSide(color: AppColors.orange, width: 6),
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.plus,
              color: AppColors.accent,
              size: 32,
            ),
            const SizedBox(height: AppSpacing.tinyGap),
            Text(
              'Create',
              style: AppTypography.small.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
