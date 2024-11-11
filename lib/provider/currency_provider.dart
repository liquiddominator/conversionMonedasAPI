import 'package:flutter/material.dart';
import 'package:monedas_api_project/models/currency_detail.dart';
import 'package:monedas_api_project/models/historial_rate.dart';
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

  List<HistoricalRate> _historicalRates = [];
  bool _isLoadingHistorical = false;
  
  List<HistoricalRate> get historicalRates => _historicalRates;
  bool get isLoadingHistorical => _isLoadingHistorical;

  Future<void> loadHistoricalRates(
  String baseCurrency,
  List<String> targetCurrencies,
  {DateTime? date}
) async {
  _isLoadingHistorical = true;
  _error = '';
  notifyListeners();

  try {
    final selectedDate = date ?? DateTime.now().subtract(Duration(days: 1));
    _historicalRates = await _service.getHistoricalRates(
      baseCurrency,
      targetCurrencies,
      selectedDate,
    );
  } catch (e) {
    _error = e.toString();
    print('Error loading historical rates: $e');
  }

  _isLoadingHistorical = false;
  notifyListeners();
}

Map<String, CurrencyDetail> _currencyDetails = {};
bool _isLoadingDetails = false;

Map<String, CurrencyDetail> get currencyDetails => _currencyDetails;
bool get isLoadingDetails => _isLoadingDetails;

Future<void> loadCurrencyDetails(List<String> currencies) async {
  _isLoadingDetails = true;
  _error = '';
  notifyListeners();

  try {
    _currencyDetails = await _service.getCurrencyDetails(currencies);
  } catch (e) {
    _error = e.toString();
    print('Error loading currency details: $e');
  }

  _isLoadingDetails = false;
  notifyListeners();
}

}