import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:goodgame/services/api_services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/game_model.dart';

class GameDetailsPage extends StatefulWidget {
  final int gameId;
  const GameDetailsPage(this.gameId, {Key? key}) : super(key: key);

  @override
  State<GameDetailsPage> createState() => _GameDetailsPageState();
}

class _GameDetailsPageState extends State<GameDetailsPage> {
  var gameDetailsPage = ListView(children: [
    Column(
      children: const [
        SizedBox(
          height: 280,
        ),
        Center(
          child: SizedBox(
            height: 150,
            width: 150,
            child: CircularProgressIndicator(),
          ),
        )
      ],
    )
  ]);

  @override
  initState() {
    super.initState();
    getData(widget.gameId);
  }

  getData(gameId) async {
    Game game = (await gameDetails(gameId))[0];
    gameDetailsPage = createGameDetails(game);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0x00000000),
        elevation: 0,
      ),
      body: gameDetailsPage,
    );
  }
}

ListView createGameDetails(Game game) {
  var rDate = DateTime.fromMillisecondsSinceEpoch(game.releaseDate! * 1000);

  return ListView(
    children: [
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 200,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text(
                          game.name!,
                          style: const TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                          ),
                          child: Text(
                            "Released on:  ${rDate.day}-${rDate.month}-${rDate.year}",
                            style: const TextStyle(fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(2)),
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
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: SizedBox(
                        height: 200,
                        width: 150,
                        child: Image.network(game.cover),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "Summary: ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              game.summary!,
              style: const TextStyle(fontSize: 16),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                // const Padding(
                //   padding: EdgeInsets.symmetric(vertical: 10),
                //   child: Text(
                //     "Videos: ",
                //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                //   ),
                // ),
                // SizedBox(
                //   height: 220,
                //   child: ListView.builder(
                //     itemCount: game.videos!.length,
                //     scrollDirection: Axis.horizontal,
                //     itemBuilder: (BuildContext context, int i) {
                //       return Padding(
                //         padding: const EdgeInsets.only(right: 4.0),
                //         child: YoutubePlayer(
                //           showVideoProgressIndicator: true,
                //           progressColors: ProgressBarColors(
                //             playedColor: Colors.amber,
                //             handleColor: Colors.amber.shade500,
                //           ),
                //           controller: YoutubePlayerController(
                //             initialVideoId:
                //                 "https://youtu.be/${game.videos![i].toString()}",
                //             flags: const YoutubePlayerFlags(
                //               autoPlay: false,
                //               mute: false,
                //               disableDragSeek: true,
                //             ),
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Images: ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 170,
                  child: ListView.builder(
                    itemCount: game.screenshots!.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int i) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Card(
                          color: Colors.black26,
                          child: Container(
                            height: 120,
                            width: 180,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    "https://images.igdb.com/igdb/image/upload/t_original/${game.screenshots![i]}.png"),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
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
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
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
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: game.platforms!.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: SizedBox(
                          height: 48,
                          child: Image.network(
                              "https://images.igdb.com/igdb/image/upload/t_logo_med/${game.platforms![i].logo}.png"),
                        ),
                      );
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
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
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: game.companies!.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: SizedBox(
                          height: 48,
                          child: Image.network(
                              "https://images.igdb.com/igdb/image/upload/t_logo_med/${game.companies![i].logo}.png"),
                        ),
                      );
                    },
                  ),
                ),
                // const Padding(
                //   padding: EdgeInsets.symmetric(vertical: 10),
                //   child: Text(
                //     "Websites: ",
                //     style: TextStyle(
                //       fontSize: 20,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                // ListView(
                //   shrinkWrap: true,
                //   children: [
                //     Row(
                //       children: [
                //         for (int i = 0; i <= {game.websites}.length; i++) ...[
                //           if (game.websites![i].category != 0) ...[
                //             GestureDetector(
                //               child: const Text(
                //                 "Official Website",
                //                 style: TextStyle(fontSize: 20),
                //               ),
                //               onTap: () {
                //                 _launchInWebViewOrVC(
                //                     Uri.parse(game.websites![i].url));
                //               },
                //             ),
                //           ] else ...[
                //             TextButton(
                //               onPressed: () {
                //                 officialWeb(game.websites!);
                //               },
                //               child: Text("Hii"),
                //             ),
                //           ],
                //         ]
                //       ],
                //     ),
                //   ],
                // ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Similar Games: ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 156,
                  child: ListView.builder(
                    itemCount: game.similarGames!.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int i) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed("/game",
                                arguments: [game.similarGames![i].id]);
                          },
                          child: Card(
                            color: Colors.black26,
                            child: Container(
                              width: 112,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      NetworkImage(game.similarGames![i].cover),
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
