import '../models/stock.dart';
import '../models/watchlist.dart';

class StockRepository {
  static const List<Stock> _sampleStocks = [
    Stock(
      id: '1',
      symbol: 'RELIANCE',
      companyName: 'Reliance Industries Ltd.',
      price: 2847.35,
      change: 42.15,
      changePercent: 1.50,
      volume: 8542310,
      marketCap: 19280000000000,
      trend: StockTrend.up,
      sparklineData: [2780, 2795, 2810, 2798, 2820, 2835, 2847],
    ),
    Stock(
      id: '2',
      symbol: 'TCS',
      companyName: 'Tata Consultancy Services',
      price: 3612.80,
      change: -28.45,
      changePercent: -0.78,
      volume: 3241870,
      marketCap: 13150000000000,
      trend: StockTrend.down,
      sparklineData: [3680, 3665, 3650, 3648, 3640, 3625, 3612],
    ),
    Stock(
      id: '3',
      symbol: 'HDFCBANK',
      companyName: 'HDFC Bank Limited',
      price: 1678.90,
      change: 15.60,
      changePercent: 0.94,
      volume: 12456780,
      marketCap: 12780000000000,
      trend: StockTrend.up,
      sparklineData: [1655, 1660, 1665, 1668, 1672, 1675, 1678],
    ),
    Stock(
      id: '4',
      symbol: 'INFY',
      companyName: 'Infosys Limited',
      price: 1445.25,
      change: -12.30,
      changePercent: -0.84,
      volume: 5874320,
      marketCap: 6020000000000,
      trend: StockTrend.down,
      sparklineData: [1470, 1465, 1460, 1455, 1450, 1448, 1445],
    ),
    Stock(
      id: '5',
      symbol: 'ICICIBANK',
      companyName: 'ICICI Bank Limited',
      price: 1089.55,
      change: 8.75,
      changePercent: 0.81,
      volume: 9632140,
      marketCap: 7680000000000,
      trend: StockTrend.up,
      sparklineData: [1075, 1078, 1080, 1083, 1085, 1087, 1089],
    ),
    Stock(
      id: '6',
      symbol: 'WIPRO',
      companyName: 'Wipro Limited',
      price: 456.70,
      change: 0.00,
      changePercent: 0.00,
      volume: 4521000,
      marketCap: 2360000000000,
      trend: StockTrend.neutral,
      sparklineData: [455, 456, 457, 456, 457, 456, 456],
    ),
    Stock(
      id: '7',
      symbol: 'BAJFINANCE',
      companyName: 'Bajaj Finance Limited',
      price: 6934.15,
      change: 124.85,
      changePercent: 1.83,
      volume: 2145670,
      marketCap: 4280000000000,
      trend: StockTrend.up,
      sparklineData: [6780, 6810, 6840, 6870, 6895, 6915, 6934],
    ),
    Stock(
      id: '8',
      symbol: 'TATAMOTORS',
      companyName: 'Tata Motors Limited',
      price: 847.40,
      change: -18.60,
      changePercent: -2.15,
      volume: 11234560,
      marketCap: 3120000000000,
      trend: StockTrend.down,
      sparklineData: [885, 875, 870, 865, 858, 852, 847],
    ),
    Stock(
      id: '9',
      symbol: 'SBIN',
      companyName: 'State Bank of India',
      price: 762.85,
      change: 6.45,
      changePercent: 0.85,
      volume: 18754320,
      marketCap: 6800000000000,
      trend: StockTrend.up,
      sparklineData: [752, 754, 756, 758, 759, 761, 762],
    ),
    Stock(
      id: '10',
      symbol: 'ASIANPAINT',
      companyName: 'Asian Paints Limited',
      price: 2312.60,
      change: -35.40,
      changePercent: -1.51,
      volume: 1234560,
      marketCap: 2210000000000,
      trend: StockTrend.down,
      sparklineData: [2380, 2368, 2355, 2345, 2335, 2322, 2312],
    ),
  ];

  static List<Watchlist> getWatchlists() {
    return [
      Watchlist(
        id: 'wl_1',
        name: 'My Watchlist',
        stocks: List.from(_sampleStocks),
      ),
      Watchlist(
        id: 'wl_2',
        name: 'Tech Stocks',
        stocks: _sampleStocks
            .where((s) => ['TCS', 'INFY', 'WIPRO'].contains(s.symbol))
            .toList(),
      ),
      Watchlist(
        id: 'wl_3',
        name: 'Banking',
        stocks: _sampleStocks
            .where((s) =>
                ['HDFCBANK', 'ICICIBANK', 'SBIN'].contains(s.symbol))
            .toList(),
      ),
    ];
  }

  static List<Stock> get allStocks => List.unmodifiable(_sampleStocks);
}
