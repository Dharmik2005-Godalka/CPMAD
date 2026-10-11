import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';

class LanguageScreen extends StatelessWidget {
  final Future<void> Function(String) onChanged;

  const LanguageScreen({super.key, required this.onChanged});

  static const Map<String, String> languages = {
    'en': 'English',
    'hi': 'हिन्दी',
    'gu': 'ગુજરાતી',
  };

  @override
  Widget build(BuildContext context) {
    final current = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.t(context, 'select_language'))),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: languages.entries.map((entry) {
          final isSelected = entry.key == current;
          return Card(
            child: ListTile(
              leading: const Icon(Icons.translate),
              title: Text(entry.value),
              trailing: isSelected
                  ? const Icon(Icons.check_circle, color: Colors.indigo)
                  : null,
              onTap: () async {
                await onChanged(entry.key);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppStrings.byCode(entry.key, 'language_changed'),
                    ),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
