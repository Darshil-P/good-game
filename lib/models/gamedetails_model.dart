import 'dart:convert';

import 'package:goodgame/models/game_model.dart';

class GameDetails extends Game {
  int? totalRatingCount;
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

  GameDetails({
    required super.id,
    required super.cover,
    required super.name,
    super.coverUrl,
    super.summary,
    super.totalRating,
    super.releaseDate,
    this.totalRatingCount,
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

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cover': {
        "image_id": cover,
      },
      'summary': summary,
      'total_rating': totalRating,
      'total_rating_count': totalRatingCount,
      'first_release_date': releaseDate,
      'status': status,
      'url': url,
      'storyline': storyline,
      'game_modes': gameModes?.map((mode) => {"name": mode}).toList(),
      'genres': genres?.map((genre) => {"name": genre}).toList(),
      'themes': themes?.map((theme) => {"name": theme}).toList(),
      'screenshots': screenshots?.map((imageId) => {"image_id": imageId}).toList(),
      'artworks': artworks?.map((imageId) => {"image_id": imageId}).toList(),
      'videos': videos?.map((video) => {"name": video.name, "video_id": video.videoId}).toList(),
      'websites':
          websites?.map((website) => {"url": website.url, "category": website.category}).toList(),
      'similar_games': similarGames?.map((game) => game.toMap()).toList(),
      'platforms': platforms
          ?.map((platform) => {
                "name": platform.name,
                "platform_logo": {"image_id": platform.logo}
              })
          .toList(),
      'involved_companies': companies
          ?.map((company) => {
                "company": {
                  "name": company.name,
                  "logo": {"image_id": company.logo}
                }
              })
          .toList(),
    };
  }

  factory GameDetails.fromMap(Map<String, dynamic> map) {
    return GameDetails(
      id: map['id'],
      name: map['name'],
      cover: map['cover']?['image_id'] ?? 'nocover',
      coverUrl:
          "https://images.igdb.com/igdb/image/upload/t_cover_big/${map['cover']?['image_id'] ?? 'nocover'}.png",
      summary: map['summary'] ?? 'No Description',
      totalRating: map['total_rating'] ?? 0.0,
      totalRatingCount: map['total_rating_count'] ?? 0,
      releaseDate: map['first_release_date'] ?? -1,
      status: map['status'] ?? -1,
      url: map['url'],
      storyline: map['storyline'],
      gameModes: map['game_modes']?.map((mode) => mode['name']).toList() ?? [],
      genres: map['genres']?.map((genre) => genre['name']).toList() ?? [],
      themes: map['themes']?.map((theme) => theme['name']).toList() ?? [],
      screenshots: map['screenshots']?.map((screenshot) => screenshot['image_id']).toList() ?? [],
      artworks: map['artworks']?.map((artwork) => artwork['image_id']).toList() ?? [],
      videos: map['videos']?.map((video) => Video(video['name'], video['video_id'])).toList() ?? [],
      websites: map['websites']
              ?.map((website) => Website(website['url'], website['category']))
              .toList() ??
          [],
      similarGames: map['similar_games']?.map((game) => Game.fromMap(game)).toList() ?? [],
      platforms: map['platforms']
              ?.map(
                  (platform) => Platform(platform['name'], platform['platform_logo']?['image_id']))
              .toList() ??
          [],
      companies: map['involved_companies']
              ?.map((involvedCompany) => Company(involvedCompany['company']['name'],
                  involvedCompany['company']['logo']?['image_id']))
              .toList() ??
          [],
    );
  }

  factory GameDetails.fromJson(String source) => GameDetails.fromMap(json.decode(source));
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
