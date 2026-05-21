import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'wedding_models.dart';

const _kSaveKey = 'toy_manager_save_payload';

class DataStore extends StateNotifier<WeddingData> {
  DataStore(this._prefs, WeddingData initial) : super(initial);

  final SharedPreferences _prefs;

  @override
  bool updateShouldNotify(WeddingData old, WeddingData current) => true;

  int _nextGuestId = 100;
  int _nextTaskId = 100;
  int _nextBudgetId = 100;
  int _nextServiceId = 100;
  int _nextEventId = 100;

  static Future<DataStore> create(SharedPreferences prefs) async {
    final raw = prefs.getString(_kSaveKey);
    WeddingData data;
    if (raw != null && raw.isNotEmpty) {
      try {
        data = WeddingData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      } catch (_) {
        data = _defaultData();
      }
    } else {
      data = _defaultData();
    }
    final store = DataStore(prefs, data);
    store._scanIds();
    store._migrate();
    await store._persist();
    return store;
  }

  void _scanIds() {
    for (final g in state.guests) {
      if (g.id >= _nextGuestId) _nextGuestId = g.id + 1;
    }
    for (final s in state.sections) {
      for (final t in s.tasks) {
        if (t.id >= _nextTaskId) _nextTaskId = t.id + 1;
      }
    }
    for (final s in state.services) {
      if (s.id >= _nextServiceId) _nextServiceId = s.id + 1;
    }
    for (final b in state.budget) {
      if (b.id >= _nextBudgetId) _nextBudgetId = b.id + 1;
    }
    for (final e in state.events) {
      if (e.id >= _nextEventId) _nextEventId = e.id + 1;
    }
  }

  void _migrate() {
    final def = _defaultData();
    if (state.events.isEmpty) state.events = def.events;
    if (state.sections.isEmpty) state.sections = def.sections;
    if (state.settings.coupleTitle.isEmpty) {
      state.settings.coupleTitle = '${state.bride} & ${state.groom}';
    }
  }

  Future<void> _persist() async {
    await _prefs.setString(_kSaveKey, jsonEncode(state.toJson()));
  }

  void _save() {
    state = state;
    _persist();
  }

  Future<void> reset() async {
    state = _defaultData();
    _scanIds();
    await _persist();
  }

  // Wedding info
  void updateWeddingInfo({
    required String bride,
    required String groom,
    required String dateISO,
    required String place,
    required String city,
  }) {
    if (bride.trim().isNotEmpty) state.bride = bride.trim();
    if (groom.trim().isNotEmpty) state.groom = groom.trim();
    if (dateISO.trim().isNotEmpty) state.dateISO = dateISO.trim();
    if (place.trim().isNotEmpty) state.place = place.trim();
    if (city.trim().isNotEmpty) state.city = city.trim();
    state.settings.coupleTitle = '${state.bride} & ${state.groom}';
    _save();
  }

  void completeSetup({
    required String bride,
    required String groom,
    required String dateISO,
    required String place,
    required String city,
  }) {
    state.bride = bride;
    state.groom = groom;
    state.dateISO = dateISO;
    state.place = place.isEmpty ? "To'yxona" : place;
    state.city = city.isEmpty ? 'Toshkent' : city;
    state.settings.coupleTitle = '$bride & $groom';
    state.isSetup = true;
    _save();
  }

  void updateAppTitle(String appTitle) {
    final t = appTitle.trim();
    if (t.isNotEmpty) state.settings.appTitle = t;
    _save();
  }

  void updateBudgetLimit(double limit) {
    state.budgetLimit = limit;
    _save();
  }

  // Events
  void addEvent(String name, String subtitle) {
    final n = name.trim();
    final s = subtitle.trim();
    if (n.isEmpty) return;
    state.events.add(EventDef(id: _nextEventId++, name: n, subtitle: s));
    _save();
  }

  void removeEvent(int id) {
    final ev = state.events.where((e) => e.id == id).firstOrNull;
    if (ev == null) return;
    state.guests.removeWhere((g) => g.event == ev.name);
    state.events.removeWhere((e) => e.id == id);
    _save();
  }

  // Guests
  void addGuest(String name, String event) {
    final n = name.trim();
    if (n.isEmpty) return;
    state.guests.add(GuestData(id: _nextGuestId++, name: n, event: event, status: 'Kutilmoqda'));
    _save();
  }

  void removeGuest(int id) {
    state.guests.removeWhere((g) => g.id == id);
    _save();
  }

  void setGuestStatus(int id, String status) {
    for (final g in state.guests) {
      if (g.id == id) g.status = status;
    }
    _save();
  }

