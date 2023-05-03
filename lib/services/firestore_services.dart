import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/follow_model.dart';
import '../models/game_model.dart';
import '../models/gamedetails_model.dart';
import '../models/user_model.dart';
import 'auth_service.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;

late dynamic _user;
late dynamic _followers;
late dynamic _followings;
late dynamic _wishlist;
late dynamic _gamesLiked;
late dynamic _gamesPlayed;
late dynamic _lists;

Future<User> getUser(String userId) async {
  return User.fromMap((await _user.get()).data());
}

Future<QuerySnapshot> getCredential(String type, String credential) async {
  return await _db.collection("credentials").where(type, isEqualTo: credential.toLowerCase()).get();
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

Future<bool> isRegistered({required String credentialType, required String value}) async {
  final credentials = await _db
      .collection("credentials")
      .where(credentialType, isEqualTo: value.toLowerCase())
      .get();

  return credentials.docs.isNotEmpty;
}

Future<void> registerUser(String username, String email, String phone, String pwHash) async {
  Map<String, dynamic> credentials = {
    "username": username.toLowerCase(),
    "email": email.toLowerCase(),
    "phone": phone,
    "password": pwHash,
    "account_creation_date": DateTime.now().millisecondsSinceEpoch,
  };

  User user = User(
    username: username,
    followings: _followings,
    followers: _followers,
    wishlist: _wishlist,
    gamesPlayed: _gamesPlayed,
    gamesLiked: _gamesLiked,
    lists: _lists,
    followingsCount: 0,
    followersCount: 0,
    wishlistCount: 0,
    gamesPlayedCount: 0,
    gamesLikedCount: 0,
    listsCount: 0,
  );

  print("Creating Documents...");
  await _db.collection("credentials").doc(userId).set(credentials);
  await _db.collection("users").doc(userId).set(user.toMap());
  await _followings.set({"users": []});
  await _followers.set({"users": []});
  await _wishlist.set({"games": []});
  await _gamesPlayed.set({"games": []});
  await _gamesLiked.set({"games": []});
  print("Documents Created...");
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

void updateReferences(userId) {
  _user = _db.collection("users").doc(userId);
  _followers = _db.collection("followers").doc(userId);
  _followings = _db.collection("followings").doc(userId);
  _wishlist = _db.collection("wishlists").doc(userId);
  _gamesLiked = _db.collection("games_liked").doc(userId);
  _gamesPlayed = _db.collection("games_played").doc(userId);
  _lists = _db.collection("lists").doc(userId);
}
