import 'dart:convert';
import 'package:flutter/foundation.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final String location;
  final String category;
  final String organizer;
  final DateTime dateTime;
  final List<String> attendees; 
  final String? image; 

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.category,
    required this.organizer,
    required this.dateTime,
    this.attendees = const [],
    this.image,
  });

  int get rsvpCount => attendees.length;
  bool get isUpcoming => dateTime.isAfter(DateTime.now());
  bool isAttending(String userId) => attendees.contains(userId);

  Event copyWith({
    String? title,
    String? description,
    String? location,
    String? category,
    String? organizer,
    DateTime? dateTime,
    List<String>? attendees,
    String? image,
  }) {
    return Event(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      category: category ?? this.category,
      organizer: organizer ?? this.organizer,
      dateTime: dateTime ?? this.dateTime,
      attendees: attendees ?? this.attendees,
      image: image ?? this.image,
    );
  }

  //serialization 
  factory Event.fromMap(String id, Map<String, dynamic> map) {
    return Event(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      category: map['category'] ?? '',
      organizer: map['organizer'] ?? '',
      dateTime: DateTime.fromMillisecondsSinceEpoch
      (
        (map['dateTime'] as num?)?.toInt() ?? 0,
      ),
      attendees: List<String>.from(map['attendees'] ?? const []),
      image: map['image'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'category': category,
      'organizer': organizer,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'attendees': attendees,
      'image': image,
    };
  }

  String toJson() => jsonEncode({'id': id, ...toMap()});

  factory Event.fromJson(String source) {
    final map = jsonDecode(source) as Map<String, dynamic>;
    return Event.fromMap(map['id'] ?? '', map);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Event &&
            other.id == id &&
            other.title == title &&
            other.description == description &&
            other.location == location &&
            other.category == category &&
            other.organizer == organizer &&
            other.dateTime == dateTime &&
            listEquals(other.attendees, attendees) &&
            other.image == image;
  }

  @override
  int get hashCode => Object.hash(
        id,
        title,
        description,
        location,
        category,
        organizer,
        dateTime,
        Object.hashAll(attendees),
        image,
      );

  @override
  String toString() => 'Event(id: $id, title: $title, dateTime: $dateTime)';
}
