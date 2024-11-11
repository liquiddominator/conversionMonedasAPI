import 'package:flutter/material.dart';
import 'package:monedas_api_project/provider/currency_provider.dart';
import 'package:monedas_api_project/screens/currency_detail_screen.dart';
import 'package:monedas_api_project/screens/historical_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _amountController = TextEditingController();
  String? _fromCurrency;
  String? _toCurrency;
  double _result = 0.0;
  bool _hasConverted = false;
  bool _hasLoadedRates = false;

  // Lista inicial de monedas comunes
  final List<String> initialCurrencies = [
    'USD', 'EUR', 'GBP', 'JPY', 'AUD', 'CAD', 'CHF', 'CNY',
    'HKD', 'NZD', 'SEK', 'KRW', 'SGD', 'NOK', 'MXN', 'INR',
    'RUB', 'ZAR', 'TRY', 'BRL', 'TWD', 'DKK', 'PLN', 'THB',
    'IDR', 'HUF', 'CZK', 'ILS', 'CLP', 'PHP', 'AED', 'COP',
    'SAR', 'MYR', 'RON'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Conversor de Monedas',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<CurrencyProvider>(
        builder: (context, provider, child) {
          return SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).colorScheme.surface,
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'Conversión rápida',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      
                      Card(
                        elevation: 4,
                        color: Theme.of(context).cardColor,
                        shadowColor: Colors.black38,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              TextField(
                                controller: _amountController,
                                keyboardType: TextInputType.number,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontSize: 20,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Cantidad a convertir',
                                  prefixIcon: Icon(
                                    Icons.attach_money,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                              SizedBox(height: 24),

                              Row(
                                children: [
                                  Expanded(
                                    child: _buildCurrencySelector(
                                      'Moneda de origen',
                                      _fromCurrency,
                                      _hasLoadedRates ? provider.rates.keys.toList() : initialCurrencies,
                                      (String? newValue) {
                                        if (newValue != null) {
                                          setState(() {
                                            _fromCurrency = newValue;
                                            _hasConverted = false;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.sync,
                                        size: 32,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                      tooltip: 'Cargar tasas de cambio',
                                      onPressed: _fromCurrency == null ? null : () async {
                                        await provider.loadRates(_fromCurrency!);
                                        setState(() {
                                          _hasLoadedRates = true;
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildCurrencySelector(
                                      'Moneda destino',
                                      _toCurrency,
                                      _hasLoadedRates ? provider.rates.keys.toList() : initialCurrencies,
                                      (String? newValue) {
                                        setState(() {
                                          _toCurrency = newValue;
                                          _hasConverted = false;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24),

                      if (_hasConverted)
                        Card(
                          elevation: 4,
                          color: Theme.of(context).cardColor,
                          shadowColor: Colors.black38,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            width: double.infinity,
                            child: Column(
                              children: [
                                Text(
                                  'Resultado de la conversión',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      '${_amountController.text} $_fromCurrency = ',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    Text(
                                      '${_result.toStringAsFixed(4)}',
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontSize: 28,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                    Text(
                                      ' $_toCurrency',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      SizedBox(height: 24),

                      _buildMainButton(
                        onPressed: (_fromCurrency != null && 
                                  _toCurrency != null && 
                                  _amountController.text.isNotEmpty)
                            ? () async {
                                if (!_hasLoadedRates) {
                                  await provider.loadRates(_fromCurrency!);
                                  setState(() {
                                    _hasLoadedRates = true;
                                  });
                                }
                                
                                final amount = double.parse(_amountController.text);
                                final result = await provider.convert(
                                  amount,
                                  _fromCurrency!,
                                  _toCurrency!,
                                );
                                setState(() {
                                  _result = result;
                                  _hasConverted = true;
                                });
                              }
                            : null,
                        label: 'Convertir',
                        icon: Icons.currency_exchange,
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildSecondaryButton(
                              icon: Icons.history,
                              label: 'Histórico',
                              onPressed: (_fromCurrency != null && _toCurrency != null)
                                  ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HistoricalRatesScreen(
                                            baseCurrency: _fromCurrency!,
                                            targetCurrency: _toCurrency!,
                                          ),
                                        ),
                                      );
                                    }
                                  : null,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _buildSecondaryButton(
                              icon: Icons.info_outline,
                              label: 'Detalles',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CurrencyDetailsScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrencySelector(
    String label,
    String? value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          DropdownButton<String>(
            value: value,
            hint: Text(
              'Seleccionar',
              style: TextStyle(color: Colors.white70),
            ),
            isExpanded: true,
            underline: SizedBox(),
            dropdownColor: Theme.of(context).colorScheme.surface,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Theme.of(context).colorScheme.primary,
            ),
            items: items.map((String currency) {
              return DropdownMenuItem<String>(
                value: currency,
                child: Text(
                  currency,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildMainButton({
    required VoidCallback? onPressed,
    required String label,
    required IconData icon,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(
        label,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        disabledBackgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        disabledForegroundColor: Colors.white60,
      ),
    );
  }

  Widget _buildSecondaryButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}