import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/watchlist_bloc.dart';
import '../theme/app_theme.dart';
import '../widgets/market_summary_bar.dart';
import '../widgets/stock_tile.dart';
import '../widgets/watchlist_tab_bar.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistBloc, WatchlistState>(
      builder: (context, state) {
        return switch (state) {
          WatchlistInitial() => const _LoadingView(),
          WatchlistLoading() => const _LoadingView(),
          WatchlistLoadFailure(:final message) => _ErrorView(message: message),
          WatchlistLoadSuccess() => _WatchlistView(state: state),
        };
      },
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: AppTheme.accent,
          strokeWidth: 2,
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                color: AppTheme.lossRed, size: 48),
            const SizedBox(height: 16),
            Text(message, style: const TextStyle(color: AppTheme.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _WatchlistView extends StatelessWidget {
  final WatchlistLoadSuccess state;

  const _WatchlistView({required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          const MarketSummaryBar(),
          const SizedBox(height: 12),
          WatchlistTabBar(
            watchlists: state.watchlists,
            activeId: state.activeWatchlistId,
            onTabSelected: (id) => context.read<WatchlistBloc>().add(
                  WatchlistTabChanged(watchlistId: id),
                ),
          ),
          const SizedBox(height: 8),
          _buildColumnHeaders(),
          const Divider(height: 0.5, color: AppTheme.border),
          Expanded(
            child: _StockList(state: state),
          ),
        ],
      ),
      floatingActionButton: state.isEditMode
          ? _buildEditModeFab(context)
          : null,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '021 Trade',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          Text(
            'Watchlist · ${state.activeWatchlist.stocks.length} stocks',
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.textMuted,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      actions: [
        // Undo button
        if (state.canUndo)
          IconButton(
            icon: const Icon(Icons.undo_rounded, color: AppTheme.accent),
            tooltip: 'Undo',
            onPressed: () {
              HapticFeedback.lightImpact();
              context
                  .read<WatchlistBloc>()
                  .add(const WatchlistUndoRequested());
            },
          ),

        // Edit / Done toggle
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              context
                  .read<WatchlistBloc>()
                  .add(const WatchlistEditModeToggled());
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: state.isEditMode
                    ? AppTheme.accent.withOpacity(0.15)
                    : AppTheme.surfaceElevated,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: state.isEditMode
                      ? AppTheme.accent.withOpacity(0.5)
                      : AppTheme.border,
                  width: 1,
                ),
              ),
              child: Text(
                state.isEditMode ? 'Done' : 'Edit',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color:
                      state.isEditMode ? AppTheme.accent : AppTheme.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColumnHeaders() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'SYMBOL / NAME',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppTheme.textMuted,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(
            width: 64,
            child: Center(
              child: Text(
                'CHART',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textMuted,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'PRICE / CHANGE',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppTheme.textMuted,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditModeFab(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: AppTheme.surface,
      foregroundColor: AppTheme.textPrimary,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppTheme.border),
      ),
      onPressed: () {
        HapticFeedback.mediumImpact();
        context.read<WatchlistBloc>().add(const WatchlistEditModeToggled());
      },
      icon: const Icon(Icons.check_rounded, color: AppTheme.gainGreen),
      label: const Text(
        'Done Editing',
        style: TextStyle(
          color: AppTheme.gainGreen,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _StockList extends StatelessWidget {
  final WatchlistLoadSuccess state;

  const _StockList({required this.state});

  @override
  Widget build(BuildContext context) {
    final stocks = state.activeWatchlist.stocks;
    final watchlistId = state.activeWatchlistId;

    if (stocks.isEmpty) {
      return _EmptyWatchlist(watchlistId: watchlistId);
    }

    if (state.isEditMode) {
      return _ReorderableStockList(
        stocks: stocks,
        watchlistId: watchlistId,
      );
    }

    return ListView.builder(
      itemCount: stocks.length,
      itemBuilder: (context, index) {
        final stock = stocks[index];
        return StockTile(
          key: ValueKey(stock.id),
          stock: stock,
          isEditMode: false,
          onTap: () {
            // Navigation to stock detail would go here
            _showStockDetail(context, stock);
          },
        );
      },
    );
  }

  void _showStockDetail(BuildContext context, stock) {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${stock.symbol} detail — coming soon', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

class _ReorderableStockList extends StatelessWidget {
  final List stocks;
  final String watchlistId;

  const _ReorderableStockList({
    required this.stocks,
    required this.watchlistId,
  });

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      itemCount: stocks.length,
      onReorder: (oldIndex, newIndex) {
        HapticFeedback.mediumImpact();
        context.read<WatchlistBloc>().add(
              WatchlistStockReordered(
                watchlistId: watchlistId,
                oldIndex: oldIndex,
                newIndex: newIndex,
              ),
            );
      },
      proxyDecorator: (child, index, animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Material(
              elevation: 8 * animation.value,
              color: AppTheme.reorderHighlight,
              borderRadius: BorderRadius.circular(8),
              shadowColor: AppTheme.accent.withOpacity(0.3),
              child: child,
            );
          },
          child: child,
        );
      },
      itemBuilder: (context, index) {
        final stock = stocks[index];
        return StockTile(
          key: ValueKey(stock.id),
          stock: stock,
          isEditMode: true,
          onDelete: () {
            context.read<WatchlistBloc>().add(
                  WatchlistStockRemoved(
                    watchlistId: watchlistId,
                    stockId: stock.id,
                  ),
                );
          },
        );
      },
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────
class _EmptyWatchlist extends StatelessWidget {
  final String watchlistId;

  const _EmptyWatchlist({required this.watchlistId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.surfaceElevated,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.border),
            ),
            child: const Icon(
              Icons.bookmark_outline_rounded,
              color: AppTheme.textMuted,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No stocks in this watchlist',
            style: TextStyle(
              fontSize: 15,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tap Edit to manage your watchlist',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
