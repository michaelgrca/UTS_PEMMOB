import 'package:flutter_test/flutter_test.dart';
import 'package:tunas_quiz/data/quiz_repository.dart';
import 'package:tunas_quiz/state/quiz_controller.dart';

void main() {
  test('answers survive leaving and resuming a session', () {
    final quiz = QuizController()
      ..start(playerName: 'Alya', category: QuizRepository.categories.first);

    quiz.selectOption(quiz.currentQuestion.answerIndex);
    quiz.next();
    quiz.leaveSession();

    expect(quiz.hasPausedSession, isTrue);
    expect(quiz.playerName, 'Alya');

    quiz.resume();

    expect(quiz.answeredCount, 1);
    expect(quiz.correctCount, 1);
    expect(quiz.index, 1);
  });

  test('finishing a session keeps the final score', () {
    final quiz = QuizController()
      ..start(playerName: 'Bima', category: QuizRepository.categories.first);

    while (!quiz.isLast) {
      quiz.selectOption(quiz.currentQuestion.answerIndex);
      quiz.next();
    }
    quiz.selectOption(quiz.currentQuestion.answerIndex);
    quiz.next();

    expect(quiz.isFinished, isTrue);
    expect(quiz.correctCount, quiz.total);
    expect(quiz.score, 1);
  });
}
