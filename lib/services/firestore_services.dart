import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

import '../models/follow_model.dart';
import '../models/game_model.dart';
import '../models/gamedetails_model.dart';
import '../models/user_model.dart';

final db = FirebaseFirestore.instance;
final firebase.User currentUser = firebase.FirebaseAuth.instance.currentUser!;
final profile = db.collection("users").doc(currentUser.uid);
final wishlist = FirebaseFirestore.instance.collection("wishlists").doc(currentUser.uid);
final gamesLiked = FirebaseFirestore.instance.collection("games_liked").doc(currentUser.uid);
final gamesPlayed = FirebaseFirestore.instance.collection("games_played").doc(currentUser.uid);

Future<User> getUser(String userId) async {
  return User.fromMap((await profile.get()).data()!);
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
  return List<Game>.from((await wishlist.get()).data()!["games"].map((game) => Game.fromMap(game)));
}

Future<List<Game>> getGamesPlayed(String userId) async {
  return List<Game>.from(
      (await gamesPlayed.get()).data()!["games"].map((game) => Game.fromMap(game)));
}

Future<List<Game>> getGamesLiked(String userId) async {
  return List<Game>.from(
      (await gamesLiked.get()).data()!["games"].map((game) => Game.fromMap(game)));
}

Future<bool> inWishlist(gameId) async {
  return (await wishlist.get()).data()!["games"].any((game) => game["id"] == gameId);
}

Future<bool> inCollection(gameId) async {
  return (await gamesPlayed.get()).data()!["games"].any((game) => game["id"] == gameId);
}

Future<bool> isLiked(gameId) async {
  return (await gamesLiked.get()).data()!["games"].any((game) => game["id"] == gameId);
}

Future<void> addToWishlist(GameDetails gameDetails) async {
  Game game = Game(id: gameDetails.id, cover: gameDetails.cover, name: gameDetails.name);
  wishlist.update({
    "games": FieldValue.arrayUnion([game.toMap()])
  });
  profile.update({"wishlist_count": FieldValue.increment(1)});
}

Future<void> addToCollection(GameDetails gameDetails) async {
  Game game = Game(id: gameDetails.id, cover: gameDetails.cover, name: gameDetails.name);
  gamesPlayed.update({
    "games": FieldValue.arrayUnion([game.toMap()])
  });
  profile.update({"games_played_count": FieldValue.increment(1)});
}

Future<void> addToLikes(GameDetails gameDetails) async {
  Game game = Game(id: gameDetails.id, cover: gameDetails.cover, name: gameDetails.name);
  gamesLiked.update({
    "games": FieldValue.arrayUnion([game.toMap()])
  });
  profile.update({"games_liked_count": FieldValue.increment(1)});
}

Future<void> removeFromWishlist(GameDetails gameDetails) async {
  wishlist.update({
    "games": FieldValue.arrayRemove(
      (await wishlist.get())['games'].where((game) => game["id"] == gameDetails.id).toList(),
    ),
  });
  profile.update({"wishlist_count": FieldValue.increment(-1)});
}

Future<void> removeFromCollection(GameDetails gameDetails) async {
  gamesPlayed.update({
    "games": FieldValue.arrayRemove(
      (await gamesPlayed.get())['games'].where((game) => game["id"] == gameDetails.id).toList(),
    ),
  });
  profile.update({"games_played_count": FieldValue.increment(-1)});
}

Future<void> removeFromLikes(GameDetails gameDetails) async {
  gamesLiked.update({
    "games": FieldValue.arrayRemove(
      (await gamesLiked.get())['games'].where((game) => game["id"] == gameDetails.id).toList(),
    ),
  });
  profile.update({"games_liked_count": FieldValue.increment(-1)});
}
