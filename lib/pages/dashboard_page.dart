import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/data_store.dart';
import '../ui/theme.dart';
import '../ui/widgets.dart';
import '../util/format_util.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage();

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = ref.watch(dataStoreProvider.notifier);
    final d = ref.watch(dataStoreProvider);

    final dateStr = FormatUtil.dateToElegantString(FormatUtil.parseSafeDate(d.dateISO)).toUpperCase();
    final c = FormatUtil.countdown(d.dateISO);

    final budgetTotal = store.budgetTotal();
    final budgetPaid = store.budgetPaid();
    final pct = budgetTotal <= 0 ? 0.0 : budgetPaid / budgetTotal;

    final guestsTotal = d.guests.length;
    final guestsTotalSafe = guestsTotal == 0 ? 1 : guestsTotal;
    final ok = store.confirmedGuests();
    final wait = store.pendingGuests();
    final bad = store.rejectedGuests();

    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: AppTheme.green,
            border: Border(bottom: BorderSide(color: AppTheme.green2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'M U B O R A K   K U N',
                style: AppTheme.font(
                  size: 12,
                  color: AppTheme.gold,
                  weight: FontWeight.w700,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 10),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  '${d.bride} & ${d.groom}',
                  style: AppTheme.font(size: 40, color: Colors.white, style: 'elegant'),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$dateStr — ${d.place}, ${d.city}',
                style: AppTheme.font(size: 13, color: const Color(0xFFEAF7EF)),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(child: _counter(c.days.toString(), 'KUN')),
                  Expanded(child: _counter(FormatUtil.two(c.hours), 'SOAT')),
                  Expanded(child: _counter(FormatUtil.two(c.minutes), 'DAQIQA')),
                  Expanded(child: _counter(FormatUtil.two(c.seconds), 'SONIYA')),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _stat('MEHMONLAR', '$guestsTotal', '$ok tasdiqlangan')),
            const SizedBox(width: 10),
            Expanded(child: _stat('VAZIFALAR', '${store.taskDone()} / ${store.taskTotal()}', 'Bajarilgan')),
          ],
        ),
        const SizedBox(height: 10),
        _stat("TO'YGACHA", '${FormatUtil.daysLeft(d.dateISO)} kun', dateStr),
        const SizedBox(height: 16),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionLabel(text: 'BYUDJET'),
              const SizedBox(height: 8),
              Text(
                "Sarflangan mablag'",
                style: AppTheme.font(size: 18, color: AppTheme.text, style: 'elegant'),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      FormatUtil.money(budgetPaid),
                      style: AppTheme.font(size: 24, color: AppTheme.text),
                    ),
                  ),
                  Text(
                    '/ ${FormatUtil.money(budgetTotal)}',
                    style: AppTheme.font(size: 12, color: AppTheme.muted),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AppProgressBar(value: pct),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "${(pct * 100).toInt()}% to'langan",
                      style: AppTheme.font(size: 12, color: AppTheme.muted),
                    ),
                  ),
                  Text(
                    'Qarz: ${FormatUtil.money(budgetTotal - budgetPaid)}',
                    style: AppTheme.font(size: 12, color: AppTheme.muted),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionLabel(text: 'RSVP'),
              const SizedBox(height: 8),
              Text(
                'Mehmonlar holati',
                style: AppTheme.font(size: 18, color: AppTheme.text, style: 'elegant'),
              ),
              const SizedBox(height: 16),
              AppProgressBar(value: ok / guestsTotalSafe, height: 12),
              const SizedBox(height: 8),
              Text(
                'Tasdiq: $ok   Kutilmoqda: $wait   Rad: $bad',
                style: AppTheme.font(size: 12, color: AppTheme.muted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _counter(String value, String label) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: AppTheme.dark2,
      child: Column(
        children: [
          Text(
            value,
            style: AppTheme.font(size: 28, color: Colors.white, weight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTheme.font(
              size: 10,
              color: AppTheme.gold,
              weight: FontWeight.w700,
              letterSpacing: 3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String title, String value, String subtitle) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionLabel(text: title, letterSpacing: 2),
          const SizedBox(height: 8),
          Text(value, style: AppTheme.font(size: 26, color: AppTheme.text)),
          const SizedBox(height: 6),
          Text(subtitle, style: AppTheme.font(size: 12, color: AppTheme.muted)),
        ],
      ),
    );
  }
}
