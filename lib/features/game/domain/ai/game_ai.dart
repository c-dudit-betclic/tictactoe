import 'dart:math';

import 'package:tictactoe/features/game/domain/model/game.dart';

const List<int> _center = [4];
const List<int> _corners = [0, 2, 6, 8];
const List<int> _sides = [1, 3, 5, 7];

/// Square preference when the AI plays well: the center belongs to four
/// winning lines, a corner to three, a side to only two.
const List<List<int>> _sharpOrder = [_center, _corners, _sides];

/// The same preference upside down. Every square here is still a legal, normal
/// looking move, it is just the weakest one available.
const List<List<int>> _sloppyOrder = [_sides, _corners, _center];

/// How often [chooseAiMove] settles for a weak square instead of the best one.
const double defaultMistakeChance = 0.35;

/// Picks the index the AI should play on [grid].
///
/// Tactics come first and are never skipped: the AI always completes a winning
/// line, and always blocks the user's. Missing either of those reads as a
/// broken opponent rather than a beatable one.
///
/// Difficulty lives in the *positional* choice that follows. With probability
/// [mistakeChance] the AI ranks the remaining squares worst-first instead of
/// best-first, which mostly means giving up the center. That is what lets a
/// user build a fork - two threats at once, only one of which can be blocked.
///
/// Set [mistakeChance] to `0` for the strongest play, `1` for the weakest.
/// Pass [random] to make the choice deterministic in tests.
int chooseAiMove(List<Player?> grid, {Random? random, double mistakeChance = defaultMistakeChance}) {
  final Random rng = random ?? Random();

  int? move = _completingIndex(grid, Player.ai) ?? _completingIndex(grid, Player.user);

  for (final List<int> tier in rng.nextDouble() < mistakeChance ? _sloppyOrder : _sharpOrder) {
    move ??= _freeIndexAmong(grid, tier, rng);
  }

  if (move == null) {
    throw ArgumentError.value(grid, 'grid', 'has no free cell left to play');
  }

  return move;
}

/// The free index of a line where [player] already owns the two other cells,
/// or `null` when [player] has no such line.
int? _completingIndex(List<Player?> grid, Player player) {
  for (final List<int> line in Game.winningLines) {
    if (line.where((index) => grid[index] == player).length != 2) continue;

    final Iterable<int> free = line.where((index) => grid[index] == null);
    if (free.length == 1) return free.first;
  }

  return null;
}

/// A random free index among [candidates], or `null` when they are all taken.
int? _freeIndexAmong(List<Player?> grid, List<int> candidates, Random random) {
  final List<int> free = candidates.where((index) => grid[index] == null).toList()..shuffle(random);

  return free.isEmpty ? null : free.first;
}
