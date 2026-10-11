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
      'app_title': 'Calculator',
      'language': 'Language',
      'first_number': 'First Number',
      'second_number': 'Second Number',
      'add': 'Add',
      'subtract': 'Subtract',
      'multiply': 'Multiply',
      'divide': 'Divide',
      'clear': 'Clear',
      'result': 'Result',
      'invalid_input': 'Please enter valid numbers',
      'divide_zero': 'Cannot divide by zero',
    },
    'hi': {
      'app_title': 'कैलकुलेटर',
      'language': 'भाषा',
      'first_number': 'पहली संख्या',
      'second_number': 'दूसरी संख्या',
      'add': 'जोड़ें',
      'subtract': 'घटाएं',
      'multiply': 'गुणा करें',
      'divide': 'भाग दें',
      'clear': 'साफ़ करें',
      'result': 'परिणाम',
      'invalid_input': 'कृपया सही संख्याएं दर्ज करें',
      'divide_zero': 'शून्य से भाग नहीं दिया जा सकता',
    },
    'gu': {
      'app_title': 'કેલ્ક્યુલેટર',
      'language': 'ભાષા',
      'first_number': 'પહેલો નંબર',
      'second_number': 'બીજો નંબર',
      'add': 'ઉમેરો',
      'subtract': 'બાદ કરો',
      'multiply': 'ગુણાકાર',
      'divide': 'ભાગાકાર',
      'clear': 'સાફ કરો',
      'result': 'પરિણામ',
      'invalid_input': 'કૃપા કરીને સાચા નંબર દાખલ કરો',
      'divide_zero': 'શૂન્ય વડે ભાગી શકાતું નથી',
    },
  };

  // text for the language currently used by the app
  static String t(BuildContext context, String key) {
    final code = Localizations.localeOf(context).languageCode;
    return _data[code]?[key] ?? _data['en']![key] ?? key;
  }
}