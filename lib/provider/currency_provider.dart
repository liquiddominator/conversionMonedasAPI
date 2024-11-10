import 'package:flutter/material.dart';
import 'package:monedas_api_project/services/currency_services.dart';

class CurrencyProvider with ChangeNotifier {
  final CurrencyService _service = CurrencyService();
  Map<String, double> _rates = {};
  List<String> _supportedCurrencies = [];
  bool _isLoading = false;
  String _selectedBaseCurrency = 'USD';
  String _error = '';
  
  Map<String, double> get rates => _rates;
  List<String> get supportedCurrencies => _supportedCurrencies;
  bool get isLoading => _isLoading;
  String get selectedBaseCurrency => _selectedBaseCurrency;
  String get error => _error;

  Future<void> initialize() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _supportedCurrencies = await _service.getSupportedCurrencies();
      await loadRates(_selectedBaseCurrency);
    } catch (e) {
      _error = e.toString();
      print('Error initializing: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadRates(String base) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _rates = await _service.getRates(base);
      _selectedBaseCurrency = base;
    } catch (e) {
      _error = e.toString();
      print('Error loading rates: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<double> convert(double amount, String from, String to) async {
    return _service.convertCurrency(amount, from, to, _rates);
  }
}