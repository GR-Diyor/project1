import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/data_store.dart';
import '../data/wedding_models.dart';
import '../ui/theme.dart';
import '../ui/widgets.dart';
import '../util/format_util.dart';

class BudgetPage extends ConsumerStatefulWidget {
  const BudgetPage();

  @override
  ConsumerState<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends ConsumerState<BudgetPage> {
  final limit = TextEditingController();
  final vendor = TextEditingController();
  final total = TextEditingController();
  final paid = TextEditingController();
  bool _limitInit = false;

  @override
  void dispose() {
    limit.dispose();
    vendor.dispose();
    total.dispose();
    paid.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = ref.watch(dataStoreProvider.notifier);
    final d = ref.watch(dataStoreProvider);

    if (!_limitInit) {
      limit.text = d.budgetLimit.toStringAsFixed(0);
      _limitInit = true;
    }

    final budgetPaid = store.budgetPaid();
    final budgetTotal = store.budgetTotal();
    final left = d.budgetLimit - budgetPaid;

    return ListView(
      children: [
        AppCard(
          color: AppTheme.green,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionLabel(text: 'BELGILANGAN LIMIT', color: Colors.white, letterSpacing: 2),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppTextInput(
                      controller: limit,
                      placeholder: 'Summa',
                      height: 40,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  AppButton(
                    text: 'Saqlash',
                    normalColor: AppTheme.gold,
                    hoverColor: AppTheme.gold2,
                    textColor: Colors.white,
                    height: 40,
                    width: 100,
                    onPressed: () {
                      store.updateBudgetLimit(FormatUtil.parseMoney(limit.text));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _summary("TO'LANGAN", FormatUtil.money(budgetPaid), AppTheme.gold)),
            const SizedBox(width: 10),
            Expanded(child: _summary('QOLDIQ BYUDJET', FormatUtil.money(left), Colors.white)),
          ],
        ),
        const SizedBox(height: 16),
        AppCard(
          child: Column(
            children: [
              AppTextInput(controller: vendor, placeholder: "Vendor (To'yxona, Artist...)"),
              const SizedBox(height: 10),
              AppTextInput(
                controller: total,
                placeholder: 'Umumiy narx',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              AppTextInput(
                controller: paid,
                placeholder: "Bo'nak",
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
                  store.addBudget(
                    vendor.text,
                    FormatUtil.parseMoney(total.text),
                    FormatUtil.parseMoney(paid.text),
                  );
                  vendor.clear();
                  total.clear();
                  paid.clear();
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        for (final row in d.budget) ...[
          _BudgetRow(row: row, key: ValueKey('budget_${row.id}')),
          const SizedBox(height: 10),
        ],
        if (d.budget.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(14),
            color: const Color(0xFFF1F8F5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('Jami',
                          style: AppTheme.font(size: 15, color: AppTheme.text, weight: FontWeight.w700)),
                    ),
                    Text(FormatUtil.money(budgetTotal),
                        style: AppTheme.font(size: 15, color: AppTheme.green)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Text("To'langan", style: AppTheme.font(size: 13, color: AppTheme.muted)),
                    ),
                    Text(FormatUtil.money(budgetPaid),
                        style: AppTheme.font(size: 15, color: AppTheme.green)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Text('Qoldiq', style: AppTheme.font(size: 13, color: AppTheme.muted)),
                    ),
                    Text(FormatUtil.money(budgetTotal - budgetPaid),
                        style: AppTheme.font(size: 15, color: AppTheme.red)),
                  ],
                ),
              ],
            ),
          ),
        const SizedBox(height: 16),
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
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value, style: AppTheme.font(size: 20, color: valueColor)),
          ),
        ],
      ),
    );
  }

}

class _BudgetRow extends ConsumerStatefulWidget {
  final BudgetRowData row;
  const _BudgetRow({required this.row, super.key});

  @override
  ConsumerState<_BudgetRow> createState() => _BudgetRowState();
}

class _BudgetRowState extends ConsumerState<_BudgetRow> {
  late final TextEditingController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = TextEditingController(text: widget.row.paid.toStringAsFixed(0));
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = ref.read(dataStoreProvider.notifier);
    final row = widget.row;
    final left = row.total - row.paid;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(row.vendor,
                    style: AppTheme.font(size: 15, color: AppTheme.text, weight: FontWeight.w700)),
              ),
              AppButton(
                text: '×',
                normalColor: Colors.white,
                hoverColor: AppTheme.soft,
                textColor: AppTheme.red,
                height: 32,
                width: 34,
                fontSize: 16,
                onPressed: () => store.removeBudget(row.id),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Umumiy: ${FormatUtil.money(row.total)}',
              style: AppTheme.font(size: 13, color: AppTheme.muted)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: AppTextInput(
                  controller: ctrl,
                  placeholder: "To'langan",
                  height: 36,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              AppButton(
                text: 'OK',
                normalColor: AppTheme.soft,
                hoverColor: Colors.white,
                textColor: AppTheme.text,
                height: 36,
                width: 50,
                onPressed: () => store.setBudgetPaid(row.id, FormatUtil.parseMoney(ctrl.text)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AppProgressBar(
            value: row.total <= 0 ? 0 : row.paid / row.total,
            height: 5,
          ),
          const SizedBox(height: 6),
          Text(
            left <= 0 ? "To'liq to'langan" : 'Qoldiq: ${FormatUtil.money(left)}',
            style: AppTheme.font(size: 13, color: left <= 0 ? AppTheme.green : AppTheme.red),
          ),
        ],
      ),
    );
  }
}
