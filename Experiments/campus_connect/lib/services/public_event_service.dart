import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event.dart';

class PublicEventService {
  static const String _url = 'https://jsonplaceholder.typicode.com/posts';

  static const List<String> _categories = 
  [
    'Tech',
    'Academic',
    'Cultural',
    'Sports',
    'Social',
  ];

  static const List<String> _places = 
  [
    'Main Auditorium',
    'Seminar Hall',
    'Open Air Theatre',
    'College Ground',
    'Library Lawn',
  ];

  Future<List<Event>> fetchEvents() async 
  {
    final response =
        await http.get(Uri.parse(_url)).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) 
    {
      throw Exception('Server error (${response.statusCode})');
    }

    final list = jsonDecode(response.body) as List<dynamic>;
    final now = DateTime.now();

    // Parse each JSON post into an Event
    return list.take(12).map((item) {
      final json = item as Map<String, dynamic>;
      final id = json['id'] as int;
      final userId = json['userId'] as int;
      final title = json['title'] as String;

      return Event(
        id: 'api-$id',
        title: title.isEmpty ? 'Event $id' : title[0].toUpperCase() + title.substring(1),
        description: (json['body'] as String).replaceAll('\n', ' '),
        location: _places[userId % _places.length],
        category: _categories[userId % _categories.length],
        organizer: 'Public events feed',
        dateTime: now.add(Duration(days: id, hours: userId)),
      );
    }).toList();
  }
}
