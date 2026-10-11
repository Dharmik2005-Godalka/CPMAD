import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/calculator_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // restore the saved language when the app starts
  final prefs = await SharedPreferences.getInstance();
  final savedCode = prefs.getString('language_code') ?? 'en';

  runApp(MyApp(startLocale: Locale(savedCode)));
}

class MyApp extends StatefulWidget {
  final Locale startLocale;

  const MyApp({super.key, required this.startLocale});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Locale locale;

  @override
  void initState() {
    super.initState();
    locale = widget.startLocale;
  }

  // save the selected language and change the app locale
  Future<void> changeLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', code);
    setState(() {
      locale = Locale(code);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      locale: locale,
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('gu'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: CalculatorScreen(onLanguageChanged: changeLanguage),
    );
  }
}