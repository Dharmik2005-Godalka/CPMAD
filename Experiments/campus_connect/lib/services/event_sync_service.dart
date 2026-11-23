import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';

// Events plus the sync state Firestore reports for them
class EventsSnapshot 
{
  final List<Event> events;
  final Set<String> pendingIds; // saved on this device, not yet on the server
  final bool fromCache; // true while offline

  const EventsSnapshot({
    required this.events,
    required this.pendingIds,
    required this.fromCache,
  });
}

class EventSyncService 
{
  // Check that this matches the collection name in your event_service.dart
  static const String collection = 'events';

  CollectionReference<Map<String, dynamic>> get _events =>
      FirebaseFirestore.instance.collection(collection);

  // Real-time stream, including metadata changes (pending)
  Stream<EventsSnapshot> watchEvents() 
  {
    return _events.snapshots(includeMetadataChanges: true).map((snapshot) 
    {
      final events = <Event>[];
      final pending = <String>{};

      for (final doc in snapshot.docs) 
      {
        events.add(Event.fromMap(doc.id, doc.data()));
        if (doc.metadata.hasPendingWrites) pending.add(doc.id);
      }

      return EventsSnapshot(
        events: events,
        pendingIds: pending,
        fromCache: snapshot.metadata.isFromCache,
      );
    });
  }

  // The id is created on the device, so a retry can never make a duplicate
  String newEventId() => _events.doc().id;

  Future<void> createEvent(String id, Event event) 
  {
    return _events.doc(id).set(event.toMap());
  }

  // arrayUnion / arrayRemove: two people RSVPing at once never overwrite each other
  Future<void> setRsvp(String eventId, String userId, bool going) 
  {
    return _events.doc(eventId).update(
      {
      'attendees': going
          ? FieldValue.arrayUnion([userId])
          : FieldValue.arrayRemove([userId]),
    });
  }
}
