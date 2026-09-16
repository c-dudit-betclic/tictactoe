import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe/features/game/domain/model/game.dart';
import 'package:tictactoe/features/game/presentation/game_provider.dart';

final class GamePageScreen extends ConsumerWidget {
  const GamePageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(gameProvider.select((game) => game.status), (previous, next) async {
      final message = switch (next) {
        GameStatus.userWon => 'You win!',
        GameStatus.aiWon => 'AI wins...',
        GameStatus.draw => 'Draw.',
        _ => null,
      };

      if (message == null) return;
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                ref.read(gameProvider.notifier).restart();
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Another one'),
            ),
          ],
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(),
      body: const Padding(
        padding: .symmetric(vertical: 16, horizontal: 20),
        child: Column(
          mainAxisSize: .max,
          children: [
            _TopView(),
            Spacer(),
            _GameGrid(),
            SizedBox(height: 10),
            _BottomText(),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

final class _TopView extends ConsumerWidget {
  const _TopView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GameStatus status = ref.watch(gameProvider.select((game) => game.status));

    return Row(
      mainAxisSize: .max,
      spacing: 20,
      children: [
        _TopTile(player: .user, isPlaying: status == .userPlaying),
        _TopTile(player: .ai, isPlaying: status == .aiPlaying),
      ],
    );
  }
}

final class _TopTile extends StatelessWidget {
  const _TopTile({required this.player, required this.isPlaying});

  final Player player;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const .symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isPlaying ? Colors.black : Colors.white,
        borderRadius: const .all(.circular(20)),
      ),
      height: 80,
      child: Row(
        spacing: 6,
        children: [
          if (player == .ai) const _AiCircle(size: 20) else const _PlayerCross(size: 30),
          Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .start,
            mainAxisSize: .max,
            children: [
              Text(
                player == .ai ? 'AI' : 'You',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: .w800,
                  height: 1,
                  color: isPlaying ? Colors.white : Colors.black,
                ),
              ),
              Text(
                isPlaying ? 'Thinking' : 'Waiting',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

final class _GameGrid extends ConsumerWidget {
  const _GameGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grid = ref.watch(gameProvider.select((game) => game.grid));
    return Expanded(
      flex: 3,
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: grid.indexed.map((cell) => _CellView(index: cell.$1, player: cell.$2)).toList(),
      ),
    );
  }
}

final class _CellView extends ConsumerWidget {
  const _CellView({required this.index, required this.player});

  final int index;
  final Player? player;

  @override
  Widget build(BuildContext context, WidgetRef ref) => AspectRatio(
    aspectRatio: 1,
    child: GestureDetector(
      onTap: () => ref.read(gameProvider.notifier).userDidTap(index),
      child: Container(
        decoration: BoxDecoration(borderRadius: .circular(20), color: Colors.white),
        child: AnimatedSwitcher(
          switchInCurve: Curves.easeOutBack,
          transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
          duration: const Duration(milliseconds: 300),
          child: player == null ? null : (player == .ai ? const _AiCircle() : const _PlayerCross()),
        ),
      ),
    ),
  );
}

final class _AiCircle extends StatelessWidget {
  const _AiCircle({this.size = 60});

  final double size;

  @override
  Widget build(BuildContext context) => Icon(
    Icons.circle_outlined,
    size: size,
    color: Colors.black,
    fontWeight: .w900,
  );
}

final class _PlayerCross extends StatelessWidget {
  const _PlayerCross({this.size = 74});

  final double size;

  @override
  Widget build(BuildContext context) => Icon(
    Icons.close_rounded,
    size: size,
    color: Theme.of(context).colorScheme.primary,
    fontWeight: .w900,
  );
}

final class _BottomText extends ConsumerWidget {
  const _BottomText();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notStarted = ref.watch(gameProvider.select((game) => game.grid.every((cell) => cell == null)));

    return Text(
      notStarted ? 'Tap any square to start' : '',
      style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.grey),
    );
  }
}
