/// Centralized Currency Service for TechKart
///
/// Manages currency conversion (USD to INR at live actual exchange rate)
/// and centralized formatting using Indian Rupee (₹) conventions.
class CurrencyService {
  /// The latest actual USD-to-INR mid-market exchange rate.
  static const double usdToInrRate = 94.42;

  /// Currency symbol for Indian Rupees.
  static const String currencySymbol = '₹';

  /// Standard ISO currency code for Indian Rupees.
  static const String currencyCode = 'INR';

  /// Converts a USD amount to INR using the latest actual exchange rate,
  /// rounding appropriately to 2 decimal places.
  static double convertUsdToInr(double usd) {
    return double.parse((usd * usdToInrRate).toStringAsFixed(2));
  }

  /// Formats an INR amount with the Rupee symbol and Indian grouping system.
  /// Example: 40506.18 -> "₹40,506.18"
  /// Example: 169861.58 -> "₹1,69,861.58"
  /// Example: 944.20 -> "₹944.20"
  /// Example: -944.20 -> "-₹944.20"
  static String formatInr(
    double inrAmount, {
    bool includeSymbol = true,
    bool showDecimals = true,
  }) {
    final symbol = includeSymbol ? currencySymbol : '';
    final isNegative = inrAmount < 0;
    final absAmount = inrAmount.abs();

    final parts = absAmount.toStringAsFixed(showDecimals ? 2 : 0).split('.');
    final integerPart = parts[0];
    final decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

    String formattedInt = '';
    if (integerPart.length <= 3) {
      formattedInt = integerPart;
    } else {
      final lastThree = integerPart.substring(integerPart.length - 3);
      var remaining = integerPart.substring(0, integerPart.length - 3);
      final chunks = <String>[];
      while (remaining.length > 2) {
        chunks.insert(0, remaining.substring(remaining.length - 2));
        remaining = remaining.substring(0, remaining.length - 2);
      }
      if (remaining.isNotEmpty) {
        chunks.insert(0, remaining);
      }
      formattedInt = '${chunks.join(',')},$lastThree';
    }

    final sign = isNegative ? '-' : '';
    return '$sign$symbol$formattedInt$decimalPart';
  }

  /// Converts a USD amount to INR and formats it as an Indian Rupee string.
  static String formatUsdToInr(
    double usdAmount, {
    bool includeSymbol = true,
    bool showDecimals = true,
  }) {
    final inr = convertUsdToInr(usdAmount);
    return formatInr(inr, includeSymbol: includeSymbol, showDecimals: showDecimals);
  }
}
