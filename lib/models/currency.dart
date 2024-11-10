class Currency {
  final String code;
  final String name;
  final double rate;

  Currency({
    required this.code,
    required this.name,
    required this.rate,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      code: json['code'],
      name: json['name'],
      rate: json['rate'].toDouble(),
    );
  }
}