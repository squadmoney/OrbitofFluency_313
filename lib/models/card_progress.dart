class CardProgress {
  final String cardId;
  final int correctCount;
  final int incorrectCount;
  final int streak;
  final DateTime? lastReviewedAt;

  const CardProgress({
    required this.cardId,
    this.correctCount = 0,
    this.incorrectCount = 0,
    this.streak = 0,
    this.lastReviewedAt,
  });

  int get totalReviews => correctCount + incorrectCount;
  double get accuracy => totalReviews > 0 ? correctCount / totalReviews : 0;
  bool get isMastered => streak >= 3;

  CardProgress copyWith({
    String? cardId,
    int? correctCount,
    int? incorrectCount,
    int? streak,
    DateTime? lastReviewedAt,
  }) {
    return CardProgress(
      cardId: cardId ?? this.cardId,
      correctCount: correctCount ?? this.correctCount,
      incorrectCount: incorrectCount ?? this.incorrectCount,
      streak: streak ?? this.streak,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'cardId': cardId,
        'correctCount': correctCount,
        'incorrectCount': incorrectCount,
        'streak': streak,
        'lastReviewedAt': lastReviewedAt?.toIso8601String(),
      };

  factory CardProgress.fromJson(Map<String, dynamic> json) {
    return CardProgress(
      cardId: json['cardId'] as String,
      correctCount: json['correctCount'] as int? ?? 0,
      incorrectCount: json['incorrectCount'] as int? ?? 0,
      streak: json['streak'] as int? ?? 0,
      lastReviewedAt: json['lastReviewedAt'] != null
          ? DateTime.tryParse(json['lastReviewedAt'] as String)
          : null,
    );
  }
}
