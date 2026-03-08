import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/card_progress.dart';

const _kProgressKey = 'card_progress';
const _kDailyActivityKey = 'daily_activity';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

class StatsState {
  /// Per-card progress keyed by cardId.
  final Map<String, CardProgress> progress;

  /// Daily review counts keyed by date string (yyyy-MM-dd).
  final Map<String, int> dailyActivity;

  const StatsState({
    this.progress = const {},
    this.dailyActivity = const {},
  });

  StatsState copyWith({
    Map<String, CardProgress>? progress,
    Map<String, int>? dailyActivity,
  }) {
    return StatsState(
      progress: progress ?? this.progress,
      dailyActivity: dailyActivity ?? this.dailyActivity,
    );
  }

  // -- Computed helpers ----------------------------------------------------

  int get masteredCount => progress.values.where((p) => p.isMastered).length;

  int get dayStreak {
    if (dailyActivity.isEmpty) return 0;
    var streak = 0;
    var day = DateTime.now();
    // Check today first; if no activity today, start from yesterday
    final todayKey = _dateKey(day);
    if (!dailyActivity.containsKey(todayKey)) {
      day = day.subtract(const Duration(days: 1));
    }
    while (dailyActivity.containsKey(_dateKey(day))) {
      streak++;
      day = day.subtract(const Duration(days: 1));
    }
    return streak;
  }

  /// Returns review counts for the last 7 days (Mon index 0 … Sun index 6),
  /// aligned to the current week.
  List<int> get weeklyActivity {
    final now = DateTime.now();
    // Monday of current week
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (i) {
      final day = monday.add(Duration(days: i));
      return dailyActivity[_dateKey(day)] ?? 0;
    });
  }

  int masteredInCollection(List<String> cardIds) {
    return cardIds.where((id) => progress[id]?.isMastered ?? false).length;
  }

  static String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class StatsNotifier extends StateNotifier<StatsState> {
  StatsNotifier() : super(const StatsState()) {
    _load();
  }

  void recordReview(String cardId, bool gotIt) {
    final existing = state.progress[cardId] ??
        CardProgress(cardId: cardId);

    final updated = existing.copyWith(
      correctCount: existing.correctCount + (gotIt ? 1 : 0),
      incorrectCount: existing.incorrectCount + (gotIt ? 0 : 1),
      streak: gotIt ? existing.streak + 1 : 0,
      lastReviewedAt: DateTime.now(),
    );

    final newProgress = Map<String, CardProgress>.from(state.progress)
      ..[cardId] = updated;

    // Bump daily activity
    final todayKey = StatsState._dateKey(DateTime.now());
    final newDaily = Map<String, int>.from(state.dailyActivity);
    newDaily[todayKey] = (newDaily[todayKey] ?? 0) + 1;

    state = state.copyWith(progress: newProgress, dailyActivity: newDaily);
    _save();
  }

  // -- Persistence ---------------------------------------------------------

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();

    final progressJson = state.progress.map(
      (k, v) => MapEntry(k, v.toJson()),
    );
    await prefs.setString(_kProgressKey, jsonEncode(progressJson));
    await prefs.setString(_kDailyActivityKey, jsonEncode(state.dailyActivity));
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();

    // Progress
    final progressRaw = prefs.getString(_kProgressKey);
    var progress = <String, CardProgress>{};
    if (progressRaw != null) {
      final decoded = jsonDecode(progressRaw) as Map<String, dynamic>;
      progress = decoded.map(
        (k, v) => MapEntry(k, CardProgress.fromJson(v as Map<String, dynamic>)),
      );
    }

    // Daily activity
    final dailyRaw = prefs.getString(_kDailyActivityKey);
    var daily = <String, int>{};
    if (dailyRaw != null) {
      final decoded = jsonDecode(dailyRaw) as Map<String, dynamic>;
      daily = decoded.map((k, v) => MapEntry(k, v as int));
    }

    state = StatsState(progress: progress, dailyActivity: daily);
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final statsProvider = StateNotifierProvider<StatsNotifier, StatsState>(
  (ref) => StatsNotifier(),
);
