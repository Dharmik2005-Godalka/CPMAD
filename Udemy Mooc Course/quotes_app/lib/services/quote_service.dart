import 'package:http/http.dart' as http;
import 'package:quotes_app/models/quote_model.dart';

class QuoteService 
{
  static Future<List<Quotes>> fetchQuote() async 
  {
    List<Quotes> quotes = [];
    var request = http.Request
    (
      'GET',
      Uri.parse('https://zenquotes.io/api/random'),
    );

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) 
    {
      var resp = await response.stream.bytesToString();
      quotes = quotesFromJson(resp);
    } 
    else 
    {
      print(response.reasonPhrase);
    }

    return quotes;
  }
}
