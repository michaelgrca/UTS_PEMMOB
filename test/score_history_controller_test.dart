import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunas_quiz/models/score_entry.dart';
import 'package:tunas_quiz/state/score_history_controller.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  ScoreEntry entry({
    required String id,
    required int correct,
    required String categoryId,
  }) {
    return ScoreEntry(
      id: id,
      playerName: 'Alya',
      categoryId: categoryId,
      categoryName: categoryId == 'rimba' ? 'Rimba & Satwa' : 'Sains Hijau',
      correct: correct,
      total: 8,
      durationSeconds: 245,
      completedAt: DateTime(2026, 10, 20, 19, 42),
    );
  }

  test('history keeps newest first and finds the best per category', () async {
    final preferences = await SharedPreferences.getInstance();
    final history = ScoreHistoryController(preferences);
    await history.load();

    await history.add(entry(id: 'lama', correct: 5, categoryId: 'rimba'));
    await history.add(entry(id: 'baru', correct: 7, categoryId: 'rimba'));
    await history.add(entry(id: 'sains', correct: 8, categoryId: 'sains'));

    expect(history.sessionCount, 3);
    expect(history.entries.first.id, 'sains');
    expect(history.bestFor('rimba')?.id, 'baru');
    expect(history.bestOverall?.id, 'sains');
    expect(history.averageRatio, closeTo(20 / 24, 0.0001));

    await history.clear();
    expect(history.sessionCount, 0);
  });

  test('history survives a new controller instance', () async {
    final preferences = await SharedPreferences.getInstance();
    final first = ScoreHistoryController(preferences);
    await first.load();
    await first.add(entry(id: 'tersimpan', correct: 6, categoryId: 'rimba'));

    final restored = ScoreHistoryController(preferences);
    await restored.load();

    expect(restored.sessionCount, 1);
    expect(restored.entries.first.id, 'tersimpan');
    expect(restored.entries.first.durationSeconds, 245);
  });
}
