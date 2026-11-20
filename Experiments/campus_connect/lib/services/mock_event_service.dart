import '../models/event.dart';

class MockEventService 
{
  Future<List<Event>> fetchEvents({bool shouldFail = false}) async {
    await Future.delayed(const Duration(seconds: 2));

    if (shouldFail) {
      throw Exception('Network error');
    }

    final now = DateTime.now();

    return [
      Event(
        id: 'e1',
        title: 'Hackathon 2026',
        description: '24-hour coding contest with prizes.',
        location: 'Main Auditorium',
        category: 'Tech',
        organizer: 'Computer Society',
        dateTime: now.add(const Duration(days: 1, hours: 2)),
        attendees: const ['u1', 'u2', 'u3'],
      ),
      Event(
        id: 'e2',
        title: 'Guest Lecture: AI in Healthcare',
        description: 'Talk by an industry expert, followed by Q&A.',
        location: 'Seminar Hall B',
        category: 'Academic',
        organizer: 'IT Department',
        dateTime: now.add(const Duration(days: 3)),
        attendees: const ['u1'],
      ),
      Event(
        id: 'e3',
        title: 'Cultural Night',
        description: 'Music, dance and drama performances.',
        location: 'Open Air Theatre',
        category: 'Cultural',
        organizer: 'Student Council',
        dateTime: now.add(const Duration(days: 7)),
        attendees: const ['u2', 'u3', 'u4', 'u5'],
      ),
      Event(
        id: 'e4',
        title: 'Inter-College Cricket',
        description: 'Quarter-final match, come and cheer for the team.',
        location: 'College Ground',
        category: 'Sports',
        organizer: 'Sports Committee',
        dateTime: now.add(const Duration(days: 10, hours: 4)),
      ),
    ];
  }
}
