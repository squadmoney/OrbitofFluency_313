import 'package:flutter/cupertino.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class AppTabBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.tabBarTopRadius),
          topRight: Radius.circular(AppSpacing.tabBarTopRadius),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: AppSpacing.tabBarPaddingV,
          ),
          child: Row(
            children: [
              _TabItem(
                index: 0,
                currentIndex: currentIndex,
                icon: CupertinoIcons.book,
                label: 'Learn',
                onTap: onTap,
              ),
              _TabItem(
                index: 1,
                currentIndex: currentIndex,
                icon: CupertinoIcons.square_stack_3d_up,
                label: 'Collections',
                onTap: onTap,
              ),
              _TabItem(
                index: 2,
                currentIndex: currentIndex,
                icon: CupertinoIcons.plus_circle,
                label: 'Create',
                onTap: onTap,
                iconSize: AppSpacing.iconSizeLg,
              ),
              _TabItem(
                index: 3,
                currentIndex: currentIndex,
                icon: CupertinoIcons.chart_bar,
                label: 'Stats',
                onTap: onTap,
              ),
              _TabItem(
                index: 4,
                currentIndex: currentIndex,
                icon: CupertinoIcons.gear,
                label: 'Settings',
                onTap: onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final IconData icon;
  final String label;
  final ValueChanged<int> onTap;
  final double iconSize;

  const _TabItem({
    required this.index,
    required this.currentIndex,
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconSize = AppSpacing.iconSize,
  });

  bool get _isActive => index == currentIndex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => onTap(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _TabIcon(
              icon: icon,
              iconSize: iconSize,
              isActive: _isActive,
            ),
            const SizedBox(height: 2),
            _TabLabel(
              label: label,
              isActive: _isActive,
            ),
          ],
        ),
      ),
    );
  }
}

class _TabIcon extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final bool isActive;

  const _TabIcon({
    required this.icon,
    required this.iconSize,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(
      icon,
      size: iconSize,
      color: isActive ? AppColors.accent : AppColors.textSecondary,
    );

    if (isActive) {
      return Container(
        width: AppSpacing.iconContainerSize,
        height: AppSpacing.iconContainerSize,
        decoration: BoxDecoration(
          color: AppColors.accentLight,
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
        ),
        child: Center(child: iconWidget),
      );
    }

    return SizedBox(
      width: AppSpacing.iconContainerSize,
      height: AppSpacing.iconContainerSize,
      child: Center(child: iconWidget),
    );
  }
}

class _TabLabel extends StatelessWidget {
  final String label;
  final bool isActive;

  const _TabLabel({
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTypography.small.copyWith(
        color: isActive ? AppColors.accent : AppColors.textSecondary,
      ),
    );
  }
}
