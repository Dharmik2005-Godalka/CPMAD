import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote.dart';

// our own exception, so the screen can show a clean message
class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class QuoteService {
  static const String url = 'https://dummyjson.com/quotes/random';

  // returns a Quote, or null when the response is empty
  static Future<Quote?> fetchQuote() async {
    try {
      // GET request, give up after 10 seconds
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw ApiException('Server error (code ${response.statusCode})');
      }

      // empty body -> empty state
      if (response.body.trim().isEmpty) return null;

      // JSON text -> Dart map
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) return null;

      final quote = Quote.fromJson(decoded);

      // quote with no text -> empty state
      if (quote.text.trim().isEmpty) return null;

      return quote;
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw ApiException('The request timed out. Please try again.');
    } on FormatException {
      throw ApiException('The server sent data in a wrong format.');
    } catch (_) {
      // no internet, DNS failure, etc.
      throw ApiException('Could not connect. Check your internet connection.');
    }
  }
}
