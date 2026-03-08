import 'package:flutter/cupertino.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../models/collection.dart';

/// A dropdown field that shows the selected collection and expands
/// to show a list of available collections when tapped.
class CollectionDropdown extends StatefulWidget {
  final List<CardCollection> collections;
  final CardCollection? selected;
  final ValueChanged<CardCollection> onSelect;

  const CollectionDropdown({
    super.key,
    required this.collections,
    required this.selected,
    required this.onSelect,
  });

  @override
  State<CollectionDropdown> createState() => _CollectionDropdownState();
}

class _CollectionDropdownState extends State<CollectionDropdown> {
  late final ExpansibleController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ExpansibleController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _select(CardCollection collection) {
    widget.onSelect(collection);
    _controller.collapse();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Collection', style: AppTypography.caption),
        const SizedBox(height: AppSpacing.smallGap),
        CupertinoExpansionTile(
          controller: _controller,
          transitionMode: ExpansionTileTransitionMode.scroll,
          title: Text(
            widget.selected?.name ?? 'Select a collection',
            style: widget.selected != null
                ? AppTypography.input
                : AppTypography.inputPlaceholder,
          ),
          child: widget.collections.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(AppSpacing.cardPadding),
                  child: Text(
                    'No collections yet',
                    style: AppTypography.inputPlaceholder,
                  ),
                )
              : CupertinoListSection.insetGrouped(
                  margin: EdgeInsets.zero,
                  backgroundColor: CupertinoColors.transparent,
                  children: [
                    for (final collection in widget.collections)
                      _CollectionTile(
                        collection: collection,
                        isSelected: widget.selected?.id == collection.id,
                        onTap: () => _select(collection),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Collection list tile — used inside the expansion tile
// ---------------------------------------------------------------------------

class _CollectionTile extends StatelessWidget {
  final CardCollection collection;
  final bool isSelected;
  final VoidCallback onTap;

  const _CollectionTile({
    required this.collection,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      onTap: onTap,
      leading: Text(
        collection.emoji,
        style: const TextStyle(inherit: false, fontSize: 18),
      ),
      title: Text(
        collection.name,
        style: AppTypography.input.copyWith(
          color: isSelected ? AppColors.accent : AppColors.textPrimary,
        ),
      ),
      trailing: isSelected
          ? const Icon(
              CupertinoIcons.check_mark,
              size: 16,
              color: AppColors.accent,
            )
          : null,
    );
  }
}
