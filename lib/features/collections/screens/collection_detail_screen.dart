import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show ReorderableListView;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../models/collection.dart';
import '../../../models/flash_card.dart';
import '../../../providers/collections_provider.dart';
import '../widgets/card_list_item.dart';
import '../widgets/new_collection_sheet.dart';
import '../../new_card/screens/new_card_screen.dart';
import '../widgets/collection_empty_state.dart';

class CollectionDetailScreen extends ConsumerStatefulWidget {
  final CardCollection collection;

  const CollectionDetailScreen({
    super.key,
    required this.collection,
  });

  @override
  ConsumerState<CollectionDetailScreen> createState() =>
      _CollectionDetailScreenState();
}

class _CollectionDetailScreenState
    extends ConsumerState<CollectionDetailScreen> {
  late final TextEditingController _searchController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FlashCard> _filteredCards(CardCollection collection) {
    if (_searchQuery.isEmpty) return collection.cards;
    final lower = _searchQuery.toLowerCase();
    return collection.cards.where((card) {
      return card.word.toLowerCase().contains(lower) ||
          (card.description?.toLowerCase().contains(lower) ?? false);
    }).toList();
  }

  void _confirmDelete(BuildContext context) {
    showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Delete Collection'),
        content: const Text(
            'This will permanently delete the collection and all its cards.'),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () =>
                Navigator.of(ctx, rootNavigator: true).pop(false),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(ctx, rootNavigator: true).pop(true);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true && context.mounted) {
        ref
            .read(collectionsProvider.notifier)
            .deleteCollection(widget.collection.id);
        Navigator.of(context).pop();
      }
    });
  }

  void _showCollectionActions(CardCollection collection) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(ctx).pop();
              showCupertinoSheet<void>(
                context: context,
                builder: (_) =>
                    NewCollectionSheet(collectionToEdit: collection),
              );
            },
            child: const Text('Edit Collection'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(ctx).pop();
              _confirmDelete(context);
            },
            child: const Text('Delete Collection'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  void _navigateToNewCard(String collectionId) {
    Navigator.of(context).push(
      CupertinoPageRoute<void>(
        builder: (_) => NewCardScreen(collectionId: collectionId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(collectionsProvider);
    final liveCollection = state.collections.firstWhere(
      (c) => c.id == widget.collection.id,
      orElse: () => widget.collection,
    );
    final filteredCards = _filteredCards(liveCollection);

    return CupertinoPageScaffold(
      backgroundColor: AppColors.backgroundBlue,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.backgroundBlue,
        border: null,
        middle: Text(
          liveCollection.name,
          style: AppTypography.h3Medium,
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => _showCollectionActions(liveCollection),
          child: const Icon(
            CupertinoIcons.ellipsis,
            color: AppColors.textPrimary,
            size: AppSpacing.iconSize,
          ),
        ),
      ),
      child: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Header card + search
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    AppSpacing.smallGap,
                    AppSpacing.screenPadding,
                    0,
                  ),
                  child: Column(
                    children: [
                      _CollectionHeaderCard(collection: liveCollection),
                      const SizedBox(height: AppSpacing.itemGap),
                      if (liveCollection.cards.isNotEmpty)
                        _SearchBar(
                          controller: _searchController,
                          onChanged: (q) =>
                              setState(() => _searchQuery = q),
                        ),
                    ],
                  ),
                ),
                if (liveCollection.cards.isNotEmpty)
                  const SizedBox(height: AppSpacing.smallGap),
                // Cards list
                Expanded(
                  child: liveCollection.cards.isEmpty
                      ? const CollectionEmptyState()
                      : filteredCards.isEmpty
                          ? const _NoResultsView()
                          : _CardsList(
                              cards: filteredCards,
                              collectionId: liveCollection.id,
                              isFiltered: _searchQuery.isNotEmpty,
                            ),
                ),
              ],
            ),
          ),
          // Floating add button
          Positioned(
            right: AppSpacing.screenPadding,
            bottom: MediaQuery.of(context).padding.bottom +
                AppSpacing.screenPadding,
            child: _AddCardButton(
              onPressed: () => _navigateToNewCard(liveCollection.id),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Collection header card — emoji, name, card count
// ---------------------------------------------------------------------------

class _CollectionHeaderCard extends StatelessWidget {
  final CardCollection collection;

  const _CollectionHeaderCard({required this.collection});

  @override
  Widget build(BuildContext context) {
    final cardCount = collection.cards.length;
    final label = cardCount == 1 ? 'card' : 'cards';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.listCardRadius),
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: collection.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSpacing.listCardRadius),
            ),
            alignment: Alignment.center,
            child: Text(
              collection.emoji,
              style: const TextStyle(fontSize: 24, inherit: false),
            ),
          ),
          const SizedBox(width: AppSpacing.itemGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  collection.name,
                  style: AppTypography.bodyBold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '$cardCount $label',
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
          Container(
            width: 6,
            height: 48,
            decoration: BoxDecoration(
              color: collection.color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Search bar with focus animation
// ---------------------------------------------------------------------------

class _SearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchBar({
    required this.controller,
    required this.onChanged,
  });

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  bool _hasFocus = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) => setState(() => _hasFocus = hasFocus),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppSpacing.listCardRadius),
          boxShadow: AppShadows.card,
          border: _hasFocus
              ? Border.all(color: AppColors.borderFocused, width: 1.5)
              : null,
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                CupertinoIcons.search,
                color: AppColors.textSecondary,
                size: AppSpacing.iconSize,
              ),
            ),
            Expanded(
              child: CupertinoTextField(
                controller: widget.controller,
                style: AppTypography.input,
                placeholder: 'Search cards...',
                placeholderStyle: AppTypography.inputPlaceholder,
                padding: EdgeInsets.zero,
                decoration: null,
                onChanged: widget.onChanged,
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
              ),
            ),
            if (widget.controller.text.isNotEmpty)
              CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: const Size(28, 28),
                onPressed: () {
                  widget.controller.clear();
                  widget.onChanged('');
                  FocusScope.of(context).unfocus();
                },
                child: const Icon(
                  CupertinoIcons.xmark_circle_fill,
                  color: AppColors.textSecondary,
                  size: AppSpacing.iconSizeSm,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Floating add card button
// ---------------------------------------------------------------------------

class _AddCardButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _AddCardButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          boxShadow: AppShadows.plusButton,
        ),
        alignment: Alignment.center,
        child: const Icon(
          CupertinoIcons.add,
          color: CupertinoColors.white,
          size: AppSpacing.iconSizeLg,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Cards list — reorderable or filtered
// ---------------------------------------------------------------------------

class _CardsList extends ConsumerWidget {
  final List<FlashCard> cards;
  final String collectionId;
  final bool isFiltered;

  const _CardsList({
    required this.cards,
    required this.collectionId,
    this.isFiltered = false,
  });

  void _showCardActions(
    BuildContext context,
    WidgetRef ref,
    FlashCard card,
  ) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).push(
                CupertinoPageRoute<void>(
                  builder: (_) => NewCardScreen(
                    cardToEdit: card,
                    collectionId: collectionId,
                  ),
                ),
              );
            },
            child: const Text('Edit'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(ctx).pop();
              ref
                  .read(collectionsProvider.notifier)
                  .deleteCard(collectionId, card.id);
            },
            child: const Text('Delete'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isFiltered) {
      return ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
          vertical: AppSpacing.smallGap,
        ),
        itemCount: cards.length,
        separatorBuilder: (_, _) =>
            const SizedBox(height: AppSpacing.itemGap),
        itemBuilder: (_, index) {
          final card = cards[index];
          return CardListItem(
            key: ValueKey(card.id),
            card: card,
            onTap: () {
              Navigator.of(context).push(
                CupertinoPageRoute<void>(
                  builder: (_) => NewCardScreen(
                    cardToEdit: card,
                    collectionId: collectionId,
                  ),
                ),
              );
            },
            onMore: () => _showCardActions(context, ref, card),
          );
        },
      );
    }

    return ReorderableListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.smallGap,
      ),
      proxyDecorator: (child, index, animation) => child,
      itemCount: cards.length,
      onReorder: (oldIndex, newIndex) {
        if (newIndex > oldIndex) newIndex--;
        ref
            .read(collectionsProvider.notifier)
            .reorderCards(collectionId, oldIndex, newIndex);
      },
      itemBuilder: (_, index) {
        final card = cards[index];
        return Padding(
          key: ValueKey(card.id),
          padding: EdgeInsets.only(
            bottom: index < cards.length - 1 ? AppSpacing.itemGap : 0,
          ),
          child: CardListItem(
            card: card,
            dragIndex: index,
            onTap: () {
              Navigator.of(context).push(
                CupertinoPageRoute<void>(
                  builder: (_) => NewCardScreen(
                    cardToEdit: card,
                    collectionId: collectionId,
                  ),
                ),
              );
            },
            onMore: () => _showCardActions(context, ref, card),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// No results — search yielded nothing
// ---------------------------------------------------------------------------

class _NoResultsView extends StatelessWidget {
  const _NoResultsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.inputBg,
              borderRadius: BorderRadius.circular(AppSpacing.listCardRadius),
            ),
            alignment: Alignment.center,
            child: const Icon(
              CupertinoIcons.search,
              color: AppColors.textSecondary,
              size: 28,
            ),
          ),
          const SizedBox(height: AppSpacing.itemGap),
          Text(
            'No cards found',
            style: AppTypography.bodyBold,
          ),
          const SizedBox(height: AppSpacing.tinyGap),
          Text(
            'Try a different search term',
            style: AppTypography.caption,
          ),
        ],
      ),
    );
  }
}
