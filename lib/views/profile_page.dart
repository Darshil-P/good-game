import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:goodgame/services/firestore_services.dart';

import '../models/user_model.dart';
import '../widgets/loading_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User user;
  bool _isLoading = true;

  Future<void> getData() async {
    user = await getUser(firebase.FirebaseAuth.instance.currentUser!.uid);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
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

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Center(
          child: Container(
            margin: const EdgeInsets.only(right: 52),
            child: const Text("Username"),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      height: 112,
                      width: 112,
                      margin: const EdgeInsets.symmetric(vertical: 24),
                      child: Image.asset("invalid"),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            user.gamesPlayedCount.toString(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text("Games"),
                        ],
                      ),
                      Container(
                        width: 1.0,
                        height: 32.0,
                        color: Colors.white,
                      ),
                      Column(
                        children: [
                          Text(
                            user.gamesLikedCount.toString(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text("Likes"),
                        ],
                      ),
                      Container(
                        width: 1.0,
                        height: 32.0,
                        color: Colors.white,
                      ),
                      Column(
                        children: [
                          Text(
                            user.listsCount.toString(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text("Lists"),
                        ],
                      ),
                      Container(
                        width: 1.0,
                        height: 32.0,
                        color: Colors.white,
                      ),
                      Column(
                        children: [
                          Text(
                            user.followingsCount.toString(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text("Following"),
                        ],
                      ),
                      Container(
                        width: 1.0,
                        height: 32.0,
                        color: Colors.white,
                      ),
                      Column(
                        children: [
                          Text(
                            user.followersCount.toString(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text("Followers"),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Favorites",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Image.network(
                        "https://images.igdb.com/igdb/image/upload/t_original/nocover.png",
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: Image.network(
                        "https://images.igdb.com/igdb/image/upload/t_original/nocover.png",
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: Image.network(
                        "https://images.igdb.com/igdb/image/upload/t_original/nocover.png",
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: Image.network(
                        "https://images.igdb.com/igdb/image/upload/t_original/nocover.png",
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Recently Added",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    itemCount: 10,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int i) {
                      return Container(
                        margin: const EdgeInsets.only(right: 12),
                        child: Image.network(
                            "https://images.igdb.com/igdb/image/upload/t_original/nocover.png"),
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Wishlist",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user.wishlistCount.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
