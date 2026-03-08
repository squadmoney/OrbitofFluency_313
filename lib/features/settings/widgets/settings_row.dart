import 'package:flutter/cupertino.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// A single settings row with icon, label, and right element.
class SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget trailing;
  final VoidCallback? onTap;
  final bool showDivider;

  const SettingsRow({
    super.key,
    required this.icon,
    required this.label,
    required this.trailing,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: onTap,
          child: SizedBox(
            height: 56,
            child: Row(
              children: [
                _SettingsIconContainer(icon: icon),
                const SizedBox(width: AppSpacing.itemGap),
                Expanded(
                  child: Text(label, style: AppTypography.caption.copyWith(color: AppColors.textPrimary)),
                ),
                trailing,
              ],
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.settingsIconSize + AppSpacing.itemGap),
            child: Container(height: 1, color: AppColors.divider),
          ),
      ],
    );
  }
}

class _SettingsIconContainer extends StatelessWidget {
  final IconData icon;

  const _SettingsIconContainer({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.settingsIconSize,
      height: AppSpacing.settingsIconSize,
      decoration: BoxDecoration(color: AppColors.badgeBg, borderRadius: BorderRadius.circular(AppSpacing.smallGap)),
      child: Center(
        child: Icon(icon, size: AppSpacing.iconSizeSm, color: AppColors.textSecondary, fontWeight: FontWeight.w900),
      ),
    );
  }
}

/// Trailing chevron icon for settings rows that navigate.
class SettingsChevron extends StatelessWidget {
  const SettingsChevron({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(CupertinoIcons.chevron_right, size: AppSpacing.iconSizeSm, color: AppColors.textSecondary);
  }
}

/// Trailing toggle label for the reminders row.
class SettingsToggleLabel extends StatelessWidget {
  final bool isOn;

  const SettingsToggleLabel({super.key, required this.isOn});

  @override
  Widget build(BuildContext context) {
    return Text(
      isOn ? 'On' : 'Off',
      style: AppTypography.caption.copyWith(color: isOn ? AppColors.accent : AppColors.textSecondary),
    );
  }
}
