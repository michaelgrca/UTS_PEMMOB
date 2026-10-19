import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/responsive.dart';
import '../core/theme/app_colors.dart';
import '../state/quiz_controller.dart';
import '../widgets/primary_action.dart';
import '../widgets/progress_segments.dart';
import '../widgets/quiz_option_tile.dart';
import '../widgets/surface_card.dart';
import '../widgets/tunas_backdrop.dart';
import '../widgets/tunas_top_bar.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  static const String routeName = '/quiz';

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final ScrollController _scrollController = ScrollController();
  late final QuizController _quiz;
  late int _lastIndex;

  @override
  void initState() {
    super.initState();
    _quiz = context.read<QuizController>();
    _lastIndex = _quiz.index;
    _quiz.addListener(_handleQuizChange);
  }

  @override
  void dispose() {
    _quiz.removeListener(_handleQuizChange);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleQuizChange() {
    if (_quiz.index == _lastIndex) return;
    _lastIndex = _quiz.index;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
      );
    });
  }

  Future<void> _confirmExit() async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final palette = dialogContext.palette;
        return AlertDialog(
          backgroundColor: palette.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: palette.line),
          ),
          title: const Text('Keluar sebentar?'),
          content: const Text(
            'Jawabanmu tetap tersimpan, jadi kamu bisa melanjutkan kapan saja.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Tetap di sini'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );

    if (leave != true || !mounted) return;
    context.read<QuizController>().leaveSession();
    Navigator.of(context).pop();
  }

  void _next() {
    final quiz = context.read<QuizController>();
    if (quiz.selectedIndex == null) return;

    final wasLast = quiz.isLast;
    quiz.next();
    if (wasLast && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const ResultScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizController>();

    if (!quiz.hasQuestions) {
      return Scaffold(
        body: TunasBackdrop(
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Sesi kuis tidak ditemukan.'),
                  SizedBox(height: context.sp(16)),
                  PrimaryAction(
                    label: 'Kembali ke beranda',
                    expand: false,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final question = quiz.currentQuestion;
    final selected = quiz.selectedIndex;
    final category = quiz.category!;

    return Scaffold(
      body: TunasBackdrop(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  context.gutter,
                  context.sp(10),
                  context.gutter,
                  context.sp(6),
                ),
                child: TunasTopBar(
                  compactBrand: true,
                  leading: TunasIconButton(
                    icon: Icons.close_rounded,
                    tooltip: 'Keluar dari kuis',
                    onPressed: _confirmExit,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: EdgeInsets.fromLTRB(
                    context.gutter,
                    context.sp(12),
                    context.gutter,
                    context.sp(28),
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 780),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              _CategoryTag(
                                icon: category.icon,
                                label: category.name,
                              ),
                              const Spacer(),
                              Text(
                                'SOAL ${(quiz.index + 1).toString().padLeft(2, '0')} '
                                '/ ${quiz.total.toString().padLeft(2, '0')}',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ],
                          ),
                          SizedBox(height: context.sp(12)),
                          ProgressSegments(
                            total: quiz.total,
                            currentIndex: quiz.index,
                            answered: quiz.answeredCount,
                            isAnswered: (index) => quiz.answers.containsKey(
                              quiz.questions[index].id,
                            ),
                          ),
                          SizedBox(height: context.sp(24)),
                          SurfaceCard(
                            padding: EdgeInsets.all(context.sp(24)),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 240),
                              switchInCurve: Curves.easeOutCubic,
                              transitionBuilder: (child, animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0, 0.025),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  ),
                                );
                              },
                              child: Column(
                                key: ValueKey(question.id),
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        (quiz.index + 1).toString().padLeft(
                                          2,
                                          '0',
                                        ),
                                        style: TextStyle(
                                          fontFamily: 'Fraunces',
                                          fontSize: context.sp(32),
                                          height: 1,
                                          fontWeight: FontWeight.w600,
                                          color: context.palette.forest,
                                        ),
                                      ),
                                      SizedBox(width: context.sp(10)),
                                      Expanded(
                                        child: Text(
                                          'PILIHAN GANDA',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: context.sp(16)),
                                  Text(
                                    question.prompt,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),
                                  SizedBox(height: context.sp(22)),
                                  for (
                                    var i = 0;
                                    i < question.options.length;
                                    i++
                                  ) ...[
                                    QuizOptionTile(
                                      index: i,
                                      text: question.options[i],
                                      selected: selected == i,
                                      onTap: () => context
                                          .read<QuizController>()
                                          .selectOption(i),
                                    ),
                                    if (i < question.options.length - 1)
                                      SizedBox(height: context.sp(9)),
                                  ],
                                  AnimatedSize(
                                    duration: const Duration(milliseconds: 180),
                                    alignment: Alignment.topLeft,
                                    child: selected == null
                                        ? SizedBox(height: context.sp(16))
                                        : Padding(
                                            padding: EdgeInsets.only(
                                              top: context.sp(16),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons
                                                      .check_circle_outline_rounded,
                                                  size: 15 * context.typeScale,
                                                  color: context.palette.forest,
                                                ),
                                                SizedBox(width: context.sp(6)),
                                                Expanded(
                                                  child: Text(
                                                    'Jawaban tersimpan. Kamu masih '
                                                    'bisa menggantinya.',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: context.sp(18)),
                          Row(
                            children: [
                              TunasIconButton(
                                icon: Icons.arrow_back_rounded,
                                tooltip: 'Pertanyaan sebelumnya',
                                onPressed: quiz.isFirst ? null : quiz.previous,
                              ),
                              SizedBox(width: context.sp(12)),
                              Expanded(
                                child: PrimaryAction(
                                  label: quiz.isLast ? 'Lihat hasil' : 'Lanjut',
                                  icon: quiz.isLast
                                      ? Icons.flag_outlined
                                      : Icons.arrow_forward_rounded,
                                  onPressed: selected == null ? null : _next,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: context.sp(12)),
                          Text(
                            'Pilih satu jawaban. Kamu bisa mengubahnya sebelum '
                            'lanjut ke soal berikutnya.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryTag extends StatelessWidget {
  const _CategoryTag({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final scale = context.typeScale;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10 * scale,
        vertical: 7 * scale,
      ),
      decoration: BoxDecoration(
        color: palette.wash,
        borderRadius: BorderRadius.circular(9 * scale),
        border: Border.all(color: palette.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13 * scale, color: palette.forest),
          SizedBox(width: 6 * scale),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              letterSpacing: 0.3,
              color: palette.ink,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
