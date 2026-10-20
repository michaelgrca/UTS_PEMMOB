import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/score_entry.dart';

/// Stores completed attempts as JSON in [SharedPreferences]. This is local
/// history only: there is still no account, server or database.
class ScoreHistoryController extends ChangeNotifier {
  ScoreHistoryController(this._preferences);

  static const String storageKey = 'tunas.score_history.v1';
  static const int _maxEntries = 50;

  final SharedPreferences _preferences;
  List<ScoreEntry> _entries = const [];
  bool _loaded = false;
  Future<void>? _loading;

  List<ScoreEntry> get entries => List.unmodifiable(_entries);
  bool get isLoaded => _loaded;
  int get sessionCount => _entries.length;

  int get totalCorrect =>
      _entries.fold(0, (total, entry) => total + entry.correct);

  int get totalQuestions =>
      _entries.fold(0, (total, entry) => total + entry.total);

  double get averageRatio =>
      totalQuestions == 0 ? 0 : totalCorrect / totalQuestions;

  ScoreEntry? get bestOverall {
    ScoreEntry? best;
    for (final entry in _entries) {
      if (best == null || entry.ratio > best.ratio) best = entry;
    }
    return best;
  }

  ScoreEntry? bestFor(String categoryId) {
    ScoreEntry? best;
    for (final entry in _entries) {
      if (entry.categoryId != categoryId) continue;
      if (best == null || entry.ratio > best.ratio) best = entry;
    }
    return best;
  }

  Future<void> load() {
    if (_loaded) return Future.value();
    return _loading ??= _load();
  }

  Future<void> _load() async {
    try {
      final raw = _preferences.getString(storageKey);
      if (raw != null) {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          _entries = decoded
              .whereType<Map>()
              .map(
                (item) => ScoreEntry.fromJson(
                  item.map((key, value) => MapEntry(key.toString(), value)),
                ),
              )
              .toList(growable: false);
        }
      }
    } catch (_) {
      // A corrupt or older storage payload should never block the quiz.
      _entries = const [];
    } finally {
      _loaded = true;
      _loading = null;
      notifyListeners();
    }
  }

  Future<void> add(ScoreEntry entry) async {
    await load();
    _entries = [entry, ..._entries];
    if (_entries.length > _maxEntries) {
      _entries = _entries.sublist(0, _maxEntries);
    }
    notifyListeners();
    await _persist();
  }

  Future<void> clear() async {
    _entries = const [];
    _loaded = true;
    notifyListeners();
    await _preferences.remove(storageKey);
  }

  Future<void> _persist() async {
    final raw = jsonEncode(
      _entries.map((entry) => entry.toJson()).toList(growable: false),
    );
    await _preferences.setString(storageKey, raw);
  }
}
