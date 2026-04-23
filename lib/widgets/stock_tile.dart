import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/stock.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import 'sparkline_chart.dart';

class StockTile extends StatelessWidget {
  final Stock stock;
  final bool isEditMode;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const StockTile({
    super.key,
    required this.stock,
    this.isEditMode = false,
    this.onTap,
    this.onDelete,
  });

  Color get _changeColor => switch (stock.trend) {
        StockTrend.up => AppTheme.gainGreen,
        StockTrend.down => AppTheme.lossRed,
        StockTrend.neutral => AppTheme.neutralGold,
      };

  Color get _changeBg => switch (stock.trend) {
        StockTrend.up => AppTheme.gainGreenDim,
        StockTrend.down => AppTheme.lossRedDim,
        StockTrend.neutral => AppTheme.neutralGold.withOpacity(0.12),
      };

  IconData get _trendIcon => switch (stock.trend) {
        StockTrend.up => Icons.arrow_drop_up_rounded,
        StockTrend.down => Icons.arrow_drop_down_rounded,
        StockTrend.neutral => Icons.remove_rounded,
      };

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: AppTheme.accent.withOpacity(0.05),
        highlightColor: AppTheme.surfaceElevated,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppTheme.border, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              // ── Drag handle (edit mode) ──────────────────────────────────
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: isEditMode
                    ? Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Icon(
                          Icons.drag_indicator_rounded,
                          color: AppTheme.dragHandle,
                          size: 22,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              // ── Symbol badge ─────────────────────────────────────────────
              _SymbolBadge(symbol: stock.symbol),

              const SizedBox(width: 12),

              // ── Name + volume ────────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      stock.symbol,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            stock.companyName,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Vol: ${Formatters.formatVolume(stock.volume)}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Sparkline ────────────────────────────────────────────────
              SparklineChart(
                data: stock.sparklineData,
                trend: stock.trend,
              ),

              const SizedBox(width: 12),

              // ── Price + change ───────────────────────────────────────────
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Formatters.formatPrice(stock.price),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 4),
                  _ChangeBadge(
                    change: stock.change,
                    percent: stock.changePercent,
                    color: _changeColor,
                    bgColor: _changeBg,
                    icon: _trendIcon,
                  ),
                ],
              ),

              // ── Delete button (edit mode) ────────────────────────────────
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: isEditMode
                    ? Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            onDelete?.call();
                          },
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: AppTheme.lossRedDim,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.remove_rounded,
                              color: AppTheme.lossRed,
                              size: 16,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SymbolBadge extends StatelessWidget {
  final String symbol;

  const _SymbolBadge({required this.symbol});

  Color _colorForSymbol() {
    final colors = [
      const Color(0xFF0088FF),
      const Color(0xFF00CCAA),
      const Color(0xFFAA55FF),
      const Color(0xFFFF8833),
      const Color(0xFF00D4FF),
      const Color(0xFFFF4488),
      const Color(0xFF44DD77),
      const Color(0xFFFFBB33),
    ];
    final index = symbol.codeUnits.fold(0, (a, b) => a + b) % colors.length;
    return colors[index];
  }

  @override
  Widget build(BuildContext context) {
    final color = _colorForSymbol();
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      alignment: Alignment.center,
      child: Text(
        symbol.substring(0, symbol.length.clamp(0, 2)),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _ChangeBadge extends StatelessWidget {
  final double change;
  final double percent;
  final Color color;
  final Color bgColor;
  final IconData icon;

  const _ChangeBadge({
    required this.change,
    required this.percent,
    required this.color,
    required this.bgColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 1),
          Text(
            Formatters.formatChangePercent(percent),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
