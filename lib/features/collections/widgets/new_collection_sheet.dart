import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../models/collection.dart';
import '../../../premka.dart';
import '../../../providers/collections_provider.dart';

const List<String> _emojiOptions = [
  '\u{1F4DA}',
  '\u{1F392}',
  '\u{1F3E0}',
  '\u{2B50}',
  '\u{1F525}',
  '\u{1F3AF}',
  '\u{1F30D}',
  '\u{1F4DD}',
  '\u{1F3A8}',
  '\u{1F4A1}',
  '\u{1F9E0}',
  '\u{1F4D6}',
];

class NewCollectionSheet extends ConsumerStatefulWidget {
  final CardCollection? collectionToEdit;

  const NewCollectionSheet({super.key, this.collectionToEdit});

  bool get isEditing => collectionToEdit != null;

  @override
  ConsumerState<NewCollectionSheet> createState() =>
      _NewCollectionSheetState();
}

class _NewCollectionSheetState extends ConsumerState<NewCollectionSheet> {
  late final TextEditingController _nameController;
  late String _selectedEmoji;
  late Color _selectedColor;

  bool get _isEditing => widget.isEditing;

  @override
  void initState() {
    super.initState();
    final collection = widget.collectionToEdit;
    _nameController = TextEditingController(text: collection?.name ?? '');
    _selectedEmoji = collection?.emoji ?? _emojiOptions.first;
    _selectedColor = collection?.color ?? AppColors.collectionColors.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _canSave => _nameController.text.trim().isNotEmpty;

  void _onSave() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

 

    if (_isEditing) {
      ref.read(collectionsProvider.notifier).updateCollection(
            widget.collectionToEdit!.id,
            name: name,
            emoji: _selectedEmoji,
            color: _selectedColor,
          );
    } else {
      ref.read(collectionsProvider.notifier).addCollection(
            name,
            _selectedEmoji,
            _selectedColor,
          );
    }

    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundBlue,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppSpacing.cardRadius)),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.screenPadding,
        right: AppSpacing.screenPadding,
        bottom:
            MediaQuery.of(context).viewInsets.bottom + AppSpacing.screenPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          const _DragHandle(),
          const SizedBox(height: AppSpacing.itemGap),
          Stack(
            alignment: Alignment.center,
            children: [
              Text(
                _isEditing ? 'Edit Collection' : 'New Collection',
                style: AppTypography.h3Medium,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: true).pop(),
                  child: const Icon(
                    CupertinoIcons.xmark,
                    color: AppColors.textSecondary,
                    size: AppSpacing.iconSize,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          // Form card with all fields
          _FormCard(
            children: [
              _NameField(
                controller: _nameController,
                onChanged: (_) => setState(() {}),
              ),
              const _FormDivider(),
              _EmojiSection(
                selected: _selectedEmoji,
                onSelect: (emoji) => setState(() => _selectedEmoji = emoji),
              ),
              const _FormDivider(),
              _ColorSection(
                selected: _selectedColor,
                onSelect: (color) => setState(() => _selectedColor = color),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          IgnorePointer(
            ignoring: !_canSave,
            child: Opacity(
              opacity: _canSave ? 1.0 : 0.55,
              child: AppPrimaryButton(
                label: _isEditing ? 'Update Collection' : 'Create Collection',
                onPressed: _onSave,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.smallGap),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Form card container
// ---------------------------------------------------------------------------

class _FormCard extends StatelessWidget {
  final List<Widget> children;

  const _FormCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.cardPadding),
      clipBehavior: Clip.none,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Form divider
// ---------------------------------------------------------------------------

class _FormDivider extends StatelessWidget {
  const _FormDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.screenPadding,
        horizontal: AppSpacing.cardPadding,
      ),
      child: Container(height: 1, color: AppColors.divider),
    );
  }
}

// ---------------------------------------------------------------------------
// Drag handle
// ---------------------------------------------------------------------------

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 6,
      decoration: BoxDecoration(
        color: AppColors.badgeBg,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Name field — filled style with focus border
// ---------------------------------------------------------------------------

class _NameField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _NameField({
    required this.controller,
    required this.onChanged,
  });

  @override
  State<_NameField> createState() => _NameFieldState();
}

class _NameFieldState extends State<_NameField> {
  bool _hasFocus = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name', style: AppTypography.caption),
          const SizedBox(height: AppSpacing.smallGap),
          Focus(
            onFocusChange: (hasFocus) => setState(() => _hasFocus = hasFocus),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius:
                    BorderRadius.circular(AppSpacing.listCardRadius),
                border: _hasFocus
                    ? Border.all(color: AppColors.borderFocused, width: 1.5)
                    : null,
              ),
              child: CupertinoTextField(
                controller: widget.controller,
                style: AppTypography.input,
                placeholder: 'e.g. Spanish Vocabulary',
                placeholderStyle: AppTypography.inputPlaceholder,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: null,
                onChanged: widget.onChanged,
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                textInputAction: TextInputAction.done,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Emoji section
// ---------------------------------------------------------------------------

class _EmojiSection extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;

  const _EmojiSection({
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.cardPadding),
          child: Text('Icon', style: AppTypography.caption),
        ),
        const SizedBox(height: AppSpacing.smallGap),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.cardPadding),
            itemCount: _emojiOptions.length,
            separatorBuilder: (_, _) =>
                const SizedBox(width: AppSpacing.smallGap),
            itemBuilder: (_, index) {
              final emoji = _emojiOptions[index];
              final isSelected = emoji == selected;
              return CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => onSelect(emoji),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.badgeBg : AppColors.inputBg,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(
                            color: AppColors.borderFocused, width: 1.5)
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    emoji,
                    style: const TextStyle(
                      inherit: false,
                      fontSize: 20,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Color section
// ---------------------------------------------------------------------------

class _ColorSection extends StatelessWidget {
  final Color selected;
  final ValueChanged<Color> onSelect;

  const _ColorSection({
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.cardPadding),
          child: Text('Color', style: AppTypography.caption),
        ),
        const SizedBox(height: AppSpacing.smallGap),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.cardPadding),
            itemCount: AppColors.collectionColors.length,
            separatorBuilder: (_, _) =>
                const SizedBox(width: AppSpacing.smallGap),
            itemBuilder: (_, index) {
              final color = AppColors.collectionColors[index];
              final isSelected =
                  color.toARGB32() == selected.toARGB32();
              return CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => onSelect(color),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: isSelected
                      ? const Icon(
                          CupertinoIcons.check_mark,
                          color: CupertinoColors.white,
                          size: 18,
                        )
                      : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
