class Quote {
  final int id;
  final String text;
  final String author;

  Quote({
    required this.id,
    required this.text,
    required this.author,
  });

  // JSON map -> Quote object (decoding)
  // the API sends: {"id": 1, "quote": "...", "author": "..."}
  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'] ?? 0,
      text: json['quote'] ?? '',
      author: json['author'] ?? 'Unknown',
    );
  }

  // Quote object -> JSON map (encoding)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quote': text,
      'author': author,
    };
  }
}
