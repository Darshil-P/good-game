import 'package:flutter/material.dart';
import 'package:goodgame/widgets/drawer_widget.dart';

import '../models/game_model.dart';
import '../services/api_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Game> games = [];

  @override
  initState() {
    super.initState();
    getData();
  }

  getData() async {
    games = (await fetchGames()).games;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      drawer: const AppDrawer(),
      body: GridView.builder(
        itemCount: games.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.76,
        ),
        itemBuilder: (BuildContext context, int i) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed("/game", arguments: [games[i].id]);
            },
            child: Card(
              color: Colors.black26,
              child: SizedBox(
                height: 160,
                width: 120,
                child: Image.network(
                    "https://images.igdb.com/igdb/image/upload/t_cover_big/${games[i].cover}.png"),
              ),
            ),
          );
        },
      ),
    );
  }
}

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      drawer: const UserAppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text("User Logged In"),
            Text(
              "Welcome!",
              style: TextStyle(fontSize: 32),
            ),
          ],
        ),
      ),
    );
  }
}
