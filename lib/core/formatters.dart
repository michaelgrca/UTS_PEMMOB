const List<String> _monthNames = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];

/// "20 Okt 2026" — deliberately short so it fits on a phone card.
String formatDate(DateTime value) {
  return '${value.day} ${_monthNames[value.month - 1]} ${value.year}';
}

/// "19:42" in 24-hour format.
String formatClock(DateTime value) {
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

/// "04:12" from a stored number of seconds.
String formatDuration(int totalSeconds) {
  final safeSeconds = totalSeconds < 0 ? 0 : totalSeconds;
  final minutes = safeSeconds ~/ 60;
  final seconds = safeSeconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:'
      '${seconds.toString().padLeft(2, '0')}';
}

String formatPercent(double ratio) => '${(ratio * 100).round()}%';
