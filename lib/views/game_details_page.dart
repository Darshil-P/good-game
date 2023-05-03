import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:goodgame/services/api_services.dart';
import 'package:goodgame/services/firestore_services.dart';
import 'package:goodgame/widgets/divider_widget.dart';
import 'package:goodgame/widgets/loading_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/gamedetails_model.dart';
import '../services/auth_service.dart';
import '../widgets/videoplayer_widget.dart';

class GameDetailsPage extends StatefulWidget {
  final int gameId;

  const GameDetailsPage(this.gameId, {Key? key}) : super(key: key);

  @override
  State<GameDetailsPage> createState() => _GameDetailsPageState();
}

class _GameDetailsPageState extends State<GameDetailsPage> {
  bool _isLoading = true;
  bool _inWishlist = false;
  bool _inCollection = false;
  bool _isLiked = false;
  late String userRating;
  late GameDetails game;

  @override
  initState() {
    super.initState();
    getData(widget.gameId);
    userRating = "4.5";
  }

  getData(gameId) async {
    game = (await gameDetails(gameId));
    setState(() {
      _isLoading = false;
    });

    if (signedIn) {
      _inWishlist = await inWishlist(gameId);
      _inCollection = await inCollection(gameId);
      _isLiked = await isLiked(gameId);
      setState(() {});
    }
  }

