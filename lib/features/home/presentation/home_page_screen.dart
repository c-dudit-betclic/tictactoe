import 'package:flutter/material.dart';
import 'package:tictactoe/features/game/presentation/game_page_screen.dart';

final class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  Future<void> _didTapPlay(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute<Object>(builder: (_) => const GamePageScreen()));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      padding: const .symmetric(vertical: 16, horizontal: 20),
      child: Stack(
        alignment: .center,
        children: [
          const _BackgroundGrid(),
          const _LargeTitle(),
          _PlayButton(didTapPlay: () => _didTapPlay(context)),
        ],
      ),
    ),
  );
}

final class _BackgroundGrid extends StatelessWidget {
  const _BackgroundGrid();

  @override
  Widget build(BuildContext context) {
    final boxDecoration = BoxDecoration(borderRadius: .circular(8), color: Colors.grey[300]);

    return AspectRatio(
      aspectRatio: 0.8,
      child: Stack(
        children: [
          Row(
            children: [
              const Spacer(),
              Container(width: 3, decoration: boxDecoration),
              const Spacer(),
              Container(width: 3, decoration: boxDecoration),
              const Spacer(),
            ],
          ),
          Column(
            children: [
              const Spacer(),
              Container(height: 3, decoration: boxDecoration),
              const Spacer(),
              Container(height: 3, decoration: boxDecoration),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}

final class _LargeTitle extends StatelessWidget {
  const _LargeTitle();

  @override
  Widget build(BuildContext context) => SizedBox(
    width: .infinity,
    child: Column(
      crossAxisAlignment: .start,
      mainAxisSize: .max,
      children: [
        const Spacer(),
        const _LargeTitleLine(text: 'TIC'),
        const _LargeTitleLine(text: 'TAC'),
        _LargeTitleLine(text: 'TOE', color: Theme.of(context).colorScheme.primary),
        Text(
          'You against the machine.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const Spacer(),
      ],
    ),
  );
}

final class _LargeTitleLine extends StatelessWidget {
  const _LargeTitleLine({required this.text, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: Theme.of(context).textTheme.displayLarge?.copyWith(color: color),
  );
}

final class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.didTapPlay});

  final void Function() didTapPlay;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: .max,
    mainAxisAlignment: .end,
    children: [
      SizedBox(
        width: .infinity,
        child: ElevatedButton(
          onPressed: didTapPlay,
          child: Text(
            'Play',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: .w700,
            ),
          ),
        ),
      ),
      const SizedBox(height: 20),
    ],
  );
}
