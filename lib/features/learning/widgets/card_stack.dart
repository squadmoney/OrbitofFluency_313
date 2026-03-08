import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../../../models/flash_card.dart';
import 'animated_card_wrapper.dart';
import 'learning_card.dart';
import 'swipe_controls.dart';

// ---------------------------------------------------------------------------
// Stack position config
// ---------------------------------------------------------------------------

class _StackPosition {
  final double scale;
  final double yOffset;
  final double opacity;

  const _StackPosition({
    required this.scale,
    required this.yOffset,
    required this.opacity,
  });
}

// ---------------------------------------------------------------------------
// CardStack — animated stacked card view
// ---------------------------------------------------------------------------

class CardStack extends StatefulWidget {
  final List<FlashCard> cards;
  final int currentIndex;
  final bool isDescriptionShown;
  final VoidCallback onToggleDescription;
  final void Function({required bool gotIt}) onNextCard;

  const CardStack({
    super.key,
    required this.cards,
    required this.currentIndex,
    required this.isDescriptionShown,
    required this.onToggleDescription,
    required this.onNextCard,
  });

  @override
  State<CardStack> createState() => _CardStackState();
}

class _CardStackState extends State<CardStack> with TickerProviderStateMixin {
  static const int _maxVisible = 3;
  static const Duration _exitDuration = Duration(milliseconds: 300);
  static const Duration _shiftDuration = Duration(milliseconds: 250);

  static const List<_StackPosition> _positions = [
    _StackPosition(scale: 1.0, yOffset: 0, opacity: 1.0),
    _StackPosition(scale: 0.96, yOffset: -10, opacity: 0.4),
    _StackPosition(scale: 0.92, yOffset: -20, opacity: 0.15),
  ];

  late final AnimationController _exitController;
  late final AnimationController _shiftController;

  bool _isAnimating = false;
  int _exitDirection = 0; // -1 = left, +1 = right

  // Snapshot of index when exit animation starts
  int _exitFromIndex = 0;

  @override
  void initState() {
    super.initState();
    _exitController = AnimationController(
      vsync: this,
      duration: _exitDuration,
    )..addStatusListener(_onExitComplete);

    _shiftController = AnimationController(
      vsync: this,
      duration: _shiftDuration,
    )..addStatusListener(_onShiftComplete);
  }

  @override
  void dispose() {
    _exitController.dispose();
    _shiftController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CardStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset animations on reviewAgain (index goes back to 0)
    if (widget.currentIndex == 0 && oldWidget.currentIndex != 0) {
      _exitController.reset();
      _shiftController.reset();
      setState(() => _isAnimating = false);
    }
  }

  // ---------------------------------------------------------------------------
  // Animation lifecycle
  // ---------------------------------------------------------------------------

  void _startExit({required bool gotIt}) {
    if (_isAnimating) return;
    setState(() {
      _isAnimating = true;
      _exitDirection = gotIt ? 1 : -1;
      _exitFromIndex = widget.currentIndex;
    });
    _exitController.forward(from: 0);
  }

  void _onExitComplete(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;
    // Update provider state
    widget.onNextCard(gotIt: _exitDirection == 1);
    // Reset exit and start shift
    _exitController.reset();
    _shiftController.forward(from: 0);
  }

  void _onShiftComplete(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;
    _shiftController.reset();
    if (mounted) {
      setState(() => _isAnimating = false);
    }
  }

  // ---------------------------------------------------------------------------
  // Position helpers
  // ---------------------------------------------------------------------------

  _StackPosition _positionAt(int depth) {
    if (depth >= _positions.length) return _positions.last;
    return _positions[depth];
  }

  _StackPosition _lerpPosition(_StackPosition from, _StackPosition to, double t) {
    return _StackPosition(
      scale: lerpDouble(from.scale, to.scale, t)!,
      yOffset: lerpDouble(from.yOffset, to.yOffset, t)!,
      opacity: lerpDouble(from.opacity, to.opacity, t)!,
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_exitController, _shiftController]),
      builder: (context, _) => _buildContent(),
    );
  }

  Widget _buildContent() {
    // During exit phase, we show cards from _exitFromIndex.
    // During shift or idle, we show from widget.currentIndex.
    final isExiting = _exitController.isAnimating;
    final isShifting = _shiftController.isAnimating;
    final baseIndex = isExiting ? _exitFromIndex : widget.currentIndex;
    final remaining = widget.cards.length - baseIndex;
    final visibleCount = remaining.clamp(0, _maxVisible);

    if (visibleCount == 0) return const SizedBox.shrink();

    // Build cards back-to-front (last added = on top in Stack)
    final children = <Widget>[];

    for (int depth = visibleCount - 1; depth >= 0; depth--) {
      final cardIndex = baseIndex + depth;
      if (cardIndex >= widget.cards.length) continue;

      final card = widget.cards[cardIndex];
      final isFront = depth == 0;

      // Compute position
      _StackPosition pos;
      double hOffset = 0;
      double exitOpacity = 1.0;

      if (isFront && isExiting) {
        // Front card exit animation
        final t = Curves.easeInCubic.transform(_exitController.value);
        pos = _positionAt(0);
        hOffset = t * _exitDirection * 400;
        exitOpacity = 1.0 - t;
      } else if (isShifting && !isFront) {
        // During shift: cards move from depth to depth-1
        final t = Curves.easeOutCubic.transform(_shiftController.value);
        pos = _lerpPosition(_positionAt(depth), _positionAt(depth - 1), t);
      } else if (isShifting && isFront) {
        // The new front card during shift phase
        final t = Curves.easeOutCubic.transform(_shiftController.value);
        pos = _lerpPosition(_positionAt(1), _positionAt(0), t);
      } else {
        pos = _positionAt(depth);
      }

      children.add(
        AnimatedCardWrapper(
          key: ValueKey(card.id),
          scale: pos.scale,
          verticalOffset: pos.yOffset,
          opacity: pos.opacity * exitOpacity,
          horizontalOffset: hOffset,
          child: IgnorePointer(
            ignoring: !isFront || _isAnimating,
            child: LearningCard(
              word: card.word,
              collection: card.collection,
              imagePath: card.imagePath,
              isDescriptionShown: isFront && !isExiting && widget.isDescriptionShown,
              onToggleDescription: widget.onToggleDescription,
            ),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: children,
        ),
        const SizedBox(height: 24),
        SwipeControls(
          onRepeat: _isAnimating ? () {} : () => _startExit(gotIt: false),
          onGotIt: _isAnimating ? () {} : () => _startExit(gotIt: true),
        ),
      ],
    );
  }
}
