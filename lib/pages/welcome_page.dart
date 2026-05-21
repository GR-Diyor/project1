import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/data_store.dart';
import '../ui/theme.dart';
import '../ui/widgets.dart';
import '../util/format_util.dart';

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage();

  @override
  ConsumerState<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  final bride = TextEditingController();
  final groom = TextEditingController();
  final date = TextEditingController();
  final time = TextEditingController();
  final place = TextEditingController();
  final city = TextEditingController();

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

  void _start() {
    if (bride.text.isEmpty || groom.text.isEmpty) return;
    final iso = FormatUtil.buildISO(date.text, time.text);
    ref.read(dataStoreProvider.notifier).completeSetup(
          bride: bride.text,
          groom: groom.text,
          dateISO: iso,
          place: place.text,
          city: city.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: PatternBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(28),
                  color: AppTheme.card,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'XUSH KELIBSIZ',
                        textAlign: TextAlign.center,
                        style: AppTheme.font(size: 24, color: AppTheme.green, style: 'elegant'),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Iltimos, to'y ma'lumotlarini kiriting",
                        textAlign: TextAlign.center,
                        style: AppTheme.font(size: 14, color: AppTheme.muted),
                      ),
                      const SizedBox(height: 24),
                      Row(children: [
                        Expanded(child: AppTextInput(controller: bride, placeholder: 'Kelin ismi')),
                        const SizedBox(width: 10),
                        Expanded(child: AppTextInput(controller: groom, placeholder: 'Kuyov ismi')),
                      ]),
                      const SizedBox(height: 12),
                      Row(children: [
                        Expanded(child: AppTextInput(controller: date, placeholder: 'Sana (2026-08-02)')),
                        const SizedBox(width: 10),
                        Expanded(child: AppTextInput(controller: time, placeholder: 'Vaqt (18:00)')),
                      ]),
                      const SizedBox(height: 12),
                      Row(children: [
                        Expanded(child: AppTextInput(controller: place, placeholder: "To'yxona nomi")),
                        const SizedBox(width: 10),
                        Expanded(child: AppTextInput(controller: city, placeholder: 'Shahar')),
                      ]),
                      const SizedBox(height: 18),
                      AppButton(
                        text: 'Boshlash',
                        normalColor: AppTheme.green,
                        hoverColor: AppTheme.dark2,
                        textColor: Colors.white,
                        height: 50,
                        onPressed: _start,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
