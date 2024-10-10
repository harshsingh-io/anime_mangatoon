class WebtoonDetail {
  final String webtoonTitle;
  final String creator;
  final String publishDate;
  final String imageLink;
  final String description;
  final List<Character> mainCharacters;
  final List<Character> minorCharacters;

  WebtoonDetail({
    required this.webtoonTitle,
    required this.creator,
    required this.publishDate,
    required this.imageLink,
    required this.description,
    required this.mainCharacters,
    required this.minorCharacters,
  });

  factory WebtoonDetail.fromJson(Map<String, dynamic> json) {
    return WebtoonDetail(
      webtoonTitle: json['webtoonTitle'] as String,
      creator: json['creator'] as String,
      publishDate: json['publishDate'] as String,
      imageLink: json['imageLink'] as String,
      description: json['description'] as String,
      mainCharacters: (json['mainCharacters'] as List<dynamic>)
          .map((item) => Character.fromJson(item as Map<String, dynamic>))
          .toList(),
      minorCharacters: (json['minorCharacters'] as List<dynamic>)
          .map((item) => Character.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Character {
  final String name;
  final String image;
  final String description;

  Character({
    required this.name,
    required this.image,
    required this.description,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      name: json['name'] as String,
      image: json['image'] as String,
      description: json['description'] as String,
    );
  }
}
