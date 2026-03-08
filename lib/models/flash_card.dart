class FlashCard {
  final String id;
  final String word;
  final String collection;
  final String? imagePath;
  final String? description;

  const FlashCard({
    required this.id,
    required this.word,
    required this.collection,
    this.imagePath,
    this.description,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'word': word,
        'collection': collection,
        'imagePath': imagePath,
        'description': description,
      };

  factory FlashCard.fromJson(Map<String, dynamic> json) {
    return FlashCard(
      id: json['id'] as String,
      word: json['word'] as String,
      collection: json['collection'] as String,
      imagePath: json['imagePath'] as String?,
      description: json['description'] as String?,
    );
  }

  FlashCard copyWith({
    String? id,
    String? word,
    String? collection,
    String? imagePath,
    String? description,
    bool clearImagePath = false,
    bool clearDescription = false,
  }) {
    return FlashCard(
      id: id ?? this.id,
      word: word ?? this.word,
      collection: collection ?? this.collection,
      imagePath: clearImagePath ? null : (imagePath ?? this.imagePath),
      description: clearDescription ? null : (description ?? this.description),
    );
  }
}
