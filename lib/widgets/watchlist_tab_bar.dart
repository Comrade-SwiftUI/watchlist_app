import 'package:flutter/material.dart';
import '../models/watchlist.dart';
import '../theme/app_theme.dart';

class WatchlistTabBar extends StatelessWidget {
  final List<Watchlist> watchlists;
  final String activeId;
  final ValueChanged<String> onTabSelected;

  const WatchlistTabBar({
    super.key,
    required this.watchlists,
    required this.activeId,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: watchlists.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final watchlist = watchlists[index];
          final isActive = watchlist.id == activeId;

          return GestureDetector(
            onTap: () => onTabSelected(watchlist.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive
                    ? AppTheme.accent.withOpacity(0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isActive ? AppTheme.accent : AppTheme.border,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    watchlist.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive
                          ? AppTheme.accent
                          : AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppTheme.accent.withOpacity(0.2)
                          : AppTheme.surfaceElevated,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${watchlist.stocks.length}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: isActive
                            ? AppTheme.accent
                            : AppTheme.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
