import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final code = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.t(context, 'app_title'))),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.translate, size: 90, color: Colors.green),
              const SizedBox(height: 16),
              Text(
                AppStrings.t(context, 'welcome'),
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.t(context, 'hello_message'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(AppStrings.t(context, 'current_language')),
                  subtitle: Text(AppStrings.languageNames[code] ?? code),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/language');
                  },
                  icon: const Icon(Icons.swap_horiz),
                  label: Text(AppStrings.t(context, 'change_language')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}