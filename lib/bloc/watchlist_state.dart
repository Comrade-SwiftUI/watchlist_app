part of 'watchlist_bloc.dart';

sealed class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object?> get props => [];
}

/// Initial loading state
final class WatchlistInitial extends WatchlistState {
  const WatchlistInitial();
}

/// Data loading in progress
final class WatchlistLoading extends WatchlistState {
  const WatchlistLoading();
}

/// Successfully loaded watchlists
final class WatchlistLoadSuccess extends WatchlistState {
  final List<Watchlist> watchlists;
  final String activeWatchlistId;
  final bool isEditMode;
  final bool canUndo;

  const WatchlistLoadSuccess({
    required this.watchlists,
    required this.activeWatchlistId,
    this.isEditMode = false,
    this.canUndo = false,
  });

  Watchlist get activeWatchlist =>
      watchlists.firstWhere((w) => w.id == activeWatchlistId);

  WatchlistLoadSuccess copyWith({
    List<Watchlist>? watchlists,
    String? activeWatchlistId,
    bool? isEditMode,
    bool? canUndo,
  }) {
    return WatchlistLoadSuccess(
      watchlists: watchlists ?? this.watchlists,
      activeWatchlistId: activeWatchlistId ?? this.activeWatchlistId,
      isEditMode: isEditMode ?? this.isEditMode,
      canUndo: canUndo ?? this.canUndo,
    );
  }

  @override
  List<Object?> get props => [
        watchlists,
        activeWatchlistId,
        isEditMode,
        canUndo,
      ];
}

/// Error state
final class WatchlistLoadFailure extends WatchlistState {
  final String message;

  const WatchlistLoadFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
