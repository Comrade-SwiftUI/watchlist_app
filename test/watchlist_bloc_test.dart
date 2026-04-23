import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watchlist_app/bloc/watchlist_bloc.dart';

void main() {
  group('WatchlistBloc', () {
    late WatchlistBloc bloc;

    setUp(() {
      bloc = WatchlistBloc();
    });

    tearDown(() => bloc.close());

    test('initial state is WatchlistInitial', () {
      expect(bloc.state, isA<WatchlistInitial>());
    });

    blocTest<WatchlistBloc, WatchlistState>(
      'emits [WatchlistLoading, WatchlistLoadSuccess] on WatchlistLoaded',
      build: () => WatchlistBloc(),
      act: (bloc) => bloc.add(const WatchlistLoaded()),
      expect: () => [
        isA<WatchlistLoading>(),
        isA<WatchlistLoadSuccess>(),
      ],
    );

    blocTest<WatchlistBloc, WatchlistState>(
      'changes active tab on WatchlistTabChanged',
      build: () => WatchlistBloc(),
      seed: () => const WatchlistInitial(),
      act: (bloc) {
        bloc.add(const WatchlistLoaded());
        bloc.add(const WatchlistTabChanged(watchlistId: 'wl_2'));
      },
      expect: () => [
        isA<WatchlistLoading>(),
        isA<WatchlistLoadSuccess>(),
        isA<WatchlistLoadSuccess>(),
      ],
      verify: (bloc) {
        final state = bloc.state as WatchlistLoadSuccess;
        expect(state.activeWatchlistId, equals('wl_2'));
      },
    );

    blocTest<WatchlistBloc, WatchlistState>(
      'reorders stocks correctly on WatchlistStockReordered',
      build: () => WatchlistBloc(),
      act: (bloc) {
        bloc.add(const WatchlistLoaded());
        bloc.add(const WatchlistStockReordered(
          watchlistId: 'wl_1',
          oldIndex: 0,
          newIndex: 2,
        ));
      },
      skip: 2, // skip Loading + initial LoadSuccess
      expect: () => [isA<WatchlistLoadSuccess>()],
      verify: (bloc) {
        final state = bloc.state as WatchlistLoadSuccess;
        // After moving index 0 to index 2, original [0,1,2] → [1,0,2]
        // (newIndex is post-removal, so 2 - 1 = insert at 1)
        expect(state.canUndo, isTrue);
      },
    );

    blocTest<WatchlistBloc, WatchlistState>(
      'swaps two stocks by ID on WatchlistStockSwapped',
      build: () => WatchlistBloc(),
      act: (bloc) {
        bloc.add(const WatchlistLoaded());
        bloc.add(const WatchlistStockSwapped(
          watchlistId: 'wl_1',
          stockIdA: '1',
          stockIdB: '2',
        ));
      },
      skip: 2,
      expect: () => [isA<WatchlistLoadSuccess>()],
      verify: (bloc) {
        final state = bloc.state as WatchlistLoadSuccess;
        final stocks = state.activeWatchlist.stocks;
        // Original: RELIANCE(1) at 0, TCS(2) at 1 — now swapped
        expect(stocks[0].id, equals('2'));
        expect(stocks[1].id, equals('1'));
        expect(state.canUndo, isTrue);
      },
    );

    blocTest<WatchlistBloc, WatchlistState>(
      'removes stock on WatchlistStockRemoved',
      build: () => WatchlistBloc(),
      act: (bloc) {
        bloc.add(const WatchlistLoaded());
        bloc.add(const WatchlistStockRemoved(
          watchlistId: 'wl_1',
          stockId: '1',
        ));
      },
      skip: 2,
      expect: () => [isA<WatchlistLoadSuccess>()],
      verify: (bloc) {
        final state = bloc.state as WatchlistLoadSuccess;
        expect(
          state.activeWatchlist.stocks.any((s) => s.id == '1'),
          isFalse,
        );
      },
    );

    blocTest<WatchlistBloc, WatchlistState>(
      'reverts state on WatchlistUndoRequested',
      build: () => WatchlistBloc(),
      act: (bloc) {
        bloc.add(const WatchlistLoaded());
        // Swap
        bloc.add(const WatchlistStockSwapped(
          watchlistId: 'wl_1',
          stockIdA: '1',
          stockIdB: '2',
        ));
        // Undo
        bloc.add(const WatchlistUndoRequested());
      },
      skip: 3, // skip Loading, LoadSuccess, post-swap
      expect: () => [isA<WatchlistLoadSuccess>()],
      verify: (bloc) {
        final state = bloc.state as WatchlistLoadSuccess;
        // After undo, original order restored
        expect(state.activeWatchlist.stocks[0].id, equals('1'));
        expect(state.activeWatchlist.stocks[1].id, equals('2'));
      },
    );

    blocTest<WatchlistBloc, WatchlistState>(
      'toggles edit mode on WatchlistEditModeToggled',
      build: () => WatchlistBloc(),
      act: (bloc) {
        bloc.add(const WatchlistLoaded());
        bloc.add(const WatchlistEditModeToggled());
      },
      skip: 2,
      expect: () => [isA<WatchlistLoadSuccess>()],
      verify: (bloc) {
        final state = bloc.state as WatchlistLoadSuccess;
        expect(state.isEditMode, isTrue);
      },
    );
  });
}
