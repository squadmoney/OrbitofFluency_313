import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../models/collection.dart';
import '../../../models/flash_card.dart';
import '../../../premka.dart';
import '../../../providers/collections_provider.dart';
import '../widgets/collection_dropdown.dart';
import '../widgets/image_picker_area.dart';

class NewCardScreen extends ConsumerStatefulWidget {
  final FlashCard? cardToEdit;
  final String? collectionId;

  const NewCardScreen({
    super.key,
    this.cardToEdit,
    this.collectionId,
  });

  bool get isEditing => cardToEdit != null;

  @override
  ConsumerState<NewCardScreen> createState() => _NewCardScreenState();
}

class _NewCardScreenState extends ConsumerState<NewCardScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  String? _imagePath;
  CardCollection? _selectedCollection;

  bool get _isEditing => widget.isEditing;

  @override
  void initState() {
    super.initState();
    final card = widget.cardToEdit;
    _titleController = TextEditingController(text: card?.word ?? '');
    _descriptionController = TextEditingController(text: card?.description ?? '');
    if (card != null) {
      _imagePath = card.imagePath;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool get _canSave {
    if (_titleController.text.trim().isEmpty) return false;
    if (_isEditing) return true;
    // Allow save even without selection — will auto-create "Unsorted"
    return true;
  }

  void _onTitleChanged(String _) => setState(() {});

  void _onCollectionSelected(CardCollection collection) {
    setState(() => _selectedCollection = collection);
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1200,
    );
    if (file != null) {
      setState(() => _imagePath = file.path);
    }
  }

  void _showImageSourceSheet() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(ctx).pop();
              _pickImage(ImageSource.camera);
            },
            child: const Text('Take Photo'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(ctx).pop();
              _pickImage(ImageSource.gallery);
            },
            child: const Text('Choose from Library'),
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

  void _saveCard() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (_isEditing) {
      final existingCard = widget.cardToEdit!;
      final collectionId = widget.collectionId!;

      final updatedCard = FlashCard(
        id: existingCard.id,
        word: title,
        collection: existingCard.collection,
        imagePath: _imagePath?.isNotEmpty == true ? _imagePath : null,
        description: description.isNotEmpty ? description : null,
      );

      ref.read(collectionsProvider.notifier).updateCard(collectionId, existingCard.id, updatedCard);

      Navigator.of(context).pop();
      return;
    }

    if (title.isEmpty) return;

    final notifier = ref.read(collectionsProvider.notifier);
    final collection = _selectedCollection ?? notifier.getOrCreateUnsorted();



    final card = FlashCard(
      id: 'card_${DateTime.now().millisecondsSinceEpoch}',
      word: title,
      collection: collection.name,
      imagePath: _imagePath?.isNotEmpty == true ? _imagePath : null,
      description: description.isNotEmpty ? description : null,
    );

    ref.read(collectionsProvider.notifier).addCard(collection.id, card);

    // Reset form
    setState(() {
      _titleController.clear();
      _descriptionController.clear();
      _imagePath = null;
      _selectedCollection = null;
    });

    FocusScope.of(context).unfocus();

    // Show confirmation
    showCupertinoDialog<void>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Card Saved'),
        content: Text('"$title" was added to ${collection.name}.'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final collections = ref.watch(collectionsProvider).collections;

    return CupertinoPageScaffold(
      backgroundColor: AppColors.backgroundBlue,
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          _isEditing ? 'Edit Card' : 'New Card',
          style: AppTypography.h3Medium,
        ),
        backgroundColor: AppColors.backgroundBlue,
        border: null,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: SafeArea(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                  vertical: AppSpacing.screenPadding,
                ),
                children: [
                  // Image section
                  ImagePickerArea(
                    imagePath: _imagePath,
                    onTap: _showImageSourceSheet,
                  ),
                  const SizedBox(height: AppSpacing.screenPadding),
                  // Form card with all fields
                  _FormCard(
                    children: [
                      _TitleFieldWidget(
                        controller: _titleController,
                        onChanged: _onTitleChanged,
                      ),
                      const _FormDivider(),
                      _DescriptionFieldWidget(
                        controller: _descriptionController,
                      ),
                      if (!_isEditing) ...[
                        const _FormDivider(),
                        CollectionDropdown(
                          collections: collections,
                          selected: _selectedCollection,
                          onSelect: _onCollectionSelected,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 24),
                  _SaveButtonSection(
                    canSave: _canSave,
                    onSave: _saveCard,
                    label: _isEditing ? 'Update Card' : 'Save Card',
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),

          // Fixed save button at bottom
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Form card container — groups all fields
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
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Divider between form sections inside the card
// ---------------------------------------------------------------------------

class _FormDivider extends StatelessWidget {
  const _FormDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.screenPadding),
      child: Container(height: 1, color: AppColors.divider),
    );
  }
}

// ---------------------------------------------------------------------------
// Save button section — pinned at bottom
// ---------------------------------------------------------------------------

class _SaveButtonSection extends StatelessWidget {
  final bool canSave;
  final VoidCallback onSave;
  final String label;

  const _SaveButtonSection({
    required this.canSave,
    required this.onSave,
    this.label = 'Save Card',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundBlue,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.smallGap,
        AppSpacing.screenPadding,
        MediaQuery.of(context).padding.bottom + AppSpacing.screenPadding,
      ),
      child: Opacity(
        opacity: canSave ? 1.0 : 0.4,
        child: AppPrimaryButton(
          label: label,
          onPressed: canSave ? onSave : null,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Title field — filled style with focus border
// ---------------------------------------------------------------------------

class _TitleFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _TitleFieldWidget({
    required this.controller,
    required this.onChanged,
  });

  @override
  State<_TitleFieldWidget> createState() => _TitleFieldWidgetState();
}

class _TitleFieldWidgetState extends State<_TitleFieldWidget> {
  bool _hasFocus = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Title', style: AppTypography.caption),
        const SizedBox(height: AppSpacing.smallGap),
        Focus(
          onFocusChange: (hasFocus) => setState(() => _hasFocus = hasFocus),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.inputBg,
              borderRadius: BorderRadius.circular(AppSpacing.listCardRadius),
              border: _hasFocus ? Border.all(color: AppColors.borderFocused, width: 1.5) : null,
            ),
            child: CupertinoTextField(
              controller: widget.controller,
              style: AppTypography.input,
              placeholder: 'Word or term',
              placeholderStyle: AppTypography.inputPlaceholder,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: null,
              onChanged: widget.onChanged,
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              textInputAction: TextInputAction.next,
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Description field — filled style with focus border
// ---------------------------------------------------------------------------

class _DescriptionFieldWidget extends StatefulWidget {
  final TextEditingController controller;

  const _DescriptionFieldWidget({required this.controller});

  @override
  State<_DescriptionFieldWidget> createState() => _DescriptionFieldWidgetState();
}

class _DescriptionFieldWidgetState extends State<_DescriptionFieldWidget> {
  bool _hasFocus = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Description', style: AppTypography.caption),
        const SizedBox(height: AppSpacing.smallGap),
        Focus(
          onFocusChange: (hasFocus) => setState(() => _hasFocus = hasFocus),
          child: Container(
            height: 148,
            decoration: BoxDecoration(
              color: AppColors.inputBg,
              borderRadius: BorderRadius.circular(AppSpacing.listCardRadius),
              border: _hasFocus ? Border.all(color: AppColors.borderFocused, width: 1.5) : null,
            ),
            child: CupertinoTextField(
              controller: widget.controller,
              style: AppTypography.input,
              placeholder: 'Translation, meaning, or association...',
              placeholderStyle: AppTypography.inputPlaceholder,
              padding: const EdgeInsets.all(14),
              decoration: null,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
            ),
          ),
        ),
      ],
    );
  }
}
