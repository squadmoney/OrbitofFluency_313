import 'package:flutter/cupertino.dart';

import '../../../core/theme/app_colors.dart';

class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.pageCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(pageCount, (index) {
        final bool isActive = index == currentPage;
        return Padding(
          padding: EdgeInsets.only(right: index < pageCount - 1 ? 8.0 : 0.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            width: isActive ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive ? AppColors.accent : AppColors.accentLight,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}
