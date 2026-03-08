import 'package:flutter/cupertino.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../models/collection.dart';
import '../../../providers/stats_provider.dart';
import 'collection_progress_card.dart';

class CollectionProgressSection extends StatelessWidget {
  final List<CardCollection> collections;
  final StatsState stats;

  const CollectionProgressSection({
    super.key,
    required this.collections,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Collection Progress', style: AppTypography.input),
        const SizedBox(height: AppSpacing.itemGap),
        ...List.generate(collections.length, (i) {
          final col = collections[i];
          final cardIds = col.cards.map((c) => c.id).toList();
          return Padding(
            padding: EdgeInsets.only(
              bottom: i < collections.length - 1 ? AppSpacing.itemGap : 0,
            ),
            child: CollectionProgressCard(
              collection: col,
              mastered: stats.masteredInCollection(cardIds),
            ),
          );
        }),
      ],
    );
  }
}