  // Tasks
  void addCustomTask(int sectionIndex, String title) {
    if (sectionIndex < 0 || sectionIndex >= state.sections.length) return;
    final t = title.trim();
    if (t.isEmpty) return;
    state.sections[sectionIndex].tasks.add(TaskData(id: _nextTaskId++, title: t, done: false));
    _save();
  }

  void toggleTask(int sectionIndex, int taskId) {
    if (sectionIndex < 0 || sectionIndex >= state.sections.length) return;
    for (final t in state.sections[sectionIndex].tasks) {
      if (t.id == taskId) {
        t.done = !t.done;
        break;
      }
    }
    _save();
  }

  // Services
  void addService(String name, String category, String phone, double price) {
    final n = name.trim();
    final ph = phone.trim();
    if (n.isEmpty) return;
    state.services.add(ServiceData(
      id: _nextServiceId++,
      name: n,
      category: category,
      phone: ph,
      price: price,
      status: 'Kutilmoqda',
    ));
    _save();
  }

  void removeService(int id) {
    state.services.removeWhere((s) => s.id == id);
    _save();
  }

  void setServiceStatus(int id, String status) {
    for (final s in state.services) {
      if (s.id == id) {
        s.status = status;
        break;
      }
    }
    _save();
  }

  // Budget
  void addBudget(String vendor, double total, double paid) {
    final v = vendor.trim();
    if (v.isEmpty || total <= 0) return;
    state.budget.add(BudgetRowData(id: _nextBudgetId++, vendor: v, total: total, paid: paid));
    _save();
  }

  void removeBudget(int id) {
    state.budget.removeWhere((b) => b.id == id);
    _save();
  }

  void setBudgetPaid(int id, double paid) {
    for (final b in state.budget) {
      if (b.id == id) {
        b.paid = paid.clamp(0, b.total).toDouble();
        break;
      }
    }
    _save();
  }

  // Invitation
  void setInvitation({required String message, required String guest}) {
    state.invitationMessage = message.isEmpty ? 'Taklif qilamiz' : message;
    state.invitationGuest = guest.isEmpty ? 'Aziz mehmon' : guest;
    _save();
  }

  void setRsvp(String rsvp) {
    state.rsvp = rsvp;
    _save();
  }

  // Derived
  int confirmedGuests() => state.guests.where((g) => g.status == 'Tasdiqlangan').length;
  int pendingGuests() => state.guests.where((g) => g.status == 'Kutilmoqda').length;
  int rejectedGuests() => state.guests.where((g) => g.status == 'Rad etilgan').length;
  int servicesByStatus(String status) => state.services.where((s) => s.status == status).length;
  double servicesTotalPrice() => state.services.fold(0.0, (a, s) => a + s.price);
  double budgetTotal() => state.budget.fold(0.0, (a, b) => a + b.total);
  double budgetPaid() => state.budget.fold(0.0, (a, b) => a + b.paid);
  int taskTotal() => state.sections.fold(0, (a, s) => a + s.tasks.length);
  int taskDone() =>
      state.sections.fold(0, (a, s) => a + s.tasks.where((t) => t.done).length);

  static WeddingData _defaultData() => WeddingData(
        isSetup: false,
        bride: '',
        groom: '',
        dateISO: '2026-08-02T18:00:00',
        place: "To'yxona",
        city: 'Toshkent',
        events: [
          EventDef(id: 1, name: 'Nahorgi osh', subtitle: 'Erkaklar uchun'),
          EventDef(id: 2, name: 'Kechki banket', subtitle: 'Aralash mehmonlar'),
        ],
        guests: [],
        services: [],
        budget: [],
        sections: [
          TaskSectionData(
            title: "To'y oldi",
            subtitle: 'Fotiha-toy, tayyorgarlik',
            tasks: [TaskData(id: 1, title: "To'yxona band qilish", done: false)],
          ),
        ],
        budgetLimit: 100000000,
        invitationGuest: 'Aziz mehmon',
        invitationMessage: 'Bizning hayotimizdagi eng unutilmas kunga taklif qilamiz!',
        settings: AppSettings(
          appTitle: "TO'Y-MANAGER",
          coupleTitle: 'Kelin & Kuyov',
          theme: ThemeSettings(bg: 0, text: 0, dark: 0, green: 0, gold: 0),
        ),
        rsvp: 'Kutilmoqda',
      );
}

final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Override in ProviderScope');
});

final dataStoreProvider = StateNotifierProvider<DataStore, WeddingData>((ref) {
  throw UnimplementedError('Override in ProviderScope');
});
