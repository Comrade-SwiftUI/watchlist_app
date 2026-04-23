import 'package:equatable/equatable.dart';

enum StockTrend { up, down, neutral }

class Stock extends Equatable {
  final String id;
  final String symbol;
  final String companyName;
  final double price;
  final double change;
  final double changePercent;
  final double volume;
  final double marketCap;
  final StockTrend trend;
  final List<double> sparklineData;

  const Stock({
    required this.id,
    required this.symbol,
    required this.companyName,
    required this.price,
    required this.change,
    required this.changePercent,
    required this.volume,
    required this.marketCap,
    required this.trend,
    required this.sparklineData,
  });

  Stock copyWith({
    String? id,
    String? symbol,
    String? companyName,
    double? price,
    double? change,
    double? changePercent,
    double? volume,
    double? marketCap,
    StockTrend? trend,
    List<double>? sparklineData,
  }) {
    return Stock(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      companyName: companyName ?? this.companyName,
      price: price ?? this.price,
      change: change ?? this.change,
      changePercent: changePercent ?? this.changePercent,
      volume: volume ?? this.volume,
      marketCap: marketCap ?? this.marketCap,
      trend: trend ?? this.trend,
      sparklineData: sparklineData ?? this.sparklineData,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'symbol': symbol,
      'companyName': companyName,
      'price': price,
      'change': change,
      'changePercent': changePercent,
      'volume': volume,
      'marketCap': marketCap,
      'trend': trend.name,
      'sparklineData': sparklineData,
    };
  }

  factory Stock.fromMap(Map<String, dynamic> map) {
    return Stock(
      id: map['id'] as String,
      symbol: map['symbol'] as String,
      companyName: map['companyName'] as String,
      price: (map['price'] as num).toDouble(),
      change: (map['change'] as num).toDouble(),
      changePercent: (map['changePercent'] as num).toDouble(),
      volume: (map['volume'] as num).toDouble(),
      marketCap: (map['marketCap'] as num).toDouble(),
      trend: StockTrend.values.firstWhere((e) => e.name == map['trend']),
      sparklineData: List<double>.from(
        (map['sparklineData'] as List).map((e) => (e as num).toDouble()),
      ),
    );
  }

  @override
  List<Object?> get props => [
        id,
        symbol,
        companyName,
        price,
        change,
        changePercent,
        volume,
        marketCap,
        trend,
        sparklineData,
      ];
}
