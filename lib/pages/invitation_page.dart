import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../data/data_store.dart';
import '../ui/theme.dart';
import '../ui/widgets.dart';
import '../util/format_util.dart';

class InvitationPage extends ConsumerStatefulWidget {
  const InvitationPage();

  @override
  ConsumerState<InvitationPage> createState() => _InvitationPageState();
}

class _InvitationPageState extends ConsumerState<InvitationPage> {
  final guest = TextEditingController();
  final message = TextEditingController();
  bool _init = false;

  @override
  void dispose() {
    guest.dispose();
    message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = ref.watch(dataStoreProvider.notifier);
    final d = ref.watch(dataStoreProvider);

    if (!_init) {
      guest.text = d.invitationGuest;
      message.text = d.invitationMessage;
      _init = true;
    }

    final dateStr = FormatUtil.dateToElegantString(FormatUtil.parseSafeDate(d.dateISO)).toUpperCase();
    final cleanDate = d.dateISO.replaceAll('-', '').replaceAll(':', '');
    final qrPayload = 'BEGIN:VCALENDAR\nVERSION:2.0\nBEGIN:VEVENT\n'
        'SUMMARY:${d.groom} & ${d.bride} Nikoh to\'yi\n'
        'LOCATION:${d.place}, ${d.city}\n'
        'DTSTART:$cleanDate\n'
        'DESCRIPTION:Mehmon: ${d.invitationGuest} | RSVP: ${d.rsvp}\n'
        'END:VEVENT\nEND:VCALENDAR';

    return ListView(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppTheme.gold, width: 1.5),
          ),
          padding: const EdgeInsets.fromLTRB(28, 36, 28, 28),
          child: Column(
            children: [
              Text(
                'TAKLIFNOMA',
                style: AppTheme.font(
                  size: 14,
                  color: AppTheme.gold,
                  weight: FontWeight.w700,
                  letterSpacing: 6,
                ),
              ),
              const SizedBox(height: 18),
              Text(d.bride, style: AppTheme.font(size: 36, color: AppTheme.text, style: 'script')),
              Text('&', style: AppTheme.font(size: 28, color: AppTheme.text, style: 'script')),
              Text(d.groom, style: AppTheme.font(size: 36, color: AppTheme.text, style: 'script')),
              const SizedBox(height: 16),
              Text(
                d.invitationMessage,
                textAlign: TextAlign.center,
                style: AppTheme.font(size: 14, color: AppTheme.muted, height: 1.4),
              ),
              const SizedBox(height: 16),
              Text(
                dateStr,
                textAlign: TextAlign.center,
                style: AppTheme.font(size: 13, color: AppTheme.text, style: 'elegant'),
              ),
              const SizedBox(height: 4),
              Text(
                '${d.place}, ${d.city}',
                textAlign: TextAlign.center,
                style: AppTheme.font(size: 12, color: AppTheme.green, style: 'elegant'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppCard(
          child: Column(
            children: [
              AppTextInput(controller: message, placeholder: 'Asosiy matn', height: 42),
              const SizedBox(height: 10),
              AppTextInput(controller: guest, placeholder: 'Mehmon ismi', height: 42),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Saqlash',
                      normalColor: AppTheme.gold,
                      hoverColor: AppTheme.gold2,
                      textColor: Colors.white,
                      onPressed: () {
                        store.setInvitation(message: message.text, guest: guest.text);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppButton(
                      text: '✓ Kelaman',
                      normalColor: AppTheme.green,
                      hoverColor: AppTheme.dark2,
                      textColor: Colors.white,
                      onPressed: () => store.setRsvp('Kelaman'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppButton(
                      text: "× Yo'q",
                      normalColor: Colors.white,
                      hoverColor: AppTheme.soft,
                      textColor: AppTheme.text,
                      onPressed: () => store.setRsvp('Kela olmayman'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionLabel(text: 'RAQAMLI CHIPTA', color: AppTheme.gold, letterSpacing: 2),
              const SizedBox(height: 6),
              Text('Check-in QR kodi', style: AppTheme.font(size: 22, color: AppTheme.text)),
              const SizedBox(height: 8),
              Text(
                'Skanerlanganda to\'y kuningiz telefon taqvimiga (Calendar) avtomatik saqlanadi.',
                style: AppTheme.font(size: 12, color: AppTheme.muted, height: 1.4),
              ),
              const SizedBox(height: 18),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDFBF7),
                    border: Border.all(color: AppTheme.gold),
                  ),
                  child: QrImageView(
                    data: qrPayload,
                    version: QrVersions.auto,
                    size: 220,
                    backgroundColor: Colors.white,
                    errorCorrectionLevel: QrErrorCorrectLevel.M,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Text(
                  d.invitationGuest,
                  style: AppTheme.font(size: 18, color: AppTheme.text),
                ),
              ),
              Center(
                child: Text(
                  'RSVP: ${d.rsvp}',
                  style: AppTheme.font(size: 12, color: AppTheme.muted),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
