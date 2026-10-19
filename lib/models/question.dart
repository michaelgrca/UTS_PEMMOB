import 'package:flutter/foundation.dart';

/// One multiple-choice question. Options are stored in display order and
/// [answerIndex] points at the correct one.
@immutable
class Question {
  const Question({
    required this.id,
    required this.prompt,
    required this.options,
    required this.answerIndex,
    required this.note,
  }) : assert(answerIndex >= 0 && answerIndex < 4);

  final String id;
  final String prompt;
  final List<String> options;
  final int answerIndex;

  /// Short explanation revealed in the result review.
  final String note;

  String get answer => options[answerIndex];

  static const List<String> optionKeys = ['A', 'B', 'C', 'D'];
}
