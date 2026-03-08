import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../models/collection.dart';
import '../../../providers/collections_provider.dart';
import '../widgets/collection_grid_card.dart';
import '../widgets/create_collection_card.dart';
import '../widgets/new_collection_sheet.dart';
import 'collection_detail_screen.dart';

class CollectionsScreen extends ConsumerWidget {
  const CollectionsScreen({super.key});

  void _openNewCollectionSheet(BuildContext context) {
    showCupertinoSheet<void>(
      context: context,
      builder: (_) => const NewCollectionSheet(),
    );
  }

  void _openDetail(BuildContext context, CardCollection collection) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (_) => CollectionDetailScreen(collection: collection),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(collectionsProvider);
    final collections = state.collections;

    return CupertinoPageScaffold(
      backgroundColor: AppColors.backgroundBlue,
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(
                left: AppSpacing.screenPadding,
                right: AppSpacing.screenPadding,
                top: AppSpacing.itemGap,
              ),
              sliver: SliverToBoxAdapter(
                child: _ScreenTitle(
                  onAdd: () => _openNewCollectionSheet(context),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
                vertical: AppSpacing.itemGap,
              ),
              sliver: _CollectionsGrid(
                collections: collections,
                onCardTap: (c) => _openDetail(context, c),
                onCreateTap: () => _openNewCollectionSheet(context),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 120),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScreenTitle extends StatelessWidget {
  final VoidCallback onAdd;

  const _ScreenTitle({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Collections',
          style: AppTypography.h3Medium,
        ),
        _FloatingAddButton(onTap: onAdd),
      ],
    );
  }
}

class _FloatingAddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _FloatingAddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.accent,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.accentShadow,
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Icon(
          CupertinoIcons.plus,
          color: CupertinoColors.white,
          size: 18,
        ),
      ),
    );
  }
}

class _CollectionsGrid extends StatelessWidget {
  final List<CardCollection> collections;
  final ValueChanged<CardCollection> onCardTap;
  final VoidCallback onCreateTap;

  const _CollectionsGrid({
    required this.collections,
    required this.onCardTap,
    required this.onCreateTap,
  });

  @override
  Widget build(BuildContext context) {
    // Total items = collections + 1 create card
    final itemCount = collections.length + 1;

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.itemGap,
        crossAxisSpacing: AppSpacing.itemGap,
        childAspectRatio: 0.9,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index < collections.length) {
            final collection = collections[index];
            return CollectionGridCard(
              key: ValueKey(collection.id),
              collection: collection,
              onTap: () => onCardTap(collection),
            );
          }
          return CreateCollectionCard(onTap: onCreateTap);
        },
        childCount: itemCount,
      ),
    );
  }
}
