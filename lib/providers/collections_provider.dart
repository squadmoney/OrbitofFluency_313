import 'dart:convert';
import 'dart:ui' show Color;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/collection.dart';
import '../models/flash_card.dart';

const _kCollectionsKey = 'collections';

// ---------------------------------------------------------------------------
// Initial data (empty – user creates collections manually)
// ---------------------------------------------------------------------------

const List<CardCollection> _initialCollections = [];

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

class CollectionsState {
  final List<CardCollection> collections;

  const CollectionsState({required this.collections});

  CollectionsState copyWith({List<CardCollection>? collections}) {
    return CollectionsState(
      collections: collections ?? this.collections,
    );
  }
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class CollectionsNotifier extends StateNotifier<CollectionsState> {
  CollectionsNotifier()
      : super(CollectionsState(collections: List.from(_initialCollections))) {
    _load();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final json = state.collections.map((c) => c.toJson()).toList();
    await prefs.setString(_kCollectionsKey, jsonEncode(json));
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kCollectionsKey);
    if (raw == null) return;
    final decoded = jsonDecode(raw) as List<dynamic>;
    final collections = decoded
        .map((e) => CardCollection.fromJson(e as Map<String, dynamic>))
        .toList();
    state = CollectionsState(collections: collections);
  }

  void addCollection(String name, String emoji, Color color) {
    final newCollection = CardCollection(
      id: 'col_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      emoji: emoji,
      color: color,
      cards: const [],
    );
    state = state.copyWith(
      collections: [...state.collections, newCollection],
    );
    _save();
  }

  void updateCollection(
    String id, {
    String? name,
    String? emoji,
    Color? color,
  }) {
    state = state.copyWith(
      collections: state.collections.map((c) {
        if (c.id == id) {
          return c.copyWith(
            name: name ?? c.name,
            emoji: emoji ?? c.emoji,
            color: color ?? c.color,
          );
        }
        return c;
      }).toList(),
    );
    _save();
  }

  void deleteCollection(String id) {
    state = state.copyWith(
      collections: state.collections.where((c) => c.id != id).toList(),
    );
    _save();
  }

  /// Returns the "Unsorted" collection, creating it if it doesn't exist.
  CardCollection getOrCreateUnsorted() {
    final existing = state.collections.where((c) => c.id == 'col_unsorted');
    if (existing.isNotEmpty) return existing.first;

    const unsorted = CardCollection(
      id: 'col_unsorted',
      name: 'Unsorted',
      emoji: '\u{1F4E5}',
      color: Color(0xFF6B7280),
      cards: [],
    );
    state = state.copyWith(
      collections: [unsorted, ...state.collections],
    );
    _save();
    return unsorted;
  }

  void addCard(String collectionId, FlashCard card) {
    state = state.copyWith(
      collections: state.collections.map((c) {
        if (c.id == collectionId) {
          return c.copyWith(cards: [...c.cards, card]);
        }
        return c;
      }).toList(),
    );
    _save();
  }

  void updateCard(String collectionId, String cardId, FlashCard updatedCard) {
    state = state.copyWith(
      collections: state.collections.map((c) {
        if (c.id == collectionId) {
          return c.copyWith(
            cards: c.cards.map((card) {
              return card.id == cardId ? updatedCard : card;
            }).toList(),
          );
        }
        return c;
      }).toList(),
    );
    _save();
  }

  void reorderCards(String collectionId, int oldIndex, int newIndex) {
    state = state.copyWith(
      collections: state.collections.map((c) {
        if (c.id == collectionId) {
          final cards = List<FlashCard>.from(c.cards);
          final card = cards.removeAt(oldIndex);
          cards.insert(newIndex, card);
          return c.copyWith(cards: cards);
        }
        return c;
      }).toList(),
    );
    _save();
  }

  void deleteCard(String collectionId, String cardId) {
    state = state.copyWith(
      collections: state.collections.map((c) {
        if (c.id == collectionId) {
          return c.copyWith(
            cards: c.cards.where((card) => card.id != cardId).toList(),
          );
        }
        return c;
      }).toList(),
    );
    _save();
  }

  void clearAll() {
    state = const CollectionsState(collections: []);
    _save();
  }

  void loadCollections(List<CardCollection> collections) {
    state = CollectionsState(collections: collections);
    _save();
  }

  List<FlashCard> searchCards(String collectionId, String query) {
    final collectionIndex =
        state.collections.indexWhere((c) => c.id == collectionId);
    if (collectionIndex == -1) return const [];
    final collection = state.collections[collectionIndex];
    if (query.isEmpty) return collection.cards;
    final lower = query.toLowerCase();
    return collection.cards.where((card) {
      return card.word.toLowerCase().contains(lower) ||
          (card.description?.toLowerCase().contains(lower) ?? false);
    }).toList();
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final collectionsProvider =
    StateNotifierProvider<CollectionsNotifier, CollectionsState>(
  (ref) => CollectionsNotifier(),
);
