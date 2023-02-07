import 'package:flutter/material.dart';

import '../services/search_service.dart';

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
  late Widget _search;
  late List<dynamic> results;

  @override
  void initState() {
    super.initState();
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
                    style: const TextStyle(fontSize: 24),
                    controller: _searchQuery,
                  ),
                ),
                IconButton(
                  onPressed: () {},
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
                results = await search(_searchQuery.text);
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
            Column(
              children: const [],
            ),
            Column(
              children: const [],
            ),
            Column(
              children: const [],
            )
          ],
        ),
      ),
    );
  }
}
