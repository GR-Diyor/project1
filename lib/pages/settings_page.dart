import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/data_store.dart';
import '../ui/theme.dart';
import '../ui/widgets.dart';
import '../util/format_util.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage();

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final bride = TextEditingController();
  final groom = TextEditingController();
  final date = TextEditingController();
  final time = TextEditingController();
  final place = TextEditingController();
  final city = TextEditingController();
  bool _init = false;

  @override
  void dispose() {
    bride.dispose();
    groom.dispose();
    date.dispose();
    time.dispose();
    place.dispose();
    city.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = ref.watch(dataStoreProvider.notifier);
    final d = ref.watch(dataStoreProvider);

    if (!_init) {
      bride.text = d.bride;
      groom.text = d.groom;
      date.text = FormatUtil.extractDate(d.dateISO);
      time.text = FormatUtil.extractTime(d.dateISO);
      place.text = d.place;
      city.text = d.city;
      _init = true;
    }

    return ListView(
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionLabel(text: "TO'Y MA'LUMOTLARI", color: AppTheme.gold, letterSpacing: 3),
              const SizedBox(height: 16),
              AppTextInput(controller: bride, placeholder: 'Kelin ismi'),
              const SizedBox(height: 10),
              AppTextInput(controller: groom, placeholder: 'Kuyov ismi'),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: AppTextInput(controller: date, placeholder: 'Sana (2026-08-02)')),
                  const SizedBox(width: 8),
                  Expanded(child: AppTextInput(controller: time, placeholder: 'Vaqt (18:00)')),
                ],
              ),
              const SizedBox(height: 10),
              AppTextInput(controller: place, placeholder: "To'yxona"),
              const SizedBox(height: 10),
              AppTextInput(controller: city, placeholder: 'Shahar'),
              const SizedBox(height: 14),
              AppButton(
                text: 'Saqlash',
                normalColor: AppTheme.green,
                hoverColor: AppTheme.dark2,
                textColor: Colors.white,
                width: double.infinity,
                onPressed: () {
                  final iso = FormatUtil.buildISO(date.text, time.text);
                  store.updateWeddingInfo(
                    bride: bride.text,
                    groom: groom.text,
                    dateISO: iso,
                    place: place.text,
                    city: city.text,
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionLabel(text: 'XAVFLI HUDUD', color: AppTheme.red, letterSpacing: 3),
              const SizedBox(height: 12),
              Text(
                "Barcha mehmonlar, xizmatlar, byudjet va sozlamalar boshlang'ich holatga qaytariladi.",
                style: AppTheme.font(size: 14, color: AppTheme.muted),
              ),
              const SizedBox(height: 14),
              AppButton(
                text: "Barchasini o'chirish",
                normalColor: Colors.white,
                hoverColor: AppTheme.soft,
                textColor: AppTheme.red,
                width: double.infinity,
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Tasdiqlang'),
                      content: const Text("Haqiqatan ham hammasini o'chirmoqchimisiz?"),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Yo\'q')),
                        TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Ha')),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await store.reset();
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
