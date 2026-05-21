import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/data_store.dart';
import '../data/wedding_models.dart';
import '../ui/theme.dart';
import '../ui/widgets.dart';

class GuestsPage extends ConsumerStatefulWidget {
  const GuestsPage();

  @override
  ConsumerState<GuestsPage> createState() => _GuestsPageState();
}

class _GuestsPageState extends ConsumerState<GuestsPage> {
  final newEventName = TextEditingController();
  final newEventSub = TextEditingController();
  final newGuestName = TextEditingController();
  String? selectedEvent;

  @override
  void dispose() {
    newEventName.dispose();
    newEventSub.dispose();
    newGuestName.dispose();
    super.dispose();
  }

  String _nextStatus(String s) {
    switch (s) {
      case 'Tasdiqlangan':
        return 'Kutilmoqda';
      case 'Kutilmoqda':
        return 'Rad etilgan';
      case 'Rad etilgan':
        return 'Tasdiqlangan';
      default:
        return 'Kutilmoqda';
    }
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'Tasdiqlangan':
        return AppTheme.okSoft;
      case 'Kutilmoqda':
        return AppTheme.waitSoft;
      case 'Rad etilgan':
        return AppTheme.badSoft;
      default:
        return AppTheme.soft;
    }
  }

  int _countForEvent(WeddingData d, String name) =>
      d.guests.where((g) => g.event == name).length;

  @override
  Widget build(BuildContext context) {
    final store = ref.watch(dataStoreProvider.notifier);
    final d = ref.watch(dataStoreProvider);
    final eventNames = d.events.isNotEmpty ? d.events.map((e) => e.name).toList() : ['Asosiy'];
    selectedEvent ??= eventNames.first;
    if (!eventNames.contains(selectedEvent)) selectedEvent = eventNames.first;

    return ListView(
      children: [
        ...d.events.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _eventCard(e, _countForEvent(d, e.name)),
            )),
        const SizedBox(height: 6),
        AppCard(
          child: Column(
            children: [
              AppTextInput(controller: newEventName, placeholder: 'Yangi tadbir (m-n: Fotiha)'),
              const SizedBox(height: 10),
              AppTextInput(controller: newEventSub, placeholder: 'Izoh (m-n: Ayollar uchun)'),
              const SizedBox(height: 10),
              AppButton(
                text: "+ Tadbir qo'shish",
                normalColor: AppTheme.gold,
                hoverColor: AppTheme.gold2,
                textColor: Colors.white,
                width: double.infinity,
                onPressed: () {
                  store.addEvent(newEventName.text, newEventSub.text);
                  newEventName.clear();
                  newEventSub.clear();
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Tasdiqlangan: ${store.confirmedGuests()}     Kutilmoqda: ${store.pendingGuests()}     Rad etilgan: ${store.rejectedGuests()}',
          style: AppTheme.font(size: 13, color: AppTheme.text),
        ),
        const SizedBox(height: 12),
        AppCard(
          child: Column(
            children: [
              AppTextInput(controller: newGuestName, placeholder: 'Mehmon ismini kiriting...'),
              const SizedBox(height: 10),
              AppSelectBox(
                options: eventNames,
                selected: selectedEvent!,
                onChanged: (v) => setState(() => selectedEvent = v),
              ),
              const SizedBox(height: 10),
              AppButton(
                text: "+ Qo'shish",
                normalColor: AppTheme.green,
                hoverColor: AppTheme.dark2,
                textColor: Colors.white,
                width: double.infinity,
                onPressed: () {
                  if (newGuestName.text.isEmpty) return;
                  store.addGuest(newGuestName.text, selectedEvent!);
                  newGuestName.clear();
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < d.guests.length; i++) ...[
                if (i > 0) Container(height: 1, color: AppTheme.line),
                _guestRow(d.guests[i]),
              ],
              if (d.guests.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "Hozircha mehmonlar yo'q",
                    style: AppTheme.font(size: 14, color: AppTheme.muted),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _eventCard(EventDef e, int count) {
    final store = ref.read(dataStoreProvider.notifier);
    return AppCard(
      child: Row(
        children: [
          Container(width: 42, height: 42, color: AppTheme.gold),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.name, style: AppTheme.font(size: 18, color: AppTheme.text)),
                const SizedBox(height: 2),
                Text(e.subtitle, style: AppTheme.font(size: 12, color: AppTheme.muted)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$count',
                  style: AppTheme.font(size: 22, color: AppTheme.text)),
              Text(
                'MEHMON',
                style: AppTheme.font(
                    size: 10, color: AppTheme.gold, weight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(width: 10),
          AppButton(
            text: '×',
            normalColor: Colors.white,
            hoverColor: AppTheme.soft,
            textColor: AppTheme.red,
            width: 34,
            height: 34,
            fontSize: 18,
            onPressed: () => store.removeEvent(e.id),
          ),
        ],
      ),
    );
  }

  Widget _guestRow(GuestData g) {
    final store = ref.read(dataStoreProvider.notifier);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          AvatarSquare(letter: g.name.isNotEmpty ? g.name[0] : '?'),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(g.name,
                    style: AppTheme.font(size: 15, color: AppTheme.text, weight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(g.event, style: AppTheme.font(size: 12, color: AppTheme.muted)),
              ],
            ),
          ),
          AppButton(
            text: g.status,
            normalColor: _statusColor(g.status),
            hoverColor: Colors.white,
            textColor: AppTheme.text,
            height: 32,
            width: 130,
            fontSize: 12,
            onPressed: () => store.setGuestStatus(g.id, _nextStatus(g.status)),
          ),
          const SizedBox(width: 6),
          AppButton(
            text: '×',
            normalColor: Colors.white,
            hoverColor: AppTheme.soft,
            textColor: AppTheme.red,
            height: 32,
            width: 34,
            fontSize: 16,
            onPressed: () => store.removeGuest(g.id),
          ),
        ],
      ),
    );
  }
}
