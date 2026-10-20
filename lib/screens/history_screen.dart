import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/formatters.dart';
import '../core/responsive.dart';
import '../core/theme/app_colors.dart';
import '../data/quiz_repository.dart';
import '../models/quiz_category.dart';
import '../models/score_entry.dart';
import '../state/score_history_controller.dart';
import '../widgets/primary_action.dart';
import '../widgets/section_label.dart';
import '../widgets/surface_card.dart';
import '../widgets/tunas_backdrop.dart';
import '../widgets/tunas_top_bar.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  static const String routeName = '/riwayat';

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final history = context.watch<ScoreHistoryController>();
    final best = history.bestOverall;

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
                constraints: const BoxConstraints(maxWidth: 920),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TunasTopBar(
                      compactBrand: true,
                      leading: TunasIconButton(
                        icon: Icons.arrow_back_rounded,
                        tooltip: 'Kembali',
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    SizedBox(height: context.sp(38)),
                    const SectionLabel('Jejak belajar'),
                    SizedBox(height: context.sp(14)),
                    Text(
                      'Setiap sesi\nmeninggalkan akar.',
                      style: context.isCompact
                          ? textTheme.displaySmall
                          : textTheme.displayMedium,
                    ),
                    SizedBox(height: context.sp(10)),
                    Text(
                      'Lihat ritme belajarmu, durasi tiap sesi, dan rekor '
                      'terbaik di setiap topik.',
                      style: textTheme.bodyMedium,
                    ),
                    SizedBox(height: context.sp(26)),
                    if (!history.isLoaded)
                      SurfaceCard(
                        padding: EdgeInsets.all(context.sp(28)),
                        child: const Center(
                          child: SizedBox.square(
                            dimension: 26,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      )
                    else if (history.entries.isEmpty)
                      _EmptyHistory(onStart: () => Navigator.of(context).pop())
                    else ...[
                      _SummaryCard(history: history),
                      SizedBox(height: context.sp(24)),
                      Row(
                        children: [
                          const SectionLabel('Sesi terakhir'),
                          const Spacer(),
                          Text(
                            '${history.sessionCount} tersimpan',
                            style: textTheme.bodySmall,
                          ),
                        ],
                      ),
                      SizedBox(height: context.sp(10)),
                      for (var i = 0; i < history.entries.length; i++) ...[
                        _HistoryEntryCard(
                          entry: history.entries[i],
                          best: best,
                        ),
                        if (i < history.entries.length - 1)
                          SizedBox(height: context.sp(9)),
                      ],
                    ],
                    SizedBox(height: context.sp(24)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock_outline_rounded,
                          size: 13 * context.typeScale,
                          color: palette.muted,
                        ),
                        SizedBox(width: context.sp(6)),
                        Flexible(
                          child: Text(
                            'Riwayat hanya tersimpan di perangkat ini.',
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
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final scale = context.typeScale;

    return SurfaceCard(
      padding: EdgeInsets.all(28 * scale),
      child: Column(
        children: [
          Container(
            width: 62 * scale,
            height: 62 * scale,
            decoration: BoxDecoration(
              color: palette.lime,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.spa_outlined,
              size: 28 * scale,
              color: palette.forestDeep,
            ),
          ),
          SizedBox(height: 18 * scale),
          Text(
            'Belum ada jejak.',
            style: textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8 * scale),
          Text(
            'Selesaikan satu sesi kuis, lalu skor dan durasinya akan muncul '
            'di sini.',
            style: textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 22 * scale),
          PrimaryAction(
            label: 'Mulai dari beranda',
            icon: Icons.arrow_back_rounded,
            expand: false,
            onPressed: onStart,
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.history});

  final ScoreHistoryController history;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final scale = context.typeScale;
    final best = history.bestOverall;

    return SurfaceCard(
      padding: EdgeInsets.all(24 * scale),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionLabel('Ringkasan'),
          SizedBox(height: 18 * scale),
          IntrinsicHeight(
            child: Row(
              children: [
                _SummaryStat(
                  value: '${history.sessionCount}',
                  label: 'sesi',
                  color: palette.ink,
                ),
                _SummaryDivider(color: palette.line),
                _SummaryStat(
                  value: formatPercent(history.averageRatio),
                  label: 'rata-rata',
                  color: palette.forest,
                ),
                _SummaryDivider(color: palette.line),
                _SummaryStat(
                  value: best == null ? '—' : '${best.correct}/${best.total}',
                  label: 'terbaik',
                  color: palette.clay,
                ),
              ],
            ),
          ),
          if (best != null) ...[
            SizedBox(height: 16 * scale),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12 * scale,
                vertical: 10 * scale,
              ),
              decoration: BoxDecoration(
                color: palette.wash,
                borderRadius: BorderRadius.circular(11 * scale),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.emoji_events_outlined,
                    size: 15 * scale,
                    color: palette.forest,
                  ),
                  SizedBox(width: 8 * scale),
                  Expanded(
                    child: Text(
                      'Rekor saat ini: ${best.categoryName} · '
                      '${best.playerName}',
                      style: textTheme.bodySmall?.copyWith(color: palette.ink),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({
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
              fontSize: context.sp(28),
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

class _SummaryDivider extends StatelessWidget {
  const _SummaryDivider({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      margin: EdgeInsets.symmetric(horizontal: context.sp(12)),
      color: color,
    );
  }
}

class _HistoryEntryCard extends StatelessWidget {
  const _HistoryEntryCard({required this.entry, required this.best});

  final ScoreEntry entry;
  final ScoreEntry? best;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final scale = context.typeScale;
    final isBest = best != null && best!.id == entry.id && entry.correct > 0;
    final category = _categoryFor(entry.categoryId);

    return SurfaceCard(
      radius: 18,
      padding: EdgeInsets.symmetric(
        horizontal: 16 * scale,
        vertical: 15 * scale,
      ),
      child: Row(
        children: [
          Container(
            width: 42 * scale,
            height: 42 * scale,
            decoration: BoxDecoration(
              color: palette.wash,
              borderRadius: BorderRadius.circular(12 * scale),
            ),
            child: Icon(
              category?.icon ?? Icons.eco_outlined,
              size: 20 * scale,
              color: palette.forest,
            ),
          ),
          SizedBox(width: 12 * scale),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        entry.categoryName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleSmall,
                      ),
                    ),
                    if (isBest) ...[
                      SizedBox(width: 7 * scale),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6 * scale,
                          vertical: 2 * scale,
                        ),
                        decoration: BoxDecoration(
                          color: palette.lime,
                          borderRadius: BorderRadius.circular(5 * scale),
                        ),
                        child: Text(
                          'TERBAIK',
                          style: textTheme.labelMedium?.copyWith(
                            fontSize: 8.5 * scale,
                            color: palette.forestDeep,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 3 * scale),
                Text(
                  '${entry.playerName} · ${formatDate(entry.completedAt)} · '
                  '${formatClock(entry.completedAt)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall,
                ),
                SizedBox(height: 2 * scale),
                Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 12 * scale,
                      color: palette.muted,
                    ),
                    SizedBox(width: 4 * scale),
                    Text(
                      formatDuration(entry.durationSeconds),
                      style: textTheme.bodySmall?.copyWith(
                        fontSize: 11 * scale,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 10 * scale),
          Text(
            '${entry.correct}/${entry.total}',
            style: TextStyle(
              fontFamily: 'Fraunces',
              fontSize: 25 * scale,
              height: 1,
              fontWeight: FontWeight.w600,
              color: isBest ? palette.forest : palette.ink,
            ),
          ),
        ],
      ),
    );
  }

  QuizCategory? _categoryFor(String id) {
    for (final category in QuizRepository.categories) {
      if (category.id == id) return category;
    }
    return null;
  }
}
