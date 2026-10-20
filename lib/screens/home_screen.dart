import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/responsive.dart';
import '../core/theme/app_colors.dart';
import '../data/quiz_repository.dart';
import '../state/quiz_controller.dart';
import '../widgets/category_option.dart';
import '../widgets/primary_action.dart';
import '../widgets/progress_segments.dart';
import '../widgets/section_label.dart';
import '../widgets/surface_card.dart';
import '../widgets/tunas_backdrop.dart';
import '../widgets/tunas_top_bar.dart';
import 'history_screen.dart';
import 'quiz_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = '/';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  String _categoryId = QuizRepository.categories.first.id;
  bool _autovalidate = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: context.read<QuizController>().playerName,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _startQuiz() {
    setState(() => _autovalidate = true);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();
    final quiz = context.read<QuizController>();
    quiz.start(
      playerName: _nameController.text,
      category: QuizRepository.categoryById(_categoryId),
    );
    _openQuiz();
  }

  void _openQuiz() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const QuizScreen()));
  }

  void _resumeQuiz() {
    context.read<QuizController>().resume();
    _openQuiz();
  }

  Future<void> _confirmRestart() async {
    final quiz = context.read<QuizController>();
    final restart = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final palette = dialogContext.palette;
        return AlertDialog(
          backgroundColor: palette.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: palette.line),
          ),
          title: const Text('Mulai sesi baru?'),
          content: const Text(
            'Jawaban di sesi yang sedang berjalan akan dihapus.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Ya, mulai baru'),
            ),
          ],
        );
      },
    );

    if (restart != true || !mounted) return;
    quiz.reset();
    _nameController.clear();
    setState(() {
      _categoryId = QuizRepository.categories.first.id;
      _autovalidate = false;
    });
  }

  void _openHistory() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const HistoryScreen()));
  }

  void _openSettings() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const SettingsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizController>();
    final isWide = context.viewport.width >= 960;

    final intro = _HeroCopy(totalQuestions: QuizRepository.totalQuestions);
    final panel = quiz.hasSessionInProgress
        ? _ResumePanel(
            quiz: quiz,
            onResume: _resumeQuiz,
            onRestart: _confirmRestart,
          )
        : _StartPanel(
            formKey: _formKey,
            nameController: _nameController,
            categoryId: _categoryId,
            autovalidate: _autovalidate,
            onCategoryChanged: (id) => setState(() => _categoryId = id),
            onSubmit: _startQuiz,
          );

    return Scaffold(
      body: TunasBackdrop(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  context.gutter,
                  context.sp(18),
                  context.gutter,
                  context.sp(28),
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TunasTopBar(
                          compactBrand: context.isCompact,
                          actions: [
                            if (context.isCompact) ...[
                              TunasIconButton(
                                icon: Icons.insights_outlined,
                                tooltip: 'Riwayat skor',
                                onPressed: _openHistory,
                              ),
                              TunasIconButton(
                                icon: Icons.tune_rounded,
                                tooltip: 'Pengaturan',
                                onPressed: _openSettings,
                              ),
                            ] else ...[
                              TextButton.icon(
                                onPressed: _openHistory,
                                icon: Icon(
                                  Icons.insights_outlined,
                                  size: 17 * context.typeScale,
                                ),
                                label: const Text('Riwayat'),
                              ),
                              TextButton.icon(
                                onPressed: _openSettings,
                                icon: Icon(
                                  Icons.tune_rounded,
                                  size: 17 * context.typeScale,
                                ),
                                label: const Text('Pengaturan'),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: context.sp(isWide ? 58 : 36)),
                        if (isWide)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(flex: 6, child: intro),
                              SizedBox(width: context.sp(56)),
                              Expanded(flex: 5, child: panel),
                            ],
                          )
                        else ...[
                          intro,
                          SizedBox(height: context.sp(30)),
                          panel,
                        ],
                        SizedBox(height: context.sp(40)),
                        const _Footer(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({required this.totalQuestions});

  final int totalQuestions;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final headline = context.viewport.width < 350
        ? textTheme.displaySmall
        : context.isCompact
        ? textTheme.displayMedium
        : textTheme.displayLarge;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('Kuis alam nusantara'),
        SizedBox(height: context.sp(20)),
        Text.rich(
          TextSpan(
            style: headline,
            children: [
              const TextSpan(text: 'Kenali yang '),
              TextSpan(
                text: 'hidup',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: palette.forest,
                ),
              ),
              const TextSpan(text: ',\nsatu pertanyaan\nsetiap kali.'),
            ],
          ),
        ),
        SizedBox(height: context.sp(20)),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: context.sp(470)),
          child: Text(
            'Dari bakau di pesisir sampai gletser di Papua. Uji pengetahuanmu '
            'tentang alam Indonesia—tanpa batas waktu, dengan penjelasan di '
            'setiap jawaban.',
            style: textTheme.bodyLarge?.copyWith(color: palette.muted),
          ),
        ),
        SizedBox(height: context.sp(30)),
        _StatsRow(totalQuestions: totalQuestions),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.totalQuestions});

  final int totalQuestions;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return IntrinsicHeight(
      child: Row(
        children: [
          _Stat(value: '$totalQuestions', label: 'pertanyaan'),
          _StatDivider(color: palette.line),
          _Stat(value: '${QuizRepository.categories.length}', label: 'topik'),
          _StatDivider(color: palette.line),
          const _Stat(value: '±5', label: 'menit'),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Fraunces',
              fontSize: context.sp(24),
              height: 1,
              fontWeight: FontWeight.w600,
              color: palette.ink,
            ),
          ),
          SizedBox(height: context.sp(5)),
          Text(label, style: textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider({required this.color});

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

class _StartPanel extends StatelessWidget {
  const _StartPanel({
    required this.formKey,
    required this.nameController,
    required this.categoryId,
    required this.autovalidate,
    required this.onCategoryChanged,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final String categoryId;
  final bool autovalidate;
  final ValueChanged<String> onCategoryChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final scale = context.typeScale;

    return SurfaceCard(
      padding: EdgeInsets.all(24 * scale),
      child: Form(
        key: formKey,
        autovalidateMode: autovalidate
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const SectionLabel('Mulai di sini'),
                const Spacer(),
                Text(
                  '01',
                  style: textTheme.labelLarge?.copyWith(color: palette.muted),
                ),
              ],
            ),
            SizedBox(height: 20 * scale),
            Text('Siapa namamu?', style: textTheme.headlineSmall),
            SizedBox(height: 6 * scale),
            Text(
              'Nama ini akan tampil di kartu hasilmu.',
              style: textTheme.bodySmall,
            ),
            SizedBox(height: 18 * scale),
            TextFormField(
              controller: nameController,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => onSubmit(),
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: palette.ink,
              ),
              decoration: InputDecoration(
                hintText: 'Tulis namamu',
                prefixIcon: Icon(
                  Icons.person_outline_rounded,
                  size: 19 * scale,
                  color: palette.muted,
                ),
                prefixIconConstraints: BoxConstraints(
                  minWidth: 46 * scale,
                  minHeight: 20 * scale,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().length < 2) {
                  return 'Isi nama minimal 2 huruf, ya.';
                }
                return null;
              },
            ),
            SizedBox(height: 24 * scale),
            Row(
              children: [
                Text('Pilih topik', style: textTheme.titleSmall),
                const Spacer(),
                Text(
                  '${QuizRepository.categories.length} pilihan',
                  style: textTheme.bodySmall,
                ),
              ],
            ),
            SizedBox(height: 10 * scale),
            for (final category in QuizRepository.categories) ...[
              CategoryOption(
                category: category,
                selected: category.id == categoryId,
                onTap: () => onCategoryChanged(category.id),
              ),
              if (category != QuizRepository.categories.last)
                SizedBox(height: 8 * scale),
            ],
            SizedBox(height: 24 * scale),
            PrimaryAction(label: 'Mulai kuis', onPressed: onSubmit),
            SizedBox(height: 12 * scale),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  size: 13 * scale,
                  color: palette.muted,
                ),
                SizedBox(width: 6 * scale),
                Flexible(
                  child: Text(
                    'Progres aman saat layar diputar.',
                    style: textTheme.bodySmall?.copyWith(fontSize: 11 * scale),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ResumePanel extends StatelessWidget {
  const _ResumePanel({
    required this.quiz,
    required this.onResume,
    required this.onRestart,
  });

  final QuizController quiz;
  final VoidCallback onResume;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final scale = context.typeScale;
    final category = quiz.category;

    return SurfaceCard(
      padding: EdgeInsets.all(24 * scale),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const SectionLabel('Sesi tersimpan'),
              const Spacer(),
              Icon(
                Icons.bookmark_outline_rounded,
                size: 18 * scale,
                color: palette.muted,
              ),
            ],
          ),
          SizedBox(height: 20 * scale),
          Text(
            'Lanjutkan, ${quiz.playerName}?',
            style: textTheme.headlineSmall,
          ),
          SizedBox(height: 8 * scale),
          Text(
            '${category?.name ?? ''} · pertanyaan ${quiz.index + 1} dari '
            '${quiz.total}. Jawabanmu masih utuh.',
            style: textTheme.bodySmall,
          ),
          SizedBox(height: 20 * scale),
          ProgressSegments(
            total: quiz.total,
            currentIndex: quiz.index,
            answered: quiz.answeredCount,
            isAnswered: (index) =>
                quiz.answers.containsKey(quiz.questions[index].id),
          ),
          SizedBox(height: 10 * scale),
          Text(
            '${quiz.answeredCount} dari ${quiz.total} pertanyaan terjawab',
            style: textTheme.labelMedium,
          ),
          SizedBox(height: 24 * scale),
          PrimaryAction(label: 'Lanjutkan kuis', onPressed: onResume),
          SizedBox(height: 8 * scale),
          TextButton(
            onPressed: onRestart,
            child: const Text('Mulai sesi baru'),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final style = textTheme.labelMedium?.copyWith(
      color: palette.muted,
      letterSpacing: 0.8,
    );

    return Container(
      padding: EdgeInsets.only(top: context.sp(18)),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: palette.line)),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: context.sp(6),
        spacing: context.sp(20),
        children: [
          Text('TUNAS · KUIS ALAM NUSANTARA', style: style),
          Text(
            '${QuizRepository.totalQuestions} SOAL · DATA LOKAL',
            style: style,
          ),
        ],
      ),
    );
  }
}
