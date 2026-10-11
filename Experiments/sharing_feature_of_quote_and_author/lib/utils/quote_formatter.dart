import '../models/quote.dart';

// turns a Quote into a readable message for sharing or copying
String formatQuoteMessage(Quote quote) {
  return '"${quote.text}"\n'
      '\n'
      '- ${quote.author}\n'
      '\n'
      'Shared from Quote App';
}
