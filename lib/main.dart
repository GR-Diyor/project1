import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/data_store.dart';
import 'pages/welcome_page.dart';
import 'ui/app_shell.dart';
import 'ui/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final store = await DataStore.create(prefs);

  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
        dataStoreProvider.overrideWith((ref) => store),
      ],
      child: const ToyManagerApp(),
    ),
  );
}

class ToyManagerApp extends ConsumerWidget {
  const ToyManagerApp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dataStoreProvider);
    return MaterialApp(
      title: "To'y Manager",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.materialTheme(),
      home: data.isSetup ? const AppShell() : const WelcomePage(),
    );
  }
}
