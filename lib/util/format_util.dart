class Countdown {
  final int days;
  final int hours;
  final int minutes;
  final int seconds;
  const Countdown(this.days, this.hours, this.minutes, this.seconds);
}

class FormatUtil {
  static String money(double v) {
    final n = v.round();
    final s = n.toString();
    final out = StringBuffer();
    var count = 0;
    for (var i = 0; i < s.length; i++) {
      final idx = s.length - 1 - i;
      out.write(s[idx]);
      count++;
      if (count == 3 && idx != 0) {
        out.write(',');
        count = 0;
      }
    }
    return '${out.toString().split('').reversed.join()} so\'m';
  }

  static double parseMoney(String s) {
    final cleaned = s.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.isEmpty) return 0;
    return double.tryParse(cleaned) ?? 0;
  }

  static const _months = [
    'YANVAR', 'FEVRAL', 'MART', 'APREL', 'MAY', 'IYUN',
    'IYUL', 'AVGUST', 'SENTYABR', 'OKTYABR', 'NOYABR', 'DEKABR',
  ];
  static const _weekdays = [
    'DUSHANBA', 'SESHANBA', 'CHORSHANBA', 'PAYSHANBA', 'JUMA', 'SHANBA', 'YAKSHANBA',
  ];

  static String dateToElegantString(DateTime d) {
    final dayStr = two(d.day);
    final month = _months[(d.month - 1).clamp(0, 11)];
    final weekday = _weekdays[(d.weekday - 1).clamp(0, 6)];
    return '$dayStr $weekday $month ${d.year}';
  }

  static DateTime parseSafeDate(String? iso) {
    if (iso == null || iso.isEmpty) return DateTime.now();
    try {
      var clean = iso;
      if (clean.length > 19) clean = clean.substring(0, 19);
      return DateTime.parse(clean);
    } catch (_) {
      return DateTime.now();
    }
  }

  static int daysLeft(String iso) {
    final target = parseSafeDate(iso);
    final now = DateTime.now();
    final diff = target.difference(now).inMilliseconds;
    return (diff / (1000 * 60 * 60 * 24)).ceil();
  }

  static Countdown countdown(String iso) {
    final target = parseSafeDate(iso);
    final now = DateTime.now();
    var diff = target.difference(now).inMilliseconds;
    if (diff < 0) diff = 0;
    var total = (diff / 1000).floor();
    final days = total ~/ 86400;
    total -= days * 86400;
    final hours = total ~/ 3600;
    total -= hours * 3600;
    final minutes = total ~/ 60;
    final seconds = total - minutes * 60;
    return Countdown(days, hours, minutes, seconds);
  }

  static String two(int v) => v < 10 ? '0$v' : v.toString();

  static String extractDate(String? iso) {
    if (iso == null || iso.length < 10) return '2026-08-02';
    return iso.substring(0, 10);
  }

  static String extractTime(String? iso) {
    if (iso == null || iso.length < 16) return '18:00';
    return iso.substring(11, 16);
  }

  static String buildISO(String date, String time) {
    var d = date.trim();
    var t = time.trim();
    if (d.length < 10 || !d.contains('-')) d = '2026-08-02';
    if (t.length < 4 || !t.contains(':')) t = '18:00';
    final iso = '${d}T$t:00';
    try {
      DateTime.parse(iso);
      return iso;
    } catch (_) {
      return '2026-08-02T18:00:00';
    }
  }
}
