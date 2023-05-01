import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/follow_model.dart';
import '../models/game_model.dart';
import '../models/user_model.dart';

final db = FirebaseFirestore.instance;

Future<User> getUser(String userId) async {
  DocumentSnapshot<Map<String, dynamic>> user = await db.collection("users").doc(userId).get();

  return User.fromMap(user.data()!);
}

Future<List<Follow>> getFollowers(String userId) async {
  DocumentSnapshot<Map<String, dynamic>> follows =
      await FirebaseFirestore.instance.collection("followers").doc(userId).get();

  return follows.data()!.values.map((follow) => Follow.fromMap(follow)).toList();
}

Future<List<Follow>> getFollowings(String userId) async {
  DocumentSnapshot<Map<String, dynamic>> follows =
      await FirebaseFirestore.instance.collection("followings").doc(userId).get();

  return follows.data()!.values.map((follow) => Follow.fromMap(follow)).toList();
}

Future<List<Game>> getWishlist(String userId) async {
  DocumentSnapshot<Map<String, dynamic>> games =
      await FirebaseFirestore.instance.collection("wishlists").doc(userId).get();

  return List<Game>.from(games.data()!["games"].map((game) => Game.fromMap(jsonDecode(game))));
}

Future<List<Game>> getGamesPlayed(String userId) async {
  DocumentSnapshot<Map<String, dynamic>> games =
      await FirebaseFirestore.instance.collection("games_played").doc(userId).get();

  return games.data()!.values.map((game) => Game.fromMap(game)).toList();
}

Future<List<Game>> getGamesLiked(String userId) async {
  DocumentSnapshot<Map<String, dynamic>> games =
      await FirebaseFirestore.instance.collection("games_liked").doc(userId).get();

  return games.data()!.values.map((game) => Game.fromMap(game)).toList();
}
