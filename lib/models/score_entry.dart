import 'package:flutter/foundation.dart';

/// One completed quiz attempt, kept entirely on the device.
@immutable
class ScoreEntry {
  const ScoreEntry({
    required this.id,
    required this.playerName,
    required this.categoryId,
    required this.categoryName,
    required this.correct,
    required this.total,
    required this.durationSeconds,
    required this.completedAt,
  });

  final String id;
  final String playerName;
  final String categoryId;
  final String categoryName;
  final int correct;
  final int total;
  final int durationSeconds;
  final DateTime completedAt;

  double get ratio => total == 0 ? 0 : correct / total;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'playerName': playerName,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'correct': correct,
      'total': total,
      'durationSeconds': durationSeconds,
      'completedAt': completedAt.toIso8601String(),
    };
  }

  factory ScoreEntry.fromJson(Map<String, dynamic> json) {
    return ScoreEntry(
      id: json['id'] as String? ?? '${json['completedAt']}',
      playerName: json['playerName'] as String? ?? 'Pemain',
      categoryId: json['categoryId'] as String? ?? 'lainnya',
      categoryName: json['categoryName'] as String? ?? 'Kuis',
      correct: (json['correct'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      durationSeconds: (json['durationSeconds'] as num?)?.toInt() ?? 0,
      completedAt:
          DateTime.tryParse(json['completedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
