import 'package:flutter/cupertino.dart';

import 'flash_card.dart';

class CardCollection {
  final String id;
  final String name;
  final String emoji;
  final Color color;
  final List<FlashCard> cards;

  const CardCollection({
    required this.id,
    required this.name,
    required this.emoji,
    required this.color,
    required this.cards,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'emoji': emoji,
        'color': color.toARGB32(),
        'cards': cards.map((c) => c.toJson()).toList(),
      };

  factory CardCollection.fromJson(Map<String, dynamic> json) {
    return CardCollection(
      id: json['id'] as String,
      name: json['name'] as String,
      emoji: json['emoji'] as String,
      color: Color(json['color'] as int),
      cards: (json['cards'] as List<dynamic>)
          .map((e) => FlashCard.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  CardCollection copyWith({
    String? id,
    String? name,
    String? emoji,
    Color? color,
    List<FlashCard>? cards,
  }) {
    return CardCollection(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      color: color ?? this.color,
      cards: cards ?? this.cards,
    );
  }
}
