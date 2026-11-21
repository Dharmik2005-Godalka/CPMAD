import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppStrings {
  final Locale locale;

  const AppStrings(this.locale);

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('hi'),
    Locale('gu'),
  ];

  static const LocalizationsDelegate<AppStrings> delegate =
      _AppStringsDelegate();

  static AppStrings of(BuildContext context) {
    return Localizations.of<AppStrings>(context, AppStrings)!;
  }

  String get(String key) {
    return _values[locale.languageCode]?[key] ?? _values['en']![key] ?? key;
  }

  String goingCount(int n) => get('goingCount').replaceAll('{n}', '$n');

  String get appTitle => get('appTitle');
  String get events => get('events');
  String get upcoming => get('upcoming');
  String get myEvents => get('myEvents');
  String get notes => get('notes');
  String get rsvp => get('rsvp');
  String get going => get('going');
  String get cancelRsvp => get('cancelRsvp');
  String get searchEvents => get('searchEvents');
  String get noUpcoming => get('noUpcoming');
  String get noMyEvents => get('noMyEvents');
  String get noSearchResults => get('noSearchResults');
  String get addNote => get('addNote');
  String get noteTitle => get('noteTitle');
  String get noteContent => get('noteContent');
  String get enterTitle => get('enterTitle');
  String get save => get('save');
  String get cancel => get('cancel');
  String get noNotes => get('noNotes');
  String get language => get('language');
  String get eventDetails => get('eventDetails');
  String get organizer => get('organizer');
  String get loadError => get('loadError');

  static const Map<String, Map<String, String>> _values = {
    'en': {
      'appTitle': 'CampusConnect',
      'events': 'Events',
      'upcoming': 'Upcoming',
      'myEvents': 'My Events',
      'notes': 'Notes',
      'rsvp': 'RSVP',
      'going': 'Going',
      'cancelRsvp': 'Cancel RSVP',
      'goingCount': '{n} going',
      'searchEvents': 'Search events',
      'noUpcoming': 'No upcoming events',
      'noMyEvents': 'You have not RSVPed to any event yet',
      'noSearchResults': 'No events match your search',
      'addNote': 'Add note',
      'noteTitle': 'Title',
      'noteContent': 'Write your note',
      'enterTitle': 'Enter a title',
      'save': 'Save',
      'cancel': 'Cancel',
      'noNotes': 'No notes yet',
      'language': 'Language',
      'eventDetails': 'Event details',
      'organizer': 'Organizer',
      'loadError': 'Could not load events. Please try again.',
    },
    'hi': {
      'appTitle': 'कैंपसकनेक्ट',
      'events': 'कार्यक्रम',
      'upcoming': 'आगामी',
      'myEvents': 'मेरे कार्यक्रम',
      'notes': 'नोट्स',
      'rsvp': 'शामिल हों',
      'going': 'जा रहे हैं',
      'cancelRsvp': 'RSVP रद्द करें',
      'goingCount': '{n} लोग जा रहे हैं',
      'searchEvents': 'कार्यक्रम खोजें',
      'noUpcoming': 'कोई आगामी कार्यक्रम नहीं',
      'noMyEvents': 'आपने अभी तक किसी कार्यक्रम के लिए RSVP नहीं किया',
      'noSearchResults': 'आपकी खोज से कोई कार्यक्रम नहीं मिला',
      'addNote': 'नोट जोड़ें',
      'noteTitle': 'शीर्षक',
      'noteContent': 'अपना नोट लिखें',
      'enterTitle': 'शीर्षक दर्ज करें',
      'save': 'सहेजें',
      'cancel': 'रद्द करें',
      'noNotes': 'अभी कोई नोट नहीं',
      'language': 'भाषा',
      'eventDetails': 'कार्यक्रम विवरण',
      'organizer': 'आयोजक',
      'loadError': 'कार्यक्रम लोड नहीं हो सके। कृपया पुनः प्रयास करें।',
    },
    'gu': {
      'appTitle': 'કેમ્પસકનેક્ટ',
      'events': 'કાર્યક્રમો',
      'upcoming': 'આગામી',
      'myEvents': 'મારા કાર્યક્રમો',
      'notes': 'નોંધો',
      'rsvp': 'જોડાઓ',
      'going': 'જઈ રહ્યા છે',
      'cancelRsvp': 'RSVP રદ કરો',
      'goingCount': '{n} લોકો જઈ રહ્યા છે',
      'searchEvents': 'કાર્યક્રમો શોધો',
      'noUpcoming': 'કોઈ આગામી કાર્યક્રમ નથી',
      'noMyEvents': 'તમે હજી કોઈ કાર્યક્રમ માટે RSVP કર્યું નથી',
      'noSearchResults': 'તમારી શોધ સાથે કોઈ કાર્યક્રમ મળ્યો નથી',
      'addNote': 'નોંધ ઉમેરો',
      'noteTitle': 'શીર્ષક',
      'noteContent': 'તમારી નોંધ લખો',
      'enterTitle': 'શીર્ષક દાખલ કરો',
      'save': 'સાચવો',
      'cancel': 'રદ કરો',
      'noNotes': 'હજી કોઈ નોંધ નથી',
      'language': 'ભાષા',
      'eventDetails': 'કાર્યક્રમની વિગતો',
      'organizer': 'આયોજક',
      'loadError': 'કાર્યક્રમો લોડ થઈ શક્યા નથી. ફરી પ્રયાસ કરો.',
    },
  };
}

class _AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const _AppStringsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi', 'gu'].contains(locale.languageCode);
  }

  @override
  Future<AppStrings> load(Locale locale) {
    return SynchronousFuture(AppStrings(locale));
  }

  @override
  bool shouldReload(_AppStringsDelegate old) => false;
}
