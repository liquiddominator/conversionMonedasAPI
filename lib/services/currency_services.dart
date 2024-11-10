import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  static const String apiKey = 'cur_live_kOqAbcJFbCM69FXZSOj6XYyBzlyK1QDyhuI9Erc1';
  static const String baseUrl = 'https://api.currencyapi.com/v3';

  Future<Map<String, double>> getRates(String base) async {
    final response = await http.get(
      Uri.parse('$baseUrl/latest?base_currency=$base'),
      headers: {
        'apikey': apiKey,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      Map<String, double> rates = {};
      
      (data['data'] as Map<String, dynamic>).forEach((key, value) {
        rates[key] = value['value'].toDouble();
      });
      
      return rates;
    } else {
      throw Exception('Failed to load currency rates: ${response.body}');
    }
  }

  Future<List<String>> getSupportedCurrencies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/currencies'),
      headers: {
        'apikey': apiKey,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<String> currencies = [];
      
      (data['data'] as Map<String, dynamic>).forEach((key, value) {
        currencies.add(key);
      });
      
      return currencies;
    } else {
      throw Exception('Failed to load currencies: ${response.body}');
    }
  }

  Future<double> convertCurrency(
      double amount, String from, String to, Map<String, double> rates) {
    if (!rates.containsKey(to) || !rates.containsKey(from)) {
      throw Exception('Currency not found in rates');
    }
    
    final double rate = rates[to]! / rates[from]!;
    return Future.value(amount * rate);
  }
}
