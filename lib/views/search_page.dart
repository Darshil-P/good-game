import 'package:flutter/material.dart';
import 'package:goodgame/widgets/loading_widget.dart';

import '../models/gamedetails_model.dart';
import '../services/api_services.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchQuery = TextEditingController();
  late Widget _searchBar = const Text(
    "Search",
    style: TextStyle(fontSize: 32),
  );
  late bool _isLoaded = true;
  late Widget _search;
  late List<GameDetails> games = [];

  @override
  void initState() {
    super.initState();
    FocusNode searchFocusNode = FocusNode();
    _search = IconButton(
      onPressed: () {
        setState(() {
          _searchBar = Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 2,
                  color: Colors.white60,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    autofocus: true,
                    focusNode: searchFocusNode,
                    textInputAction: TextInputAction.search,
                    style: const TextStyle(fontSize: 24),
                    controller: _searchQuery,
                    onSubmitted: (_) async {
                      setState(() {
                        _isLoaded = false;
                      });
                      games = (await search(_searchQuery.text));
                      setState(() {
                        _isLoaded = true;
                      });
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _searchQuery.clear();
                  },
                  icon: const Image(
                    image: AssetImage("assets/icons/cross.png"),
                    width: 24,
                  ),
                )
              ],
            ),
          );
          _search = IconButton(
              onPressed: () async {
                searchFocusNode.unfocus();
                setState(() {
                  _isLoaded = false;
                });
                games = (await search(_searchQuery.text));
                setState(() {
                  _isLoaded = true;
                });
              },
              icon: const Image(image: AssetImage("assets/icons/check.png")));
        });
      },
      icon: const Image(image: AssetImage("assets/icons/search.png")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: _searchBar),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Games"),
              Tab(text: "Users"),
              Tab(text: "Lists"),
            ],
          ),
          actions: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: _search,
            )
          ],
        ),
        body: TabBarView(
          children: [
            _isLoaded
                ? games.isEmpty
                    ? const Center(
                        child: Text(
                          "No Results Found",
                          style: TextStyle(fontSize: 24),
                        ),
                      )
                    : ListView.builder(
                        itemCount: games.length,
                        itemBuilder: (BuildContext context, int i) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed("/game", arguments: [games[i].id]);
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 30,
                                  child: Card(
                                    color: Colors.black26,
                                    child: Container(
                                      height: 152,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(games[i].coverUrl!),
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 70,
                                  child: Card(
                                    color: Colors.black26,
                                    child: SizedBox(
                                      height: 152,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(bottom: 6),
                                                child: Text(
                                                  games[i].name,
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                games[i].summary!,
                                                maxLines: 4,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  overflow: TextOverflow.ellipsis,
                                                  color: Color(0xddffffff),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                : const Loading(),
            const Column(
              children: [],
            ),
            const Column(
              children: [],
            ),
          ],
        ),
      ),
    );
  }
}
