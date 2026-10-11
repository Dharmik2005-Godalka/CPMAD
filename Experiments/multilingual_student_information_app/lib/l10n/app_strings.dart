import 'package:flutter/material.dart';

class AppStrings {
  static const Map<String, Map<String, String>> _data = {
    'en': {
      'app_title': 'Student Information',
      'welcome': 'Welcome!',
      'today': 'Today',
      'total_students': 'Total Students',
      'student_list': 'Student List',
      'student_details': 'Student Details',
      'language': 'Language',
      'select_language': 'Select Language',
      'language_changed': 'Language changed successfully',
      'roll_no': 'Roll Number',
      'name': 'Name',
      'department': 'Department',
      'admission_date': 'Admission Date',
      'fees': 'Fees',
      'percentage': 'Percentage',
      'dept_computer': 'Computer Engineering',
      'dept_it': 'Information Technology',
      'dept_mech': 'Mechanical Engineering',
      'dept_electronics': 'Electronics',
    },
    'hi': {
      'app_title': 'छात्र जानकारी',
      'welcome': 'स्वागत है!',
      'today': 'आज',
      'total_students': 'कुल छात्र',
      'student_list': 'छात्र सूची',
      'student_details': 'छात्र विवरण',
      'language': 'भाषा',
      'select_language': 'भाषा चुनें',
      'language_changed': 'भाषा सफलतापूर्वक बदल दी गई',
      'roll_no': 'रोल नंबर',
      'name': 'नाम',
      'department': 'विभाग',
      'admission_date': 'प्रवेश तिथि',
      'fees': 'शुल्क',
      'percentage': 'प्रतिशत',
      'dept_computer': 'कंप्यूटर इंजीनियरिंग',
      'dept_it': 'सूचना प्रौद्योगिकी',
      'dept_mech': 'मैकेनिकल इंजीनियरिंग',
      'dept_electronics': 'इलेक्ट्रॉनिक्स',
    },
    'gu': {
      'app_title': 'વિદ્યાર્થી માહિતી',
      'welcome': 'સ્વાગત છે!',
      'today': 'આજે',
      'total_students': 'કુલ વિદ્યાર્થીઓ',
      'student_list': 'વિદ્યાર્થી યાદી',
      'student_details': 'વિદ્યાર્થી વિગતો',
      'language': 'ભાષા',
      'select_language': 'ભાષા પસંદ કરો',
      'language_changed': 'ભાષા સફળતાપૂર્વક બદલાઈ',
      'roll_no': 'રોલ નંબર',
      'name': 'નામ',
      'department': 'વિભાગ',
      'admission_date': 'પ્રવેશ તારીખ',
      'fees': 'ફી',
      'percentage': 'ટકાવારી',
      'dept_computer': 'કમ્પ્યુટર એન્જિનિયરિંગ',
      'dept_it': 'માહિતી ટેકનોલોજી',
      'dept_mech': 'મિકેનિકલ એન્જિનિયરિંગ',
      'dept_electronics': 'ઇલેક્ટ્રોનિક્સ',
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