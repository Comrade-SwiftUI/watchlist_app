# 021 Trade — Watchlist App

A Flutter assignment submission demonstrating a production-grade stock watchlist with **BLoC architecture**, drag-and-drop reordering, and a polished dark trading UI.

---

## ✦ Features

| Feature | Details |
|---|---|
| **Drag & Drop Reorder** | Long-press drag via `ReorderableListView` dispatches `WatchlistStockReordered` |
| **Swap by ID** | `WatchlistStockSwapped` event for programmatic two-item swaps |
| **Multiple Watchlists** | Tabbed interface — each tab is an independent watchlist |
| **Edit Mode** | Toggle shows drag handles and per-row delete buttons |
| **Undo (10 steps)** | History stack reverts any reorder/remove/swap action |
| **Sparkline Charts** | `CustomPainter`-based mini charts with fill gradients |
| **Market Summary Bar** | Live index ticker at top (NIFTY / SENSEX / BANKNIFTY) |
| **Haptic Feedback** | Medium impact on drag start, light on button taps |

---

## ✦ Project Structure

```
lib/
├── bloc/
│   ├── watchlist_bloc.dart     ← BLoC class + event/state parts
│   ├── watchlist_event.dart    ← Sealed event hierarchy
│   └── watchlist_state.dart    ← Sealed state hierarchy
│
├── models/
│   ├── stock.dart              ← Immutable Stock entity (Equatable)
│   └── watchlist.dart          ← Immutable Watchlist entity (Equatable)
│
├── screens/
│   └── watchlist_screen.dart   ← Full screen with BlocBuilder
│
├── theme/
│   └── app_theme.dart          ← Color palette, typography, ThemeData
│
├── utils/
│   ├── formatters.dart         ← Price / volume / percent formatting
│   └── stock_repository.dart   ← Sample data (10 NSE stocks, 3 watchlists)
│
├── widgets/
│   ├── market_summary_bar.dart ← Top index ticker
│   ├── sparkline_chart.dart    ← CustomPainter sparkline
│   ├── stock_tile.dart         ← Reusable list tile (edit + view modes)
│   └── watchlist_tab_bar.dart  ← Animated tab switcher
│
└── main.dart                   ← App entry, BlocProvider, system chrome

test/
└── watchlist_bloc_test.dart    ← Unit tests for all BLoC events
```

---

## ✦ BLoC Architecture

### Events (sealed class hierarchy)

```dart
WatchlistLoaded           // App start — triggers data fetch
WatchlistTabChanged       // User switches watchlist tab
WatchlistStockReordered   // Drag-and-drop reorder (oldIndex → newIndex)
WatchlistStockSwapped     // Swap two stocks by ID (for programmatic use)
WatchlistStockRemoved     // Delete a stock from watchlist
WatchlistStockAdded       // Add a stock to watchlist
WatchlistEditModeToggled  // Toggle edit mode on/off
WatchlistUndoRequested    // Revert to previous state
```

### States (sealed class hierarchy)

```dart
WatchlistInitial          // Before first event
WatchlistLoading          // Data fetch in progress
WatchlistLoadSuccess      // Watchlists loaded; holds activeWatchlistId, isEditMode, canUndo
WatchlistLoadFailure      // Error with message
```

### Data flow

```
UI Action
  │
  ▼
WatchlistEvent  ──add()──▶  WatchlistBloc
                                │
                        _pushHistory()   ← saves snapshot for undo
                                │
                        mutate watchlists list (immutable copyWith)
                                │
                                ▼
                          WatchlistState
                                │
                          BlocBuilder rebuilds UI
```

---

## ✦ Reorder Logic

Flutter's `ReorderableListView` passes `newIndex` *before* the item is removed. The BLoC corrects for this:

```dart
final targetIndex =
    event.newIndex > event.oldIndex
        ? event.newIndex - 1   // compensate for removal
        : event.newIndex;
stocks.insert(targetIndex, item);
```

---

## ✦ Sample Data

`StockRepository` provides 10 NSE-listed stocks across 3 watchlists:

- **My Watchlist** — all 10 stocks
- **Tech Stocks** — TCS, INFY, WIPRO
- **Banking** — HDFCBANK, ICICIBANK, SBIN

Each stock has: `id`, `symbol`, `companyName`, `price`, `change`, `changePercent`, `volume`, `marketCap`, `trend` (enum), `sparklineData` (List\<double\>).

---

## ✦ Setup & Run

```bash
# Clone and navigate
cd watchlist_app

# Install dependencies
flutter pub get

# Run on device/emulator
flutter run

# Run tests
flutter test

# Check lints
flutter analyze
```

**Minimum SDK:** Flutter ≥ 3.10, Dart ≥ 3.0

---

## ✦ Key Dependencies

| Package | Purpose |
|---|---|
| `flutter_bloc: ^8.1.3` | BLoC state management |
| `equatable: ^2.0.5` | Value equality for models & states |
| `google_fonts: ^6.1.0` | Space Grotesk + JetBrains Mono typography |
| `flutter_slidable: ^3.0.1` | Optional slide-to-delete gesture |
| `gap: ^3.0.1` | Readable spacing widgets |
| `bloc_test: ^9.1.5` | BLoC unit test utilities |

---

## ✦ Design Decisions

1. **Sealed classes** for events and states (Dart 3) — exhaustive pattern matching in UI with `switch`
2. **Immutable models** with `copyWith` — no accidental mutation
3. **History stack** capped at 10 — gives undo without unbounded memory growth
4. **`proxyDecorator`** on `ReorderableListView` — glowing shadow while dragging
5. **`ValueKey(stock.id)`** on every tile — stable keys prevent animation glitches during reorder
6. **Repository layer** separate from BLoC — easy to swap for API/DB later
