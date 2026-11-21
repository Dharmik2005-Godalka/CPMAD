import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import '../utils/app_strings.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  static const Map<String, String> _languages = {
    'en': 'English',
    'hi': 'हिन्दी',
    'gu': 'ગુજરાતી',
  };

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final auth = context.watch<AuthProvider>();
    final localeProvider = context.watch<LocaleProvider>();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(auth.displayName),
            accountEmail: Text(auth.email),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person, size: 36),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              s.language,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ..._languages.entries.map((entry) {
            final selected = localeProvider.locale.languageCode == entry.key;
            return ListTile(
              leading: const Icon(Icons.language),
              title: Text(entry.value),
              trailing: selected
                  ? Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
              onTap: () {
                localeProvider.setLocale(Locale(entry.key));
                Navigator.pop(context); // close the drawer
              },
            );
          }),
        ],
      ),
    );
  }
}
