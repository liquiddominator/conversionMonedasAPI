class CurrencyDetail {
  final String code;
  final String name;
  final String symbol;
  final String symbolNative;
  final int decimalDigits;
  final int rounding;
  final String namePlural;
  final String type;
  final List<String> countries;

  CurrencyDetail({
    required this.code,
    required this.name,
    required this.symbol,
    required this.symbolNative,
    required this.decimalDigits,
    required this.rounding,
    required this.namePlural,
    required this.type,
    required this.countries,
  });

  factory CurrencyDetail.fromJson(Map<String, dynamic> json) {
    return CurrencyDetail(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      symbol: json['symbol'] ?? '',
      symbolNative: json['symbol_native'] ?? '',
      decimalDigits: json['decimal_digits'] ?? 0,
      rounding: json['rounding'] ?? 0,
      namePlural: json['name_plural'] ?? '',
      type: json['type'] ?? '',
      countries: List<String>.from(json['countries'] ?? []),
    );
  }
}