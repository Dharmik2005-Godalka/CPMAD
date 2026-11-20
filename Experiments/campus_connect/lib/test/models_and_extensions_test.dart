import 'package:campus_connect/models/event.dart';
import 'package:campus_connect/models/note.dart';
import 'package:campus_connect/utils/extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final event = Event(
    id: 'e1',
    title: 'Hackathon',
    description: '24-hour coding contest',
    location: 'Main Hall',
    category: 'Tech',
    organizer: 'CS Club',
    dateTime: DateTime(2026, 12, 5, 17, 30),
    attendees: const ['u1', 'u2'],
  );

  group('Event', () {
    test('toJson and fromJson round trip', () {
      expect(Event.fromJson(event.toJson()), event);
    });

    test('equal events have the same hashCode', () {
      final copy = Event.fromJson(event.toJson());
      expect(copy.hashCode, event.hashCode);
    });

    test('copyWith changes only the given field', () {
      final changed = event.copyWith(title: 'New title');
      expect(changed.title, 'New title');
      expect(changed.location, event.location);
      expect(changed, isNot(event));
    });
  });

  group('Note', () {
    test('toJson and fromJson round trip', () {
      final note = Note(
        id: 'n1',
        title: 'Viva prep',
        content: 'Revise Provider',
        createdAt: DateTime(2026, 11, 1),
        updatedAt: DateTime(2026, 11, 2),
        isPinned: true,
      );
      expect(Note.fromJson(note.toJson()), note);
    });
  });

  group('Date extensions', () {
    test('formatDate and formatTime', () {
      final date = DateTime(2026, 11, 20, 17, 5);
      expect(date.formatDate(), '20 Nov 2026');
      expect(date.formatTime(), '5:05 PM');
      expect(DateTime(2026, 1, 1, 0, 0).formatTime(), '12:00 AM');
    });

    test('isSameDay ignores the time', () {
      expect(
        DateTime(2026, 11, 20, 9).isSameDay(DateTime(2026, 11, 20, 23)),
        isTrue,
      );
    });
  });

  group('Search extensions', () {
    test('matchesQuery needs every word', () {
      expect('Main Hall Hackathon'.matchesQuery('hall hack'), isTrue);
      expect('Main Hall Hackathon'.matchesQuery('hall music'), isFalse);
    });

    test('list search filters events', () {
      expect([event].search('coding').length, 1);
      expect([event].search('music'), isEmpty);
    });
  });
}
