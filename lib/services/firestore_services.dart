import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/follows_model.dart';
import '../models/games_model.dart';
import '../models/user_model.dart';

final db = FirebaseFirestore.instance;

Future<User> getUser(String userId) async {
  DocumentSnapshot<Map<String, dynamic>> user =
      await db.collection("users").doc(userId).get();

  return User.fromMap(user.data()!);
}

Future<Follows> getFollowers(String userId) async {
  DocumentSnapshot<Map<String, dynamic>> follows = await FirebaseFirestore
      .instance
      .collection("followers")
      .doc(userId)
      .get();

  if (follows.data() == null) {
    return Follows(users: []);
  }

  return Follows.fromMap(follows.data()!);
}

Future<Follows> getFollowings(String userId) async {
  DocumentSnapshot<Map<String, dynamic>> follows = await FirebaseFirestore
      .instance
      .collection("followings")
      .doc(userId)
      .get();

  if (follows.data() == null) {
    return Follows(users: []);
  }

  return Follows.fromMap(follows.data()!);
}

Future<Games> getWishlist(String userId) async {
  DocumentSnapshot<Map<String, dynamic>> games =
      await FirebaseFirestore.instance.collection("wishlist").doc(userId).get();

  if (games.data() == null) {
    return Games(games: []);
  }

  return Games.fromMap(games.data()!);
}

Future<Games> getGamesPlayed(String userId) async {
  DocumentSnapshot<Map<String, dynamic>> games = await FirebaseFirestore
      .instance
      .collection("games_playes")
      .doc(userId)
      .get();

  if (games.data() == null) {
    return Games(games: []);
  }

  return Games.fromMap(games.data()!);
}

Future<Games> getGamesLiked(String userId) async {
  DocumentSnapshot<Map<String, dynamic>> games = await FirebaseFirestore
      .instance
      .collection("games_liked")
      .doc(userId)
      .get();

  if (games.data() == null) {
    return Games(games: []);
  }

  return Games.fromMap(games.data()!);
}
