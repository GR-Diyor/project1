class GuestData {
  int id;
  String name;
  String event;
  String status;

  GuestData({required this.id, required this.name, required this.event, required this.status});

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'event': event, 'status': status};

  factory GuestData.fromJson(Map<String, dynamic> j) => GuestData(
        id: j['id'] as int,
        name: j['name'] as String,
        event: j['event'] as String,
        status: j['status'] as String,
      );
}

class TaskData {
  int id;
  String title;
  bool done;

  TaskData({required this.id, required this.title, required this.done});

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'done': done};

  factory TaskData.fromJson(Map<String, dynamic> j) => TaskData(
        id: j['id'] as int,
        title: j['title'] as String,
        done: j['done'] as bool,
      );
}

class ServiceData {
  int id;
  String name;
  String category;
  String phone;
  double price;
  String status;

  ServiceData({
    required this.id,
    required this.name,
    required this.category,
    required this.phone,
    required this.price,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'phone': phone,
        'price': price,
        'status': status,
      };

  factory ServiceData.fromJson(Map<String, dynamic> j) => ServiceData(
        id: j['id'] as int,
        name: j['name'] as String,
        category: j['category'] as String,
        phone: j['phone'] as String,
        price: (j['price'] as num).toDouble(),
        status: j['status'] as String,
      );
}

class TaskSectionData {
  String title;
  String subtitle;
  List<TaskData> tasks;

  TaskSectionData({required this.title, required this.subtitle, required this.tasks});

  Map<String, dynamic> toJson() => {
        'title': title,
        'subtitle': subtitle,
        'tasks': tasks.map((t) => t.toJson()).toList(),
      };

  factory TaskSectionData.fromJson(Map<String, dynamic> j) => TaskSectionData(
        title: j['title'] as String,
        subtitle: j['subtitle'] as String,
        tasks: (j['tasks'] as List).map((e) => TaskData.fromJson(e as Map<String, dynamic>)).toList(),
      );
}

class BudgetRowData {
  int id;
  String vendor;
  double total;
  double paid;

  BudgetRowData({required this.id, required this.vendor, required this.total, required this.paid});

  Map<String, dynamic> toJson() => {'id': id, 'vendor': vendor, 'total': total, 'paid': paid};

  factory BudgetRowData.fromJson(Map<String, dynamic> j) => BudgetRowData(
        id: j['id'] as int,
        vendor: j['vendor'] as String,
        total: (j['total'] as num).toDouble(),
        paid: (j['paid'] as num).toDouble(),
      );
}

class EventDef {
  int id;
  String name;
  String subtitle;

  EventDef({required this.id, required this.name, required this.subtitle});

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'subtitle': subtitle};

  factory EventDef.fromJson(Map<String, dynamic> j) => EventDef(
        id: j['id'] as int,
        name: j['name'] as String,
        subtitle: j['subtitle'] as String,
      );
}

class ThemeSettings {
  int bg;
  int text;
  int dark;
  int green;
  int gold;

  ThemeSettings({
    required this.bg,
    required this.text,
    required this.dark,
    required this.green,
    required this.gold,
  });

  Map<String, dynamic> toJson() => {'bg': bg, 'text': text, 'dark': dark, 'green': green, 'gold': gold};

  factory ThemeSettings.fromJson(Map<String, dynamic> j) => ThemeSettings(
        bg: j['bg'] as int,
        text: j['text'] as int,
        dark: j['dark'] as int,
        green: j['green'] as int,
        gold: j['gold'] as int,
      );
}

class AppSettings {
  String appTitle;
  String coupleTitle;
  ThemeSettings theme;

  AppSettings({required this.appTitle, required this.coupleTitle, required this.theme});

  Map<String, dynamic> toJson() => {
        'appTitle': appTitle,
        'coupleTitle': coupleTitle,
        'theme': theme.toJson(),
      };

  factory AppSettings.fromJson(Map<String, dynamic> j) => AppSettings(
        appTitle: j['appTitle'] as String,
        coupleTitle: j['coupleTitle'] as String,
        theme: ThemeSettings.fromJson(j['theme'] as Map<String, dynamic>),
      );
}

class WeddingData {
  bool isSetup;
  String bride;
  String groom;
  String dateISO;
  String place;
  String city;
  List<EventDef> events;
  List<GuestData> guests;
  List<ServiceData> services;
  List<TaskSectionData> sections;
  List<BudgetRowData> budget;
  double budgetLimit;
  String invitationGuest;
  String invitationMessage;
  AppSettings settings;
  String rsvp;

  WeddingData({
    required this.isSetup,
    required this.bride,
    required this.groom,
    required this.dateISO,
    required this.place,
    required this.city,
    required this.events,
    required this.guests,
    required this.services,
    required this.sections,
    required this.budget,
    required this.budgetLimit,
    required this.invitationGuest,
    required this.invitationMessage,
    required this.settings,
    required this.rsvp,
  });

  Map<String, dynamic> toJson() => {
        'isSetup': isSetup,
        'bride': bride,
        'groom': groom,
        'dateISO': dateISO,
        'place': place,
        'city': city,
        'events': events.map((e) => e.toJson()).toList(),
        'guests': guests.map((e) => e.toJson()).toList(),
        'services': services.map((e) => e.toJson()).toList(),
        'sections': sections.map((e) => e.toJson()).toList(),
        'budget': budget.map((e) => e.toJson()).toList(),
        'budgetLimit': budgetLimit,
        'invitationGuest': invitationGuest,
        'invitationMessage': invitationMessage,
        'settings': settings.toJson(),
        'rsvp': rsvp,
      };

  factory WeddingData.fromJson(Map<String, dynamic> j) => WeddingData(
        isSetup: (j['isSetup'] as bool?) ?? false,
        bride: (j['bride'] as String?) ?? '',
        groom: (j['groom'] as String?) ?? '',
        dateISO: (j['dateISO'] as String?) ?? '2026-08-02T18:00:00',
        place: (j['place'] as String?) ?? "To'yxona",
        city: (j['city'] as String?) ?? 'Toshkent',
        events: (j['events'] as List? ?? const [])
            .map((e) => EventDef.fromJson(e as Map<String, dynamic>))
            .toList(),
        guests: (j['guests'] as List? ?? const [])
            .map((e) => GuestData.fromJson(e as Map<String, dynamic>))
            .toList(),
        services: (j['services'] as List? ?? const [])
            .map((e) => ServiceData.fromJson(e as Map<String, dynamic>))
            .toList(),
        sections: (j['sections'] as List? ?? const [])
            .map((e) => TaskSectionData.fromJson(e as Map<String, dynamic>))
            .toList(),
        budget: (j['budget'] as List? ?? const [])
            .map((e) => BudgetRowData.fromJson(e as Map<String, dynamic>))
            .toList(),
        budgetLimit: ((j['budgetLimit'] as num?) ?? 100000000).toDouble(),
        invitationGuest: (j['invitationGuest'] as String?) ?? 'Aziz mehmon',
        invitationMessage: (j['invitationMessage'] as String?) ??
            'Bizning hayotimizdagi eng unutilmas kunga taklif qilamiz!',
        settings: j['settings'] != null
            ? AppSettings.fromJson(j['settings'] as Map<String, dynamic>)
            : AppSettings(
                appTitle: "TO'Y-MANAGER",
                coupleTitle: 'Kelin & Kuyov',
                theme: ThemeSettings(bg: 0, text: 0, dark: 0, green: 0, gold: 0),
              ),
        rsvp: (j['rsvp'] as String?) ?? 'Kutilmoqda',
      );
}
