import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/responsive.dart';
import '../core/theme/app_colors.dart';
import '../state/quiz_controller.dart';
import '../widgets/primary_action.dart';
import '../widgets/review_tile.dart';
import '../widgets/score_dial.dart';
import '../widgets/section_label.dart';
import '../widgets/surface_card.dart';
import '../widgets/tunas_backdrop.dart';
import '../widgets/tunas_top_bar.dart';
import 'quiz_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  static const String routeName = '/result';

  void _playAgain(BuildContext context) {
    context.read<QuizController>().restart();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const QuizScreen()),
    );
  }

  void _goHome(BuildContext context) {
    context.read<QuizController>().reset();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizController>();
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final category = quiz.category;

    if (category == null || quiz.questions.isEmpty) {
      return Scaffold(
        body: TunasBackdrop(
          child: SafeArea(
            child: Center(
              child: PrimaryAction(
                label: 'Kembali ke beranda',
                expand: false,
                onPressed: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
              ),
            ),
          ),
        ),
      );
    }

    final isWide = context.viewport.width >= 900;
    final message = _messageFor(quiz.score);

    return Scaffold(
      body: TunasBackdrop(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              context.gutter,
              context.sp(10),
              context.gutter,
              context.sp(30),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 980),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TunasTopBar(
                      compactBrand: true,
                      actions: [
                        TunasIconButton(
                          icon: Icons.home_outlined,
                          tooltip: 'Kembali ke beranda',
                          onPressed: () => _goHome(context),
                        ),
                      ],
                    ),
                    SizedBox(height: context.sp(36)),
                    const SectionLabel('Kartu hasil'),
                    SizedBox(height: context.sp(14)),
                    Text(
                      'Kerja bagus,\n${quiz.playerName}.',
                      style: context.isCompact
                          ? textTheme.displaySmall
                          : textTheme.displayMedium,
                    ),
                    SizedBox(height: context.sp(10)),
                    Text(
                      '${category.name} · ${quiz.correctCount} dari '
                      '${quiz.total} jawaban tepat.',
                      style: textTheme.bodyMedium,
                    ),
                    SizedBox(height: context.sp(26)),
                    SurfaceCard(
                      padding: EdgeInsets.all(context.sp(24)),
                      child: isWide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ScoreDial(
                                  correct: quiz.correctCount,
                                  total: quiz.total,
                                ),
                                SizedBox(width: context.sp(36)),
                                Expanded(
                                  child: _Summary(
                                    message: message,
                                    quiz: quiz,
                                    onPlayAgain: () => _playAgain(context),
                                    onHome: () => _goHome(context),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Center(
                                  child: ScoreDial(
                                    correct: quiz.correctCount,
                                    total: quiz.total,
                                  ),
                                ),
                                SizedBox(height: context.sp(24)),
                                _Summary(
                                  message: message,
                                  quiz: quiz,
                                  onPlayAgain: () => _playAgain(context),
                                  onHome: () => _goHome(context),
                                ),
                              ],
                            ),
                    ),
                    SizedBox(height: context.sp(20)),
                    SurfaceCard(
                      padding: EdgeInsets.fromLTRB(
                        context.sp(22),
                        context.sp(20),
                        context.sp(22),
                        context.sp(4),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              const SectionLabel('Tinjauan jawaban'),
                              const Spacer(),
                              Text(
                                '${quiz.total} soal',
                                style: textTheme.bodySmall,
                              ),
                            ],
                          ),
                          SizedBox(height: context.sp(6)),
                          for (var i = 0; i < quiz.questions.length; i++)
                            ReviewTile(
                              number: i + 1,
                              question: quiz.questions[i],
                              selectedIndex: quiz.answerFor(quiz.questions[i]),
                              divider: i < quiz.questions.length - 1,
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.sp(20)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.eco_outlined,
                          size: 14 * context.typeScale,
                          color: palette.muted,
                        ),
                        SizedBox(width: context.sp(6)),
                        Flexible(
                          child: Text(
                            'Setiap jawaban adalah kesempatan untuk tumbuh.',
                            style: textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _messageFor(double score) {
    if (score == 1) {
      return 'Sempurna. Kamu membaca alam seperti buku terbuka.';
    }
    if (score >= 0.75) {
      return 'Kuat. Akar pengetahuanmu sudah cukup dalam.';
    }
    if (score >= 0.5) {
      return 'Tumbuh baik. Sedikit lagi menuju pemahaman penuh.';
    }
    if (score > 0) {
      return 'Setiap bibit butuh waktu. Coba lagi, pelan-pelan.';
    }
    return 'Belum apa-apa. Yang penting kamu sudah mulai.';
  }
}

class _Summary extends StatelessWidget {
  const _Summary({
    required this.message,
    required this.quiz,
    required this.onPlayAgain,
    required this.onHome,
  });

  final String message;
  final QuizController quiz;
  final VoidCallback onPlayAgain;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final scale = context.typeScale;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(message, style: textTheme.headlineSmall),
        SizedBox(height: 20 * scale),
        IntrinsicHeight(
          child: Row(
            children: [
              _ResultStat(
                value: '${quiz.correctCount}',
                label: 'benar',
                color: palette.forest,
              ),
              _ResultDivider(color: palette.line),
              _ResultStat(
                value: '${quiz.wrongCount}',
                label: 'salah',
                color: palette.clay,
              ),
              _ResultDivider(color: palette.line),
              _ResultStat(
                value: '${quiz.total}',
                label: 'total',
                color: palette.ink,
              ),
            ],
          ),
        ),
        SizedBox(height: 24 * scale),
        PrimaryAction(label: 'Main lagi', onPressed: onPlayAgain),
        SizedBox(height: 6 * scale),
        TextButton(onPressed: onHome, child: const Text('Kembali ke beranda')),
      ],
    );
  }
}

class _ResultStat extends StatelessWidget {
  const _ResultStat({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Fraunces',
              fontSize: context.sp(30),
              height: 1,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          SizedBox(height: context.sp(5)),
          Text(label, style: textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _ResultDivider extends StatelessWidget {
  const _ResultDivider({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      margin: EdgeInsets.symmetric(horizontal: context.sp(14)),
      color: color,
    );
  }
}
