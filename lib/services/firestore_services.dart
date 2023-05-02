import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/follow_model.dart';
import '../models/game_model.dart';
import '../models/gamedetails_model.dart';
import '../models/user_model.dart';
import 'auth_service.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

late dynamic _user;
late dynamic _followers;
late dynamic _followings;
late dynamic _wishlist;
late dynamic _gamesLiked;
late dynamic _gamesPlayed;

Future<User> getUser(String userId) async {
  return User.fromMap((await _user.get()).data());
}

Future<List<Follow>> getFollowers(String userId) async {
  DocumentSnapshot<Map<String, dynamic>> follows = await _followers.get();

  return follows.data()!.values.map((follow) => Follow.fromMap(follow)).toList();
}

Future<List<Follow>> getFollowings(String userId) async {
  DocumentSnapshot<Map<String, dynamic>> follows = await _followings.get();

  return follows.data()!.values.map((follow) => Follow.fromMap(follow)).toList();
}

Future<List<Game>> getWishlist(String userId) async {
  return List<Game>.from((await _wishlist.get()).data()["games"].map((game) => Game.fromMap(game)));
}

Future<List<Game>> getGamesPlayed(String userId) async {
  return List<Game>.from(
      (await _gamesPlayed.get()).data()["games"].map((game) => Game.fromMap(game)));
}

Future<List<Game>> getGamesLiked(String userId) async {
  return List<Game>.from(
      (await _gamesLiked.get()).data()["games"].map((game) => Game.fromMap(game)));
}

Future<bool> inWishlist(gameId) async {
  return (await _wishlist.get()).data()["games"].any((game) => game["id"] == gameId);
}

Future<bool> inCollection(gameId) async {
  return (await _gamesPlayed.get()).data()["games"].any((game) => game["id"] == gameId);
}

Future<bool> isLiked(gameId) async {
  return (await _gamesLiked.get()).data()["games"].any((game) => game["id"] == gameId);
}

Future<void> addToWishlist(GameDetails gameDetails) async {
  Game game = Game(id: gameDetails.id, cover: gameDetails.cover, name: gameDetails.name);
  _wishlist.update({
    "games": FieldValue.arrayUnion([game.toMap()])
  });
  _user.update({"wishlist_count": FieldValue.increment(1)});
}

Future<void> addToCollection(GameDetails gameDetails) async {
  Game game = Game(id: gameDetails.id, cover: gameDetails.cover, name: gameDetails.name);
  _gamesPlayed.update({
    "games": FieldValue.arrayUnion([game.toMap()])
  });
  _user.update({"games_played_count": FieldValue.increment(1)});
}

Future<void> addToLikes(GameDetails gameDetails) async {
  Game game = Game(id: gameDetails.id, cover: gameDetails.cover, name: gameDetails.name);
  _gamesLiked.update({
    "games": FieldValue.arrayUnion([game.toMap()])
  });
  _user.update({"games_liked_count": FieldValue.increment(1)});
}

Future<void> removeFromWishlist(GameDetails gameDetails) async {
  _wishlist.update({
    "games": FieldValue.arrayRemove(
      (await _wishlist.get())['games'].where((game) => game["id"] == gameDetails.id).toList(),
    ),
  });
  _user.update({"wishlist_count": FieldValue.increment(-1)});
}

Future<void> removeFromCollection(GameDetails gameDetails) async {
  _gamesPlayed.update({
    "games": FieldValue.arrayRemove(
      (await _gamesPlayed.get())['games'].where((game) => game["id"] == gameDetails.id).toList(),
    ),
  });
  _user.update({"games_played_count": FieldValue.increment(-1)});
}

Future<void> removeFromLikes(GameDetails gameDetails) async {
  _gamesLiked.update({
    "games": FieldValue.arrayRemove(
      (await _gamesLiked.get())['games'].where((game) => game["id"] == gameDetails.id).toList(),
    ),
  });
  _user.update({"games_liked_count": FieldValue.increment(-1)});
}

void initUserReferences() {
  auth.authStateChanges().listen((user) {
    _user = db.collection("users").doc(user?.uid);
    _followers = db.collection("followers").doc(user?.uid);
    _followings = db.collection("followings").doc(user?.uid);
    _wishlist = db.collection("wishlists").doc(user?.uid);
    _gamesLiked = db.collection("games_liked").doc(user?.uid);
    _gamesPlayed = db.collection("games_played").doc(user?.uid);
  });
}
