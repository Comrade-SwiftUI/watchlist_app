part of 'watchlist_bloc.dart';

sealed class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered on app start to load all watchlists
final class WatchlistLoaded extends WatchlistEvent {
  const WatchlistLoaded();
}

/// Triggered when user selects a different watchlist tab
final class WatchlistTabChanged extends WatchlistEvent {
  final String watchlistId;

  const WatchlistTabChanged({required this.watchlistId});

  @override
  List<Object?> get props => [watchlistId];
}

/// Triggered when user reorders stocks via drag-and-drop
final class WatchlistStockReordered extends WatchlistEvent {
  final String watchlistId;
  final int oldIndex;
  final int newIndex;

  const WatchlistStockReordered({
    required this.watchlistId,
    required this.oldIndex,
    required this.newIndex,
  });

  @override
  List<Object?> get props => [watchlistId, oldIndex, newIndex];
}

/// Triggered when user swaps two specific stocks by their IDs
final class WatchlistStockSwapped extends WatchlistEvent {
  final String watchlistId;
  final String stockIdA;
  final String stockIdB;

  const WatchlistStockSwapped({
    required this.watchlistId,
    required this.stockIdA,
    required this.stockIdB,
  });

  @override
  List<Object?> get props => [watchlistId, stockIdA, stockIdB];
}

/// Triggered to remove a stock from a watchlist
final class WatchlistStockRemoved extends WatchlistEvent {
  final String watchlistId;
  final String stockId;

  const WatchlistStockRemoved({
    required this.watchlistId,
    required this.stockId,
  });

  @override
  List<Object?> get props => [watchlistId, stockId];
}

/// Triggered to add a stock to a watchlist
final class WatchlistStockAdded extends WatchlistEvent {
  final String watchlistId;
  final String stockId;

  const WatchlistStockAdded({
    required this.watchlistId,
    required this.stockId,
  });

  @override
  List<Object?> get props => [watchlistId, stockId];
}

/// Triggered to toggle edit mode on/off
final class WatchlistEditModeToggled extends WatchlistEvent {
  const WatchlistEditModeToggled();
}

/// Triggered to undo the last reorder action
final class WatchlistUndoRequested extends WatchlistEvent {
  const WatchlistUndoRequested();
}
