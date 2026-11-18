import 'package:http/http.dart' as http;

class APICall {
  static Future<Quote> fetchData() async {
    Quote quote  = null;
    var request = http.Request('GET', Uri.parse('https://dummyjson.com/quotes/random'));

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
var res = await response.stream.bytesToString();
  print(res);
    quote = Quote.fromJson(res);
}
else {
  print(response.reasonPhrase);
}
    return quote;

  }
}



