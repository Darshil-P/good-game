import 'dart:convert';

class Game {
  int id;
  String cover;
  String name;
  String? coverUrl;
  String? summary;
  double? totalRating;
  int? releaseDate;

  Game({
    required this.id,
    required this.cover,
    required this.name,
    this.coverUrl,
    this.summary,
    this.totalRating,
    this.releaseDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cover': {
        "image_id": cover,
      },
    };
  }

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      id: map['id'],
      name: map['name'],
      cover: map['cover']['image_id'],
      coverUrl:
          "https://images.igdb.com/igdb/image/upload/t_cover_big/${map['cover']?['image_id'] ?? 'nocover'}.png",
      summary: map['summary'] ?? 'No Description',
      totalRating: map['total_rating'] ?? 0.0,
      releaseDate: map['first_release_date'] ?? -1,
    );
  }

  String toJson() => json.encode(toMap());

  factory Game.fromJson(String source) => Game.fromMap(json.decode(source));
}
