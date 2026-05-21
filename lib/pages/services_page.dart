import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/data_store.dart';
import '../data/wedding_models.dart';
import '../ui/theme.dart';
import '../ui/widgets.dart';
import '../util/format_util.dart';

class ServicesPage extends ConsumerStatefulWidget {
  const ServicesPage();

  @override
  ConsumerState<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends ConsumerState<ServicesPage> {
  static const _categories = [
    "To'yxona", 'Artist', 'Foto/Video', 'Boshlovchi', 'Dekor', 'Transport', 'Libos', 'Make-up',
  ];
  static const _filters = ['Barchasi', ..._categories];

  final name = TextEditingController();
  final phone = TextEditingController();
  final price = TextEditingController();
  String category = "To'yxona";
  String filter = 'Barchasi';

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = ref.watch(dataStoreProvider.notifier);
    final d = ref.watch(dataStoreProvider);

    final filtered = d.services.where((s) => filter == 'Barchasi' || s.category == filter).toList();

    return ListView(
      children: [
        Row(
          children: [
            Expanded(child: _summary('JAMI XIZMATLAR', '${d.services.length}', AppTheme.green)),
            const SizedBox(width: 10),
            Expanded(
              child: _summary('BAND QILINGAN', '${store.servicesByStatus('Band qilingan')}', AppTheme.gold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _summary('UMUMIY NARX', FormatUtil.money(store.servicesTotalPrice()), Colors.white),
        const SizedBox(height: 16),
        AppCard(
          child: Column(
            children: [
              AppTextInput(controller: name, placeholder: 'Xizmat nomi'),
              const SizedBox(height: 10),
              AppSelectBox(
                options: _categories,
                selected: category,
                onChanged: (v) => setState(() => category = v),
              ),
              const SizedBox(height: 10),
              AppTextInput(controller: phone, placeholder: 'Telefon'),
              const SizedBox(height: 10),
              AppTextInput(
                controller: price,
                placeholder: 'Narx',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              AppButton(
                text: "+ Qo'shish",
                normalColor: AppTheme.green,
                hoverColor: AppTheme.dark2,
                textColor: Colors.white,
                width: double.infinity,
                onPressed: () {
                  store.addService(name.text, category, phone.text, FormatUtil.parseMoney(price.text));
                  name.clear();
                  phone.clear();
                  price.clear();
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppSelectBox(
          options: _filters,
          selected: filter,
          onChanged: (v) => setState(() => filter = v),
        ),
        const SizedBox(height: 12),
        for (final s in filtered) ...[
          _serviceCard(s),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _summary(String title, String value, Color color) {
    final titleColor = color == Colors.white ? AppTheme.green : Colors.white;
    final valueColor = color == Colors.white ? AppTheme.text : Colors.white;
    return AppCard(
      color: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionLabel(text: title, color: titleColor, letterSpacing: 3),
          const SizedBox(height: 8),
          Text(value, style: AppTheme.font(size: 22, color: valueColor)),
        ],
      ),
    );
  }

  Widget _serviceCard(ServiceData s) {
    final store = ref.read(dataStoreProvider.notifier);
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarSquare(letter: s.category.isNotEmpty ? s.category[0] : '?', size: 56, fontSize: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.name, style: AppTheme.font(size: 18, color: AppTheme.text, weight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(
                  '${s.category}  |  ${s.phone.isEmpty ? '—' : s.phone}',
                  style: AppTheme.font(size: 12, color: AppTheme.muted),
                ),
                const SizedBox(height: 8),
                Text(
                  FormatUtil.money(s.price),
                  style: AppTheme.font(size: 18, color: AppTheme.green, weight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    AppButton(
                      text: s.status,
                      normalColor: s.status == 'Band qilingan' ? AppTheme.okSoft : AppTheme.soft,
                      hoverColor: Colors.white,
                      textColor: AppTheme.text,
                      height: 36,
                      width: 140,
                      fontSize: 12,
                      onPressed: () {
                        final next = s.status == 'Kutilmoqda' ? 'Band qilingan' : 'Kutilmoqda';
                        store.setServiceStatus(s.id, next);
                      },
                    ),
                    const SizedBox(width: 8),
                    AppButton(
                      text: '×',
                      normalColor: Colors.white,
                      hoverColor: AppTheme.soft,
                      textColor: AppTheme.red,
                      height: 36,
                      width: 40,
                      fontSize: 18,
                      onPressed: () => store.removeService(s.id),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
