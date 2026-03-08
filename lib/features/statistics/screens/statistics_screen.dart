import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_outline_button.dart';
import '../../../models/card_progress.dart';
import '../../../models/collection.dart';
import '../../../providers/collections_provider.dart';
import '../../../providers/stats_provider.dart';
import '../../../services/export_service.dart';
import '../widgets/collection_progress_section.dart';
import '../widgets/stat_chips_row.dart';
import '../widgets/statistics_empty_state.dart';
import '../widgets/weekly_activity_card.dart';

// Debug-only providers for App Store screenshot mode

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionsState = ref.watch(collectionsProvider);
    final collections = collectionsState.collections;

    // Show empty state when there are no cards across all collections
    final totalCards = collections.fold<int>(0, (sum, c) => sum + c.cards.length);
    final hasData = totalCards > 0;

    return CupertinoPageScaffold(
      backgroundColor: AppColors.backgroundBlue,
      navigationBar: CupertinoNavigationBar(
        middle: Text('Statistics', style: AppTypography.h3Medium),
        border: null,
        backgroundColor: AppColors.backgroundBlue,
      ),
      child: SafeArea(
        child: hasData
            ? _StatisticsDataView(
                collections: collections,
                totalCards: totalCards,
              )
            : const StatisticsEmptyState(),
      ),
    );
  }
}

class _StatisticsDataView extends ConsumerWidget {
  final List<CardCollection> collections;
  final int totalCards;

  const _StatisticsDataView({
    required this.collections,
    required this.totalCards,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final realStats = ref.watch(statsProvider);

    final stats = realStats;
    final weeklyData = stats.weeklyActivity;

    return ListView(
      padding: const EdgeInsets.only(
        top: AppSpacing.sectionGap,
        left: AppSpacing.screenPadding,
        right: AppSpacing.screenPadding,
        bottom: 120,
      ),
      children: [
        StatChipsRow(
          mastered: stats.masteredCount,
          dayStreak: stats.dayStreak,
          total: totalCards,
        ),
        const SizedBox(height: AppSpacing.itemGap),

        WeeklyActivityCard(weeklyData: weeklyData),
        const SizedBox(height: AppSpacing.sectionGap),
        CollectionProgressSection(
          collections: collections,
          stats: stats,
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        AppOutlineButton(
          label: 'Export Progress',
          icon: CupertinoIcons.doc_text,
          onPressed: () => handleExportProgress(context, ref),
        ),
      ],
    );
  }
}
