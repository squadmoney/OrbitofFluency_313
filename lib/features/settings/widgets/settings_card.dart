import 'package:flutter/cupertino.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// White rounded card container for settings rows.
class SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const SettingsCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
