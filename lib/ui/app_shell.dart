import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/data_store.dart';
import '../pages/budget_page.dart';
import '../pages/checklist_page.dart';
import '../pages/dashboard_page.dart';
import '../pages/guests_page.dart';
import '../pages/invitation_page.dart';
import '../pages/services_page.dart';
import '../pages/settings_page.dart';
import 'theme.dart';
import 'widgets.dart';

enum PageType { dashboard, guests, services, checklist, budget, invitation, settings }

class _PageInfo {
  final String title;
  final String icon;
  final String label;
  const _PageInfo(this.title, this.icon, this.label);
}

const Map<PageType, _PageInfo> _pageInfo = {
  PageType.dashboard: _PageInfo('BOSH SAHIFA', '▦', 'Bosh sahifa'),
  PageType.guests: _PageInfo('MEHMONLAR', '♙', 'Mehmonlar'),
  PageType.services: _PageInfo('XIZMATLAR', '✦', 'Xizmatlar'),
  PageType.checklist: _PageInfo("RO'YXAT", '☑', "Ro'yxat"),
  PageType.budget: _PageInfo('BYUDJET', '▣', 'Byudjet'),
  PageType.invitation: _PageInfo('TAKLIFNOMA', '▩', 'Taklifnoma'),
  PageType.settings: _PageInfo('SOZLAMALAR', '⚙', 'Sozlamalar'),
};

class AppShell extends ConsumerStatefulWidget {
  const AppShell();

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  PageType _current = PageType.dashboard;

  void _select(PageType p) {
    setState(() => _current = p);
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(dataStoreProvider);
    final info = _pageInfo[_current]!;

    return Scaffold(
      backgroundColor: AppTheme.bg,
      drawer: _Sidebar(
        current: _current,
        onSelect: _select,
        appTitle: data.settings.appTitle,
        coupleTitle: data.settings.coupleTitle,
      ),
      appBar: AppBar(
        backgroundColor: AppTheme.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: AppTheme.dark,
        iconTheme: const IconThemeData(color: AppTheme.dark),
        title: Text(
          data.settings.coupleTitle,
          style: AppTheme.font(size: 16, color: AppTheme.green, style: 'elegant'),
        ),
      ),
      body: PatternBackground(
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PageTitle(small: info.title, big: data.settings.coupleTitle),
                const SizedBox(height: 16),
                Expanded(child: _buildPage()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPage() {
    switch (_current) {
      case PageType.dashboard:
        return const DashboardPage();
      case PageType.guests:
        return const GuestsPage();
      case PageType.services:
        return const ServicesPage();
      case PageType.checklist:
        return const ChecklistPage();
      case PageType.budget:
        return const BudgetPage();
      case PageType.invitation:
        return const InvitationPage();
      case PageType.settings:
        return const SettingsPage();
    }
  }
}

class _Sidebar extends StatelessWidget {
  final PageType current;
  final ValueChanged<PageType> onSelect;
  final String appTitle;
  final String coupleTitle;

  const _Sidebar({
    required this.current,
    required this.onSelect,
    required this.appTitle,
    required this.coupleTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.dark,
      width: 280,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Text(
                appTitle,
                style: AppTheme.font(
                  size: 12,
                  color: AppTheme.gold,
                  weight: FontWeight.w700,
                  letterSpacing: 4,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: Text(
                coupleTitle,
                style: AppTheme.font(size: 24, color: Colors.white, style: 'elegant'),
              ),
            ),
            const SizedBox(height: 12),
            Container(width: 30, height: 1, margin: const EdgeInsets.only(left: 20), color: AppTheme.gold),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: PageType.values.map((p) {
                  final info = _pageInfo[p]!;
                  final active = p == current;
                  return _SidebarItem(
                    label: info.label,
                    icon: info.icon,
                    active: active,
                    onTap: () => onSelect(p),
                  );
                }).toList(),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(14),
              color: AppTheme.dark2,
              child: Text(
                "An'analarga sodiq, zamonaviy to'y rejalashtiruvchi. Oilangiz uchun bir joyda.",
                style: AppTheme.font(size: 12, color: const Color(0xFFD8EFE5), height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final String label;
  final String icon;
  final bool active;
  final VoidCallback onTap;
  const _SidebarItem({required this.label, required this.icon, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textColor = active ? AppTheme.gold : Colors.white;
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        color: active ? AppTheme.dark2 : Colors.transparent,
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Text(
                icon,
                style: AppTheme.font(size: 16, color: textColor, style: 'icon'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppTheme.font(size: 14, color: textColor),
              ),
            ),
            if (active)
              Container(width: 6, height: 6, color: AppTheme.gold),
          ],
        ),
      ),
    );
  }
}
