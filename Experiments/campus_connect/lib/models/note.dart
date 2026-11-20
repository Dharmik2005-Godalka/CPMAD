import 'dart:convert';

class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPinned;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.isPinned = false,
  });

  Note copyWith({
    String? title,
    String? content,
    DateTime? updatedAt,
    bool? isPinned,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  factory Note.fromMap(String id, Map<String, dynamic> map) 
  {
    return Note(
      id: id,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch
      (
        (map['createdAt'] as num?)?.toInt() ?? 0,
      ),

      updatedAt: DateTime.fromMillisecondsSinceEpoch
      (
        (map['updatedAt'] as num?)?.toInt() ?? 0,
      ),
      
      isPinned: map['isPinned'] ?? false,
    );
  }

  Map<String, dynamic> toMap() 
  {
    return {
      'title': title,
      'content': content,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'isPinned': isPinned,
    };
  }

  String toJson() => jsonEncode({'id': id, ...toMap()});

  factory Note.fromJson(String source) {
    final map = jsonDecode(source) as Map<String, dynamic>;
    return Note.fromMap(map['id'] ?? '', map);
  }

  @override
  bool operator ==(Object other) 
  {
    return identical(this, other) ||
        other is Note &&
            other.id == id &&
            other.title == title &&
            other.content == content &&
            other.createdAt == createdAt &&
            other.updatedAt == updatedAt &&
            other.isPinned == isPinned;
  }

  @override
  int get hashCode =>
      Object.hash(id, title, content, createdAt, updatedAt, isPinned);

  @override
  String toString() => 'Note(id: $id, title: $title, pinned: $isPinned)';
}
