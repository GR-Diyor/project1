import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/data_store.dart';
import '../data/wedding_models.dart';
import '../ui/theme.dart';
import '../ui/widgets.dart';

class ChecklistPage extends ConsumerStatefulWidget {
  const ChecklistPage();

  @override
  ConsumerState<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends ConsumerState<ChecklistPage> {
  final taskCtrl = TextEditingController();
  String? selectedSection;

  @override
  void dispose() {
    taskCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = ref.watch(dataStoreProvider.notifier);
    final d = ref.watch(dataStoreProvider);
    final sectionNames = d.sections.map((s) => s.title).toList();
    if (sectionNames.isEmpty) {
      return Center(
        child: Text("Bo'limlar yo'q", style: AppTheme.font(size: 14, color: AppTheme.muted)),
      );
    }
    selectedSection ??= sectionNames.first;
    if (!sectionNames.contains(selectedSection)) selectedSection = sectionNames.first;

    return ListView(
      children: [
        AppCard(
          child: Column(
            children: [
              AppSelectBox(
                options: sectionNames,
                selected: selectedSection!,
                onChanged: (v) => setState(() => selectedSection = v),
              ),
              const SizedBox(height: 10),
              AppTextInput(controller: taskCtrl, placeholder: 'Yangi vazifa nomini kiriting...'),
              const SizedBox(height: 10),
              AppButton(
                text: "+ Vazifa qo'shish",
                normalColor: AppTheme.green,
                hoverColor: AppTheme.dark2,
                textColor: Colors.white,
                width: double.infinity,
                onPressed: () {
                  final idx = sectionNames.indexOf(selectedSection!);
                  store.addCustomTask(idx, taskCtrl.text);
                  taskCtrl.clear();
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < d.sections.length; i++) ...[
          _sectionCard(i, d.sections[i]),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _sectionCard(int idx, TaskSectionData section) {
    final store = ref.read(dataStoreProvider.notifier);
    final done = section.tasks.where((t) => t.done).length;
    final pct = section.tasks.isEmpty ? 0.0 : done / section.tasks.length;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 38, height: 38, color: AppTheme.green),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(section.title, style: AppTheme.font(size: 18, color: AppTheme.text)),
                    Text(section.subtitle, style: AppTheme.font(size: 12, color: AppTheme.muted)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text('$done / ${section.tasks.length} bajarildi',
                    style: AppTheme.font(size: 13, color: AppTheme.muted)),
              ),
              Text('${(pct * 100).toInt()}%',
                  style: AppTheme.font(size: 13, color: AppTheme.gold, weight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 6),
          AppProgressBar(value: pct, height: 5),
          const SizedBox(height: 12),
          for (final task in section.tasks)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _taskRow(idx, task),
            ),
        ],
      ),
    );
  }

  Widget _taskRow(int sectionIdx, TaskData task) {
    final store = ref.read(dataStoreProvider.notifier);
    return InkWell(
      onTap: () => store.toggleTask(sectionIdx, task.id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        color: task.done ? const Color(0xFFEEF7F3) : Colors.white,
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: task.done ? AppTheme.green : Colors.white,
                border: Border.all(color: AppTheme.line),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                task.done ? '✓  ${task.title}' : task.title,
                style: AppTheme.font(
                  size: 14,
                  color: task.done ? AppTheme.muted : AppTheme.text,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
