// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GameNotifier)
final gameProvider = GameNotifierProvider._();

final class GameNotifierProvider extends $NotifierProvider<GameNotifier, Game> {
  GameNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameNotifierHash();

  @$internal
  @override
  GameNotifier create() => GameNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Game value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Game>(value),
    );
  }
}

String _$gameNotifierHash() => r'9f2ae0ffe917ae24de4eb16dba8dc23b0f0fde84';

abstract class _$GameNotifier extends $Notifier<Game> {
  Game build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Game, Game>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Game, Game>,
              Game,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
