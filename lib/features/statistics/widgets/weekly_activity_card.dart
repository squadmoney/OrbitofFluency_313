import 'package:flutter/cupertino.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

const List<String> _dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

class WeeklyActivityCard extends StatelessWidget {
  final List<int> weeklyData;

  const WeeklyActivityCard({super.key, required this.weeklyData});

  @override
  Widget build(BuildContext context) {
    // Today's day index: DateTime.monday == 1, map to 0-based
    final int todayIndex = (DateTime.now().weekday - 1) % 7;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _WeeklyActivityHeader(),
          const SizedBox(height: AppSpacing.itemGap),
          _WeeklyBarChart(
            data: weeklyData,
            dayLabels: _dayLabels,
            todayIndex: todayIndex,
          ),
        ],
      ),
    );
  }
}

class _WeeklyActivityHeader extends StatelessWidget {
  const _WeeklyActivityHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(CupertinoIcons.calendar, size: 20, color: AppColors.accent),
        const SizedBox(width: AppSpacing.smallGap),
        Text('Weekly Activity', style: AppTypography.h3Medium),
      ],
    );
  }
}

class _WeeklyBarChart extends StatelessWidget {
  final List<int> data;
  final List<String> dayLabels;
  final int todayIndex;

  const _WeeklyBarChart({
    required this.data,
    required this.dayLabels,
    required this.todayIndex,
  });

  @override
  Widget build(BuildContext context) {
    final int maxValue = data.fold<int>(1, (prev, v) => v > prev ? v : prev);

    return SizedBox(
      height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(data.length, (i) {
          final isToday = i == todayIndex;
          final proportion = maxValue > 0 ? data[i] / maxValue : 0.0;
          return Expanded(
            child: _SingleBar(
              proportion: proportion,
              dayLabel: dayLabels[i],
              isToday: isToday,
            ),
          );
        }),
      ),
    );
  }
}

class _SingleBar extends StatelessWidget {
  final double proportion;
  final String dayLabel;
  final bool isToday;

  const _SingleBar({
    required this.proportion,
    required this.dayLabel,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    const double maxBarHeight = 72;
    const double minBarHeight = 4;
    final double barHeight = proportion > 0
        ? (minBarHeight + (maxBarHeight - minBarHeight) * proportion)
        : minBarHeight;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
              child: Container(
                width: double.infinity,
                height: barHeight,
                color: isToday ? AppColors.accent : const Color(0xFFC5C8FF),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          dayLabel,
          style: AppTypography.small.copyWith(fontSize: 10),
        ),
      ],
    );
  }
}
