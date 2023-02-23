import 'game_model.dart';

class Games {
  List<Game> games;

  Games({
    required this.games,
  });

  Map<String, dynamic> toMap() {
    return {
      'games': games.map((game) => game.toMap()).toList(),
    };
  }

  factory Games.fromMap(Map<String, dynamic> map) {
    return Games(
      games: List<Game>.from(map['games'].map((game) => Game.fromMap(game))),
    );
  }
}
