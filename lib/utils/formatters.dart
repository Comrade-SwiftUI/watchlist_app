class Formatters {
  Formatters._();

  static String formatPrice(double price) {
    if (price >= 1000) {
      return '₹${price.toStringAsFixed(2)}';
    }
    return '₹${price.toStringAsFixed(2)}';
  }

  static String formatChange(double change) {
    final prefix = change >= 0 ? '+' : '';
    return '$prefix${change.toStringAsFixed(2)}';
  }

  static String formatChangePercent(double percent) {
    final prefix = percent >= 0 ? '+' : '';
    return '$prefix${percent.toStringAsFixed(2)}%';
  }

  static String formatVolume(double volume) {
    if (volume >= 10000000) {
      return '${(volume / 10000000).toStringAsFixed(2)}Cr';
    } else if (volume >= 100000) {
      return '${(volume / 100000).toStringAsFixed(2)}L';
    } else if (volume >= 1000) {
      return '${(volume / 1000).toStringAsFixed(1)}K';
    }
    return volume.toStringAsFixed(0);
  }

  static String formatMarketCap(double cap) {
    if (cap >= 1000000000000) {
      return '₹${(cap / 1000000000000).toStringAsFixed(2)}T';
    } else if (cap >= 10000000) {
      return '₹${(cap / 10000000).toStringAsFixed(2)}Cr';
    }
    return '₹${cap.toStringAsFixed(0)}';
  }
}
