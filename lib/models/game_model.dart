import 'dart:convert';

class Game {
  int id;
  String? name;
  String cover;
  String? summary;
  double? totalRating;
  int? totalRatingCount;
  int? releaseDate;
  int? status;
  String? url;
  String? storyline;
  List? gameModes;
  List? genres;
  List? themes;
  List? screenshots;
  List? artworks;
  List? videos;
  List? websites;
  List? similarGames;
  List? platforms;
  List? companies;

  Game({
    required this.id,
    this.name,
    required this.cover,
    this.summary,
    this.totalRating,
    this.totalRatingCount,
    this.releaseDate,
    this.status,
    this.url,
    this.storyline,
    this.gameModes,
    this.genres,
    this.themes,
    this.screenshots,
    this.artworks,
    this.videos,
    this.websites,
    this.similarGames,
    this.platforms,
    this.companies,
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
      'status': status,
      'url': url,
      'storyline': storyline,
      'game_modes': gameModes,
      'genres': genres,
      'themes': themes,
      'screenshots': screenshots,
      'artworks': artworks,
      'videos': videos,
      'websites': websites,
      'similar_games': similarGames,
      'platforms': platforms,
      'companies': companies,
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
      status: map['status'] ?? -1,
      url: map['url'],
      storyline: map['storyline'] ?? 'No Storyline',
      gameModes: map['game_modes']?.map((mode) => mode['name']).toList() ?? [],
      genres: map['genres']?.map((genre) => genre['name']).toList() ?? [],
      themes: map['themes']?.map((theme) => theme['name']).toList() ?? [],
      screenshots: map['screenshots']
              ?.map((screenshot) => screenshot['image_id'])
              .toList() ??
          [],
      artworks:
          map['artworks']?.map((artwork) => artwork['image_id']).toList() ?? [],
      videos: map['videos']
              ?.map((video) => Video(video['name'], video['video_id']))
              .toList() ??
          [],
      websites: map['websites']
              ?.map((website) => Website(website['url'], website['category']))
              .toList() ??
          [],
      similarGames:
          map['similar_games']?.map((game) => Game.fromMap(game)).toList() ??
              [],
      platforms: map['platforms']
              ?.map((platform) => Platform(
                  platform['name'], platform['platform_logo']?['image_id']))
              .toList() ??
          [],
      companies: map['involved_companies']
              ?.map((involvedCompany) => Company(
                  involvedCompany['company']['name'],
                  involvedCompany['company']['logo']?['image_id']))
              .toList() ??
          [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Game.fromJson(String source) => Game.fromMap(json.decode(source));
}

class Video {
  String name;
  String videoId;
  Video(this.name, this.videoId);
}

class Website {
  String url;
  int category;
  Website(this.url, this.category);
}

class Platform {
  String name;
  String? logo;
  Platform(this.name, this.logo);
}

class Company {
  String name;
  String? logo;
  Company(this.name, this.logo);
}
