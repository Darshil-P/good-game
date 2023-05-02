import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String username;
  DocumentReference followings;
  DocumentReference followers;
  DocumentReference wishlist;
  DocumentReference gamesPlayed;
  DocumentReference gamesLiked;
  DocumentReference lists;
  int followingsCount;
  int followersCount;
  int wishlistCount;
  int gamesPlayedCount;
  int gamesLikedCount;
  int listsCount;

  User({
    required this.username,
    required this.followings,
    required this.followers,
    required this.wishlist,
    required this.gamesPlayed,
    required this.gamesLiked,
    required this.lists,
    required this.followingsCount,
    required this.followersCount,
    required this.wishlistCount,
    required this.gamesPlayedCount,
    required this.gamesLikedCount,
    required this.listsCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'followings': followings,
      'followers': followers,
      'wishlist': wishlist,
      'games_played': gamesPlayed,
      'games_liked': gamesLiked,
      'lists': lists,
      'followings_count': followingsCount,
      'followers_count': followersCount,
      'wishlist_count': wishlistCount,
      'games_played_count': gamesPlayedCount,
      'games_liked_count': gamesLikedCount,
      'lists_count': listsCount,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'],
      followings: map['followings'],
      followers: map['followers'],
      wishlist: map['wishlist'],
      gamesPlayed: map['games_played'],
      gamesLiked: map['games_liked'],
      lists: map['lists'],
      followingsCount: map['followings_count'],
      followersCount: map['followers_count'],
      wishlistCount: map['wishlist_count'],
      gamesPlayedCount: map['games_played_count'],
      gamesLikedCount: map['games_liked_count'],
      listsCount: map['lists_count'],
    );
  }
}
