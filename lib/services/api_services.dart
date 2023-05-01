import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../models/game_model.dart';
import '../models/gamedetails_model.dart';
import 'api_credentials.dart';

Future<Response> fetch(String endpoint, String query) async {
  Response response = await post(
    Uri.parse('https://api.igdb.com/v4/$endpoint'),
    headers: <String, String>{
      'Client-ID': IGDB_ClientID,
      'Authorization': 'Bearer $IGDB_AccessToken',
      'Accept': 'application/json',
    },
    body: query,
  );

  if (response.statusCode == 401) {
    getAccessToken();
  }

  return response;
}

Future<List<GameDetails>> search(String query) async {
  Response response = await fetch("games",
      'fields name, cover.image_id, summary, total_rating, total_rating_count, first_release_date; search "$query"; where category = 0;');

  return List<GameDetails>.from(
    jsonDecode(response.body).map(
      (game) => GameDetails.fromMap(game),
    ),
  );
}

Future<List<Game>> fetchGames() async {
  Response response = await fetch("games",
      'fields name, cover.image_id; sort total_rating desc; where category = 0 & total_rating > 0 & total_rating_count >= 100; limit 24;');

  return List<Game>.from(
    jsonDecode(response.body).map(
      (game) => Game.fromMap(game),
    ),
  );
}

Future<GameDetails> gameDetails(int id) async {
  Response response = await fetch("games",
      'fields artworks.image_id, genres.name, involved_companies.company.name, involved_companies.company.logo.image_id, platforms.name, platforms.platform_logo.image_id, screenshots.image_id, similar_games.name, similar_games.cover.image_id, cover.image_id, first_release_date, name, summary, total_rating, total_rating_count, status, storyline, themes.name, url, websites.url, websites.category, game_modes.name, videos.video_id, videos.name; where id = $id;');

  return GameDetails.fromMap(jsonDecode(response.body)[0]);
}

Future<void> getAccessToken() async {
  var data = await post(
    Uri.parse(
        'https://id.twitch.tv/oauth2/token?client_id=$IGDB_ClientID&client_secret=$IGDB_ClientSecret&grant_type=client_credentials'),
  );
  debugPrint(
      "Update your access token in services/api_credentials.dart\nAccess Token: \"${jsonDecode(data.body)["access_token"]}\"");
}
