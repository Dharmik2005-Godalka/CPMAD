import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';

class LanguageScreen extends StatefulWidget {
  final Future<void> Function(String) onSave;

  const LanguageScreen({super.key, required this.onSave});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String? selected;

  @override
  Widget build(BuildContext context) {
    // start with the language that is currently active
    selected ??= Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.t(context, 'select_language'))),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ...AppStrings.languageNames.entries.map(
              (entry) => Card(
                child: ListTile(
                  leading: const Icon(Icons.translate),
                  title: Text(entry.value),
                  trailing: entry.key == selected
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                  onTap: () {
                    setState(() {
                      selected = entry.key;
                    });
                  },
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final code = selected!;
                  await widget.onSave(code);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppStrings.byCode(code, 'saved_message')),
                    ),
                  );
                  Navigator.pop(context);
                },
                child: Text(AppStrings.t(context, 'save')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}