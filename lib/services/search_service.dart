import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/game_model.dart';
import 'api_credentials.dart';

Future<List> search(String query) async {
  http.Response response = await http.post(
    Uri.parse('https://api.igdb.com/v4/games'),
    headers: <String, String>{
      'Client-ID': IGDB_ClientID,
      'Authorization': 'Bearer $IGDB_AccessToken',
      'Accept': 'application/json',
    },
    body:
        'fields name, cover.image_id, summary, total_rating, total_rating_count, first_release_date; search "$query"; where category = 0;',
  );

  late List data;

  if (response.statusCode == 200) {
    data = jsonDecode(response.body) as List;
  } else if (response.statusCode == 401) {
    getAccessToken();
  }

  for (int i = 0; i < data.length; i++) {
    data[i] = Game.fromMap(data[i]);
  }
  return data;
}

Future<void> getAccessToken() async {
  var data = await http.post(
    Uri.parse(
        'https://id.twitch.tv/oauth2/token?client_id=$IGDB_ClientID&client_secret=$IGDB_ClientSecret&grant_type=client_credentials'),
  );
  print(
      "Update your access token in services/api_credentials.dart\nAccess Token: \"${jsonDecode(data.body)["access_token"]}\"");
}
