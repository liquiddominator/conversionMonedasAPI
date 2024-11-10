class HistoricalRate {
  final DateTime date;
  final double rate;
  final String currency;  // Añadir el código de la moneda

  HistoricalRate({
    required this.date,
    required this.rate,
    required this.currency,
  });
}