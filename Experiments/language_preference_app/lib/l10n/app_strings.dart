import 'package:flutter/material.dart';

class AppStrings {
  // language code -> name written in its own language
  static const Map<String, String> languageNames = {
    'en': 'English',
    'hi': 'हिन्दी',
    'gu': 'ગુજરાતી',
  };

  static const Map<String, Map<String, String>> _data = {
    'en': {
      'app_title': 'Language Preference',
      'welcome': 'Welcome!',
      'hello_message': 'Hello! This app remembers your language.',
      'current_language': 'Current Language',
      'change_language': 'Change Language',
      'select_language': 'Select Language',
      'save': 'Save',
      'saved_message': 'Language preference saved',
    },
    'hi': {
      'app_title': 'भाषा प्राथमिकता',
      'welcome': 'स्वागत है!',
      'hello_message': 'नमस्ते! यह ऐप आपकी भाषा याद रखता है।',
      'current_language': 'वर्तमान भाषा',
      'change_language': 'भाषा बदलें',
      'select_language': 'भाषा चुनें',
      'save': 'सहेजें',
      'saved_message': 'भाषा प्राथमिकता सहेजी गई',
    },
    'gu': {
      'app_title': 'ભાષા પસંદગી',
      'welcome': 'સ્વાગત છે!',
      'hello_message': 'નમસ્તે! આ એપ તમારી ભાષા યાદ રાખે છે.',
      'current_language': 'વર્તમાન ભાષા',
      'change_language': 'ભાષા બદલો',
      'select_language': 'ભાષા પસંદ કરો',
      'save': 'સાચવો',
      'saved_message': 'ભાષા પસંદગી સાચવવામાં આવી',
    },
  };

  // text for the language currently used by the app
  static String t(BuildContext context, String key) {
    final code = Localizations.localeOf(context).languageCode;
    return byCode(code, key);
  }

  // text for a specific language code
  static String byCode(String code, String key) {
    return _data[code]?[key] ?? _data['en']![key] ?? key;
  }
}