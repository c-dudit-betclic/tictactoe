import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tictactoe/features/game/domain/ai/game_ai.dart';
import 'package:tictactoe/features/game/domain/model/game.dart';

part 'game_provider.g.dart';

@riverpod
final class GameNotifier extends Notifier<Game> {
  Timer? _timer;

  @override
  Game build() {
    ref.onDispose(() => _timer?.cancel());
    return Game.idle();
  }

  void restart() {
    _timer?.cancel();
    _timer = null;
    state = .idle();
  }

  void userDidTap(int index) {
    if (!state.canUserMoveAt(index)) {
      return;
    }

    state = state.playedBy(.user, index);

    if (!state.isFinished) {
      _timer = Timer(const Duration(seconds: 1), _aiDidTap);
    }
  }

  void _aiDidTap() {
    final int index = chooseAiMove(state.grid);
    state = state.playedBy(.ai, index);
  }
}
