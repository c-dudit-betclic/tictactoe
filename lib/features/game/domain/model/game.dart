import 'package:freezed_annotation/freezed_annotation.dart';

part 'game.freezed.dart';

@freezed
abstract class Game with _$Game {
  const factory Game({
    required GameStatus status,
    required List<Player?> grid,
  }) = _Game;

  const Game._();

  factory Game.idle() => Game(status: .userPlaying, grid: .filled(9, null));

  /// Every index triplet that wins the game: rows, then columns, then diagonals.
  static const List<List<int>> winningLines = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
    [0, 3, 6], [1, 4, 7], [2, 5, 8], // columns
    [0, 4, 8], [2, 4, 6], // diagonals
  ];

  Game playedBy(Player player, int index) {
    final playedGame = copyWith(grid: [...grid]..[index] = player);
    return playedGame.copyWith(status: playedGame._statusAfterMoveBy(player));
  }

  bool canUserMoveAt(int index) => grid[index] == null && status == .userPlaying;

  bool get isFinished => status == .draw || status == .aiWon || status == .userWon;

  GameStatus _statusAfterMoveBy(Player justPlayed) => switch (_winner) {
    Player.user => GameStatus.userWon,
    Player.ai => GameStatus.aiWon,
    _ when !grid.contains(null) => GameStatus.draw,
    _ => justPlayed == Player.user ? GameStatus.aiPlaying : GameStatus.userPlaying,
  };

  Player? get _winner {
    for (final [a, b, c] in winningLines) {
      final mark = grid[a];
      if (mark != null && mark == grid[b] && mark == grid[c]) return mark;
    }
    return null;
  }
}

enum Player {
  user,
  ai,
}

enum GameStatus {
  userPlaying,
  aiPlaying,
  draw,
  userWon,
  aiWon,
}
