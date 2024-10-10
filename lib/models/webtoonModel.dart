class Webtoon {
  final String title;
  final String creator;
  final String genre;
  final String description;
  final String imageLink;

  Webtoon({
    required this.title,
    required this.creator,
    required this.genre,
    required this.description,
    required this.imageLink,
  });

  factory Webtoon.fromJson(Map<String, dynamic> json) {
    return Webtoon(
      title: json['title'] as String,
      creator: json['creator'] as String,
      genre: json['genre'] as String,
      description: json['description'] as String,
      imageLink: json['imageLink'] as String,
    );
  }
}
