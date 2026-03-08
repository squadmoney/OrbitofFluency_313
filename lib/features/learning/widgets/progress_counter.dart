import 'package:flutter/cupertino.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class ProgressCounter extends StatelessWidget {
  final int current;
  final int total;

  const ProgressCounter({
    super.key,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.textSecondary, width: 1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        '$current/$total',
        style: AppTypography.small.copyWith(
          color: AppColors.accent,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}
