import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/stock.dart';
import '../models/watchlist.dart';
import '../utils/stock_repository.dart';

part 'watchlist_event.dart';
part 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  /// History stack for undo support — stores previous watchlist snapshots
  final List<List<Watchlist>> _history = [];

  WatchlistBloc() : super(const WatchlistInitial()) {
    on<WatchlistLoaded>(_onWatchlistLoaded);
    on<WatchlistTabChanged>(_onTabChanged);
    on<WatchlistStockReordered>(_onStockReordered);
    on<WatchlistStockSwapped>(_onStockSwapped);
    on<WatchlistStockRemoved>(_onStockRemoved);
    on<WatchlistStockAdded>(_onStockAdded);
    on<WatchlistEditModeToggled>(_onEditModeToggled);
    on<WatchlistUndoRequested>(_onUndoRequested);
  }

  void _onWatchlistLoaded(
    WatchlistLoaded event,
    Emitter<WatchlistState> emit,
  ) {
    emit(const WatchlistLoading());
    try {
      final watchlists = StockRepository.getWatchlists();
      emit(WatchlistLoadSuccess(
        watchlists: watchlists,
        activeWatchlistId: watchlists.first.id,
      ));
    } catch (e) {
      emit(WatchlistLoadFailure(message: e.toString()));
    }
  }

  void _onTabChanged(
    WatchlistTabChanged event,
    Emitter<WatchlistState> emit,
  ) {
    final current = state;
    if (current is! WatchlistLoadSuccess) return;

    emit(current.copyWith(
      activeWatchlistId: event.watchlistId,
      isEditMode: false,
    ));
  }

  void _onStockReordered(
    WatchlistStockReordered event,
    Emitter<WatchlistState> emit,
  ) {
    final current = state;
    if (current is! WatchlistLoadSuccess) return;

    _pushHistory(current.watchlists);

    final updatedWatchlists = current.watchlists.map((watchlist) {
      if (watchlist.id != event.watchlistId) return watchlist;

      final stocks = List<Stock>.from(watchlist.stocks);
      final item = stocks.removeAt(event.oldIndex);

      // Flutter's ReorderableListView fires newIndex after removal
      final targetIndex =
          event.newIndex > event.oldIndex ? event.newIndex - 1 : event.newIndex;
      stocks.insert(targetIndex, item);

      return watchlist.copyWith(stocks: stocks);
    }).toList();

    emit(current.copyWith(
      watchlists: updatedWatchlists,
      canUndo: true,
    ));
  }

  void _onStockSwapped(
    WatchlistStockSwapped event,
    Emitter<WatchlistState> emit,
  ) {
    final current = state;
    if (current is! WatchlistLoadSuccess) return;

    _pushHistory(current.watchlists);

    final updatedWatchlists = current.watchlists.map((watchlist) {
      if (watchlist.id != event.watchlistId) return watchlist;

      final stocks = List<Stock>.from(watchlist.stocks);
      final indexA = stocks.indexWhere((s) => s.id == event.stockIdA);
      final indexB = stocks.indexWhere((s) => s.id == event.stockIdB);

      if (indexA == -1 || indexB == -1) return watchlist;

      // Swap the two items
      final temp = stocks[indexA];
      stocks[indexA] = stocks[indexB];
      stocks[indexB] = temp;

      return watchlist.copyWith(stocks: stocks);
    }).toList();

    emit(current.copyWith(
      watchlists: updatedWatchlists,
      canUndo: true,
    ));
  }

  void _onStockRemoved(
    WatchlistStockRemoved event,
    Emitter<WatchlistState> emit,
  ) {
    final current = state;
    if (current is! WatchlistLoadSuccess) return;

    _pushHistory(current.watchlists);

    final updatedWatchlists = current.watchlists.map((watchlist) {
      if (watchlist.id != event.watchlistId) return watchlist;

      final stocks = watchlist.stocks
          .where((s) => s.id != event.stockId)
          .toList();

      return watchlist.copyWith(stocks: stocks);
    }).toList();

    emit(current.copyWith(
      watchlists: updatedWatchlists,
      canUndo: true,
    ));
  }

  void _onStockAdded(
    WatchlistStockAdded event,
    Emitter<WatchlistState> emit,
  ) {
    final current = state;
    if (current is! WatchlistLoadSuccess) return;

    final stockToAdd = StockRepository.allStocks.firstWhere(
      (s) => s.id == event.stockId,
      orElse: () => throw Exception('Stock not found: ${event.stockId}'),
    );

    _pushHistory(current.watchlists);

    final updatedWatchlists = current.watchlists.map((watchlist) {
      if (watchlist.id != event.watchlistId) return watchlist;

      // Avoid duplicates
      if (watchlist.stocks.any((s) => s.id == event.stockId)) return watchlist;

      return watchlist.copyWith(
        stocks: [...watchlist.stocks, stockToAdd],
      );
    }).toList();

    emit(current.copyWith(
      watchlists: updatedWatchlists,
      canUndo: true,
    ));
  }

  void _onEditModeToggled(
    WatchlistEditModeToggled event,
    Emitter<WatchlistState> emit,
  ) {
    final current = state;
    if (current is! WatchlistLoadSuccess) return;

    emit(current.copyWith(isEditMode: !current.isEditMode));
  }

  void _onUndoRequested(
    WatchlistUndoRequested event,
    Emitter<WatchlistState> emit,
  ) {
    final current = state;
    if (current is! WatchlistLoadSuccess || _history.isEmpty) return;

    final previousWatchlists = _history.removeLast();
    emit(current.copyWith(
      watchlists: previousWatchlists,
      canUndo: _history.isNotEmpty,
    ));
  }

  void _pushHistory(List<Watchlist> watchlists) {
    _history.add(List<Watchlist>.from(watchlists));
    // Limit history to 10 steps
    if (_history.length > 10) _history.removeAt(0);
  }
}
