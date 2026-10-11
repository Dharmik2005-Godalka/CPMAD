class Joke {
  final int id;
  final String category;
  final String setup;
  final String punchline;

  Joke({
    required this.id,
    required this.category,
    required this.setup,
    required this.punchline,
  });

  // JSON map -> Joke object (decoding)
  // the API sends: {"error": false, "category": "...", "type": "twopart",
  //                 "setup": "...", "delivery": "...", "id": 1}
  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      id: json['id'] ?? 0,
      category: json['category'] ?? '',
      setup: json['setup'] ?? '',
      punchline: json['delivery'] ?? '',
    );
  }

  // Joke object -> JSON map (encoding)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'setup': setup,
      'delivery': punchline,
    };
  }
}
