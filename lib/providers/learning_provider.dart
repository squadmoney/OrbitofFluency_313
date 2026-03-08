import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/flash_card.dart';
import 'collections_provider.dart';
import 'stats_provider.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

class LearningState {
  final List<FlashCard> cards;
  final int currentIndex;
  final bool isDescriptionShown;
  final bool allReviewed;

  const LearningState({
    required this.cards,
    required this.currentIndex,
    required this.isDescriptionShown,
    required this.allReviewed,
  });

  FlashCard? get currentCard =>
      allReviewed || currentIndex >= cards.length ? null : cards[currentIndex];

  int get totalCards => cards.length;

  /// 1-based display index (capped at totalCards when all done)
  int get displayIndex =>
      allReviewed ? totalCards : (currentIndex + 1).clamp(1, totalCards);

  LearningState copyWith({
    List<FlashCard>? cards,
    int? currentIndex,
    bool? isDescriptionShown,
    bool? allReviewed,
  }) {
    return LearningState(
      cards: cards ?? this.cards,
      currentIndex: currentIndex ?? this.currentIndex,
      isDescriptionShown: isDescriptionShown ?? this.isDescriptionShown,
      allReviewed: allReviewed ?? this.allReviewed,
    );
  }
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class LearningNotifier extends StateNotifier<LearningState> {
  LearningNotifier(this._ref)
      : super(const LearningState(
          cards: [],
          currentIndex: 0,
          isDescriptionShown: false,
          allReviewed: true,
        ));

  final Ref _ref;

  void toggleDescription() {
    state = state.copyWith(isDescriptionShown: !state.isDescriptionShown);
  }

  void nextCard({required bool gotIt}) {
    // Record review result
    final card = state.currentCard;
    if (card != null) {
      _ref.read(statsProvider.notifier).recordReview(card.id, gotIt);
    }

    final nextIndex = state.currentIndex + 1;
    if (nextIndex >= state.cards.length) {
      state = state.copyWith(allReviewed: true, isDescriptionShown: false);
    } else {
      state = state.copyWith(
        currentIndex: nextIndex,
        isDescriptionShown: false,
      );
    }
  }

  void reviewAgain() {
    state = LearningState(
      cards: state.cards,
      currentIndex: 0,
      isDescriptionShown: false,
      allReviewed: false,
    );
  }

  void loadCards(List<FlashCard> cards) {
    state = LearningState(
      cards: cards,
      currentIndex: 0,
      isDescriptionShown: false,
      allReviewed: false,
    );
  }

  /// Sync card list from collections without resetting review progress.
  void syncCards(List<FlashCard> cards) {
    if (cards.isEmpty) {
      clearCards();
      return;
    }
    // First time getting cards — start a fresh session
    if (state.cards.isEmpty) {
      loadCards(cards);
      return;
    }
    // Cards changed while reviewing — update list, keep position safe
    state = state.copyWith(
      cards: cards,
      currentIndex: state.currentIndex.clamp(0, cards.length - 1),
    );
  }

  void clearCards() {
    state = const LearningState(
      cards: [],
      currentIndex: 0,
      isDescriptionShown: false,
      allReviewed: true,
    );
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final learningProvider =
    StateNotifierProvider<LearningNotifier, LearningState>(
  (ref) {
    final notifier = LearningNotifier(ref);

    // Sync cards from collections → learning on every change
    ref.listen<CollectionsState>(collectionsProvider, (_, next) {
      final allCards = next.collections.expand((c) => c.cards).toList();
      notifier.syncCards(allCards);
    });

    // Initial load
    final collections = ref.read(collectionsProvider).collections;
    final allCards = collections.expand((c) => c.cards).toList();
    if (allCards.isNotEmpty) {
      notifier.loadCards(allCards);
    }

    return notifier;
  },
);
