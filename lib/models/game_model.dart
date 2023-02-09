import 'dart:convert';

class Game {
  int id;
  String? name;
  String? cover;
  String? summary;
  double? totalRating;
  int? totalRatingCount;
  int? releaseDate;

  Game({
    required this.id,
    this.name,
    this.cover,
    this.summary,
    this.totalRating,
    this.totalRatingCount,
    this.releaseDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cover': cover,
      'summary': summary,
      'total_rating': totalRating,
      'total_rating_count': totalRatingCount,
      'first_release_date': releaseDate,
    };
  }

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      id: map['id'],
      name: map['name'],
      cover: (map['cover'] ?? {'image_id': 'nocover'})["image_id"],
      summary: map['summary'] ?? 'No Description',
      totalRating: map['total_rating'] ?? 0.0,
      totalRatingCount: map['total_rating_count'] ?? 0,
      releaseDate: map['first_release_date'] ?? -1,
    );
  }

  String toJson() => json.encode(toMap());

  factory Game.fromJson(String source) => Game.fromMap(json.decode(source));
}