  AlertDialog signInPopup(context) {
    return AlertDialog(
      title: const Text("SignIn Required"),
      content: const Text(
          "SignIn to Wishlist, Rate, Like & Add Games to Your Collection.\n\nDon't have an Account?\nPress the SignUp Button to Create Now!"),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () => Navigator.of(context).popAndPushNamed("/signIn"),
          child: const Text('Sign-In'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).popAndPushNamed("/signUp"),
          child: const Text('Sign-Up'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: const Loading(),
      );
    }

    DateTime rDate = DateTime.fromMillisecondsSinceEpoch(game.releaseDate! * 1000);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: ListView(
        children: [
          if (game.artworks!.isNotEmpty)
            Row(
              children: [
                Expanded(
                  child: Image.network(
                    "https://images.igdb.com/igdb/image/upload/t_original/${game.artworks![0]}.png",
                  ),
                ),
              ],
            ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 58,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text(
                                game.name,
                                style: const TextStyle(fontSize: 30),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(2),
                                    ),
                                  ),
                                  child: Text(
                                    "Released on:  ${rDate.day}-${rDate.month}-${rDate.year}",
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: RatingBarIndicator(
                                    rating: game.totalRating! / 20,
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    itemCount: 5,
                                    direction: Axis.horizontal,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  child: RichText(
                                    text: const TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Icon(Icons.share, size: 14),
                                        ),
                                        TextSpan(
                                          text: " Share  ",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    launchUrl(Uri.parse(game.url!));
                                  },
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 24),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: const BorderRadius.all(Radius.circular(2)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      "Based on ${game.totalRatingCount!.toString()} Ratings",
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 42,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: Image.network(game.coverUrl!),
                        ),
                      )
                    ],
                  ),
                ),
                const SectionDivider(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        child: SizedBox(
                          width: 96,
                          child: _inWishlist
                              ? const Column(
                                  children: [
                                    Icon(
                                      Icons.access_time_filled_rounded,
                                      size: 64,
                                    ),
                                    Text("In Wishlist"),
                                  ],
                                )
                              : const Column(
                                  children: [
                                    Icon(
                                      Icons.more_time_rounded,
                                      size: 64,
                                    ),
                                    Text("Add to Wishlist"),
                                  ],
                                ),
                        ),
                        onTap: () {
                          setState(() {
                            if (!signedIn) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => signInPopup(context),
                              );
                            } else if (_inWishlist) {
                              _inWishlist = false;
                              removeFromWishlist(game);
                            } else {
                              _inWishlist = true;
                              addToWishlist(game);
                            }
                          });
                        },
                      ),
                      GestureDetector(
                        child: SizedBox(
                          width: 96,
                          child: _isLiked
                              ? const Column(
                                  children: [
                                    Icon(
                                      Icons.favorite,
                                      size: 64,
                                    ),
                                    Text("Liked"),
                                  ],
                                )
                              : const Column(
                                  children: [
                                    Icon(
                                      Icons.favorite_border,
                                      size: 64,
                                    ),
                                    Text("Like"),
                                  ],
                                ),
                        ),
                        onTap: () {
                          setState(() {
                            if (!signedIn) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => signInPopup(context),
                              );
                            } else if (_isLiked) {
                              _isLiked = false;
                              removeFromLikes(game);
                            } else {
                              _isLiked = true;
                              addToLikes(game);
                            }
                          });
                        },
                      ),
                      GestureDetector(
                        child: SizedBox(
                          width: 96,
                          child: _inCollection
                              ? const Column(
                                  children: [
                                    Icon(
                                      Icons.check_box_rounded,
                                      size: 64,
                                    ),
                                    Text("In Collection"),
                                  ],
                                )
                              : const Column(
                                  children: [
                                    Icon(
                                      Icons.check_box_outlined,
                                      size: 64,
                                    ),
                                    Text("Mark as Played"),
                                  ],
                                ),
                        ),
                        onTap: () {
                          setState(() {
                            if (!signedIn) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => signInPopup(context),
                              );
                            } else if (_inCollection) {
                              _inCollection = false;
                              removeFromCollection(game);
                            } else {
                              _inCollection = true;
                              addToCollection(game);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SectionDivider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        "Summary: ",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      game.summary!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SectionDivider(),
                if (game.videos!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          "Videos: ",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 135,
                        child: ListView.separated(
                          itemCount: game.videos!.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int i) {
                            return SizedBox(
                              width: 240,
                              child: VideoPlayer(game.videos?[i].videoId),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(width: 12);
                          },
                        ),
                      ),
                      const SectionDivider(),
                    ],
                  ),
                if (game.screenshots!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          "Images: ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 135,
                        child: ListView.separated(
                          itemCount: game.screenshots!.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int i) {
                            return Image.network(
                                "https://images.igdb.com/igdb/image/upload/t_original/${game.screenshots![i]}.png");
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(width: 12);
                          },
                        ),
                      ),
                      const SectionDivider(),
                    ],
                  ),
                if (game.storyline != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Storyline: ",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        game.storyline!,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SectionDivider(),
                    ],
                  ),
                if (game.platforms!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          "Platforms: ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 48,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: game.platforms!.length,
                          itemBuilder: (BuildContext context, int i) {
                            return Image.network(
                                "https://images.igdb.com/igdb/image/upload/t_logo_med/${game.platforms![i].logo}.png");
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(width: 12);
                          },
                        ),
                      ),
                      const SectionDivider(),
                    ],
                  ),
                if (game.companies!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          "Companies: ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 48,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: game.companies!.length,
                          itemBuilder: (BuildContext context, int i) {
                            return Image.network(
                                "https://images.igdb.com/igdb/image/upload/t_logo_med/${game.companies![i].logo}.png");
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(width: 12);
                          },
                        ),
                      ),
                      const SectionDivider(),
                    ],
                  ),
                // Column(
                //   children: [
                //     const Padding(
                //       padding: EdgeInsets.symmetric(vertical: 10),
                //       child: Text(
                //         "Websites: ",
                //         style: TextStyle(
                //           fontSize: 20,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ),
                //     ListView(
                //       shrinkWrap: true,
                //       children: [
                //         Row(
                //           children: [
                //             for (int i = 0; i <= {game.websites}.length; i++) ...[
                //               if (game.websites![i].category != 0) ...[
                //                 GestureDetector(
                //                   child: const Text(
                //                     "Official Website",
                //                     style: TextStyle(fontSize: 20),
                //                   ),
                //                   onTap: () {
                //                     _launchInWebViewOrVC(
                //                         Uri.parse(game.websites![i].url));
                //                   },
                //                 ),
                //               ] else ...[
                //                 TextButton(
                //                   onPressed: () {
                //                     officialWeb(game.websites!);
                //                   },
                //                   child: Text("Hii"),
                //                 ),
                //               ],
                //             ]
                //           ],
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        "Similar Games: ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 160,
                      child: ListView.separated(
                        itemCount: game.similarGames!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int i) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed("/game", arguments: [game.similarGames![i].id]);
                            },
                            child: Image.network(game.similarGames![i].coverUrl),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(width: 12);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
