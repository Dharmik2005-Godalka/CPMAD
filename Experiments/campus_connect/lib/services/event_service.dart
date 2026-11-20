import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';

class EventService 
{
  CollectionReference<Map<String, dynamic>> get _events =>
      FirebaseFirestore.instance.collection('events');

  Stream<List<Event>> getEvents() 
  {
    return _events.orderBy('dateTime').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Event.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> addEvent(Event event) async 
  {
    await _events.add(event.toMap());
  }

  Future<void> setRsvp(String eventId, String userId, bool going) async 
  {
    await _events.doc(eventId).update({
      'attendees': going
          ? FieldValue.arrayUnion([userId])
          : FieldValue.arrayRemove([userId]),
    });
  }
}
