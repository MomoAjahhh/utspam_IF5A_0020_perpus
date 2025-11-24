class Book {
  final String id, title, genre, coverUrl, synopsis;
  final double pricePerDay;

  Book({
    required this.id,
    required this.title,
    required this.genre,
    required this.pricePerDay,
    required this.coverUrl,
    required this.synopsis,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json['id'],
        title: json['title'],
        genre: json['genre'],
        pricePerDay: json['pricePerDay'].toDouble(),
        coverUrl: json['coverUrl'],
        synopsis: json['synopsis'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'genre': genre,
        'pricePerDay': pricePerDay,
        'coverUrl': coverUrl,
        'synopsis': synopsis,
      };
}