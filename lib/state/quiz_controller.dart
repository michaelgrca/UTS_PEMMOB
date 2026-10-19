import 'package:flutter/foundation.dart';

import '../data/quiz_repository.dart';
import '../models/question.dart';
import '../models/quiz_category.dart';

enum QuizStatus { idle, playing, finished }

/// The single source of truth for a quiz session.
///
/// The controller is provided above the navigator, so answers, the current
/// question and the player's name survive screen rotations, route changes and
/// the app being rebuilt.
class QuizController extends ChangeNotifier {
  String _playerName = '';
  QuizCategory? _category;
  List<Question> _questions = const [];
  final Map<String, int> _answers = {};
  int _index = 0;
  QuizStatus _status = QuizStatus.idle;

  String get playerName => _playerName;
  QuizCategory? get category => _category;
  List<Question> get questions => _questions;
  Map<String, int> get answers => Map.unmodifiable(_answers);
  int get index => _index;
  QuizStatus get status => _status;

  bool get hasActiveSession =>
      _status == QuizStatus.playing && _questions.isNotEmpty;
  bool get hasPausedSession =>
      _status == QuizStatus.idle && _questions.isNotEmpty;
  bool get hasSessionInProgress =>
      _questions.isNotEmpty && _status != QuizStatus.finished;
  bool get isFinished => _status == QuizStatus.finished;
  bool get hasQuestions => _questions.isNotEmpty;

  Question get currentQuestion => _questions[_index];
  int? get selectedIndex => _answers[currentQuestion.id];
  bool get isFirst => _index == 0;
  bool get isLast => _index == _questions.length - 1;
  int get total => _questions.length;
  int get answeredCount => _answers.length;

  int get correctCount {
    var correct = 0;
    for (final question in _questions) {
      if (_answers[question.id] == question.answerIndex) correct++;
    }
    return correct;
  }

  int get wrongCount => answeredCount - correctCount;
  double get progress => total == 0 ? 0 : (_index + 1) / total;
  double get score => total == 0 ? 0 : correctCount / total;

  bool isCorrect(Question question) =>
      _answers[question.id] == question.answerIndex;

  int? answerFor(Question question) => _answers[question.id];

  /// Starts a fresh run. Any previous answers are discarded.
  void start({required String playerName, required QuizCategory category}) {
    _playerName = playerName.trim();
    _category = category;
    _questions = QuizRepository.questionsFor(category.id);
    _answers.clear();
    _index = 0;
    _status = QuizStatus.playing;
    notifyListeners();
  }

  /// Restarts the current category with the same player.
  void restart() {
    final category = _category;
    if (category == null) return;
    start(playerName: _playerName, category: category);
  }

  void selectOption(int optionIndex) {
    if (_status != QuizStatus.playing) return;
    _answers[currentQuestion.id] = optionIndex;
    notifyListeners();
  }

  void next() {
    if (_status != QuizStatus.playing) return;
    if (isLast) {
      _status = QuizStatus.finished;
    } else {
      _index++;
    }
    notifyListeners();
  }

  void previous() {
    if (_status != QuizStatus.playing || isFirst) return;
    _index--;
    notifyListeners();
  }

  /// Leaves the session without throwing the answers away, so the player can
  /// resume from the home screen later.
  void leaveSession() {
    if (_status == QuizStatus.playing) {
      _status = QuizStatus.idle;
      notifyListeners();
    }
  }

  /// Resumes a session that was left from the quiz screen.
  void resume() {
    if (_questions.isEmpty) return;
    _status = QuizStatus.playing;
    notifyListeners();
  }

  void reset() {
    _playerName = '';
    _category = null;
    _questions = const [];
    _answers.clear();
    _index = 0;
    _status = QuizStatus.idle;
    notifyListeners();
  }
}
