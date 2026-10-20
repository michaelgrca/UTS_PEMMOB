import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/responsive.dart';
import '../core/theme/app_colors.dart';
import '../data/quiz_repository.dart';
import '../state/score_history_controller.dart';
import '../state/theme_controller.dart';
import '../widgets/section_label.dart';
import '../widgets/surface_card.dart';
import '../widgets/tunas_backdrop.dart';
import '../widgets/tunas_top_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const String routeName = '/pengaturan';

  Future<void> _clearHistory(BuildContext context) async {
    final palette = context.palette;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: palette.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: palette.line),
          ),
          title: const Text('Hapus semua riwayat?'),
          content: const Text(
            'Skor, durasi, dan rekor dari sesi sebelumnya akan dihapus dari '
            'perangkat ini. Soal kuis tetap tersedia.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: TextButton.styleFrom(foregroundColor: palette.clay),
              child: const Text('Hapus riwayat'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) return;
    await context.read<ScoreHistoryController>().clear();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Riwayat skor sudah dihapus.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final theme = context.watch<ThemeController>();
    final history = context.watch<ScoreHistoryController>();

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
                constraints: const BoxConstraints(maxWidth: 820),
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
                    const SectionLabel('Pengaturan'),
                    SizedBox(height: context.sp(14)),
                    Text(
                      'Sesuaikan\ncaramu belajar.',
                      style: context.isCompact
                          ? textTheme.displaySmall
                          : textTheme.displayMedium,
                    ),
                    SizedBox(height: context.sp(10)),
                    Text(
                      'Pilihanmu disimpan di perangkat ini, jadi Tunas tetap '
                      'terasa seperti milikmu saat dibuka lagi.',
                      style: textTheme.bodyMedium,
                    ),
                    SizedBox(height: context.sp(26)),
                    SurfaceCard(
                      padding: EdgeInsets.all(context.sp(24)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SectionLabel('Tampilan'),
                          SizedBox(height: context.sp(18)),
                          Text('Mode warna', style: textTheme.titleLarge),
                          SizedBox(height: context.sp(5)),
                          Text(
                            'Ikuti pengaturan sistem, atau kunci tampilan '
                            'terang dan gelap.',
                            style: textTheme.bodySmall,
                          ),
                          SizedBox(height: context.sp(16)),
                          _ThemeModePicker(
                            selected: theme.mode,
                            onChanged: theme.setMode,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.sp(18)),
                    SurfaceCard(
                      padding: EdgeInsets.all(context.sp(24)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SectionLabel('Data lokal'),
                          SizedBox(height: context.sp(18)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      history.isLoaded
                                          ? '${history.sessionCount} sesi '
                                                'tersimpan'
                                          : 'Memuat riwayat…',
                                      style: textTheme.titleSmall,
                                    ),
                                    SizedBox(height: context.sp(4)),
                                    Text(
                                      'Skor dan durasi tiap sesi disimpan '
                                      'hanya di perangkat ini.',
                                      style: textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: context.sp(12)),
                              TextButton.icon(
                                onPressed: history.sessionCount == 0
                                    ? null
                                    : () => _clearHistory(context),
                                style: TextButton.styleFrom(
                                  foregroundColor: palette.clay,
                                ),
                                icon: Icon(
                                  Icons.delete_outline_rounded,
                                  size: 17 * context.typeScale,
                                ),
                                label: const Text('Hapus'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.sp(18)),
                    SurfaceCard(
                      padding: EdgeInsets.all(context.sp(24)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SectionLabel('Tentang Tunas'),
                          SizedBox(height: context.sp(18)),
                          Text(
                            'Kuis alam Indonesia yang tenang, lokal, dan bisa '
                            'dimainkan tanpa akun.',
                            style: textTheme.bodyMedium,
                          ),
                          SizedBox(height: context.sp(18)),
                          _InfoLine(
                            icon: Icons.layers_outlined,
                            title:
                                '${QuizRepository.categories.length} topik · '
                                '${QuizRepository.totalQuestions} soal',
                            caption:
                                'Rimba & satwa, bumi & iklim, serta sains '
                                'hijau—lengkap dengan pembahasan.',
                          ),
                          SizedBox(height: context.sp(14)),
                          const _InfoLine(
                            icon: Icons.format_paint_outlined,
                            title: 'Tipografi',
                            caption:
                                'Fraunces untuk judul, Plus Jakarta Sans untuk '
                                'teks. Keduanya berlisensi SIL Open Font '
                                'License.',
                          ),
                          SizedBox(height: context.sp(14)),
                          const _InfoLine(
                            icon: Icons.storage_outlined,
                            title: 'Tanpa server',
                            caption:
                                'Soal dan riwayat tidak dikirim ke mana pun. '
                                'Semua data tinggal di perangkatmu.',
                          ),
                          SizedBox(height: context.sp(20)),
                          Text(
                            'VERSI 0.2 · DIBUAT UNTUK BELAJAR',
                            style: textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.sp(28)),
                    Center(
                      child: Text(
                        'TUNAS · KUIS ALAM NUSANTARA',
                        style: textTheme.labelMedium?.copyWith(
                          color: palette.muted,
                          letterSpacing: 0.8,
                        ),
                      ),
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

class _ThemeModePicker extends StatelessWidget {
  const _ThemeModePicker({required this.selected, required this.onChanged});

  final ThemeMode selected;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    const options = [
      (ThemeMode.system, 'Sistem', Icons.brightness_auto_outlined),
      (ThemeMode.light, 'Terang', Icons.light_mode_outlined),
      (ThemeMode.dark, 'Gelap', Icons.dark_mode_outlined),
    ];

    return Row(
      children: [
        for (var i = 0; i < options.length; i++) ...[
          Expanded(
            child: _ThemeOption(
              label: options[i].$2,
              icon: options[i].$3,
              selected: selected == options[i].$1,
              onTap: () => onChanged(options[i].$1),
            ),
          ),
          if (i < options.length - 1) SizedBox(width: context.sp(8)),
        ],
      ],
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final scale = context.typeScale;

    return Semantics(
      button: true,
      selected: selected,
      label: 'Mode $label',
      child: Material(
        color: selected ? palette.wash : palette.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16 * scale),
          side: BorderSide(
            color: selected ? palette.forest : palette.line,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16 * scale),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 6 * scale,
              vertical: 14 * scale,
            ),
            child: Column(
              children: [
                Container(
                  width: 34 * scale,
                  height: 34 * scale,
                  decoration: BoxDecoration(
                    color: selected ? palette.lime : palette.wash,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 17 * scale,
                    color: selected ? palette.forestDeep : palette.muted,
                  ),
                ),
                SizedBox(height: 8 * scale),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: selected ? palette.forest : palette.ink,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({
    required this.icon,
    required this.title,
    required this.caption,
  });

  final IconData icon;
  final String title;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final scale = context.typeScale;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34 * scale,
          height: 34 * scale,
          decoration: BoxDecoration(
            color: palette.wash,
            borderRadius: BorderRadius.circular(9 * scale),
          ),
          child: Icon(icon, size: 17 * scale, color: palette.forest),
        ),
        SizedBox(width: 12 * scale),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: textTheme.titleSmall),
              SizedBox(height: 3 * scale),
              Text(caption, style: textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
