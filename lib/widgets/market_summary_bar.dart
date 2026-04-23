import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MarketSummaryBar extends StatelessWidget {
  const MarketSummaryBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.border, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _MarketIndex(
              name: 'NIFTY 50',
              value: '22,456.80',
              change: '+1.24%',
              isPositive: true,
            ),
          ),
          Expanded(
            child: _MarketIndex(
              name: 'SENSEX',
              value: '73,961.32',
              change: '+1.18%',
              isPositive: true,
            ),
          ),
          Expanded(
            child: _MarketIndex(
              name: 'BANK NIFTY',
              value: '48,332.15',
              change: '-0.43%',
              isPositive: false,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.gainGreenDim,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppTheme.gainGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  'LIVE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.gainGreen,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MarketIndex extends StatelessWidget {
  final String name;
  final String value;
  final String change;
  final bool isPositive;

  const _MarketIndex({
    required this.name,
    required this.value,
    required this.change,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 9,
            color: AppTheme.textMuted,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        Text(
          change,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: isPositive ? AppTheme.gainGreen : AppTheme.lossRed,
          ),
        ),
      ],
    );
  }
}
