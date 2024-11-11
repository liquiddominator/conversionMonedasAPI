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
      appBar: AppBar(
        title: Text(
          'Conversor de Monedas',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<CurrencyProvider>(
        builder: (context, provider, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).scaffoldBackgroundColor,
                ],
                stops: [0.0, 0.8],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Conversión rápida',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          letterSpacing: 0.5,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Convierte entre más de 30 monedas en tiempo real',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          letterSpacing: 0.25,
                        ),
                      ),
                      SizedBox(height: 24),
                      
                      // Card principal de conversión
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: _amountController,
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                style: TextStyle(
                                  fontSize: 22,
                                  letterSpacing: 0.5,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Cantidad a convertir',
                                  prefixIcon: Icon(
                                    Icons.attach_money,
                                    size: 28,
                                  ),
                                  helperText: 'Ingresa el monto a convertir',
                                ),
                              ),
                              SizedBox(height: 32),

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
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: _buildSyncButton(provider),
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
                      
                      if (_hasConverted) ...[
                        SizedBox(height: 24),
                        _buildResultCard(),
                      ],

                      SizedBox(height: 32),
                      
                      // Botones de acción
                      _buildMainButton(
                        onPressed: (_fromCurrency != null && 
                                  _toCurrency != null && 
                                  _amountController.text.isNotEmpty)
                            ? () => _handleConversion(provider)
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
                                  ? () => _navigateToHistorical()
                                  : null,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _buildSecondaryButton(
                              icon: Icons.info_outline,
                              label: 'Detalles',
                              onPressed: () => _navigateToDetails(),
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

  Widget _buildSyncButton(CurrencyProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(
          Icons.sync,
          size: 28,
          color: Theme.of(context).colorScheme.primary,
        ),
        tooltip: 'Actualizar tasas',
        onPressed: _fromCurrency == null ? null : () async {
          await provider.loadRates(_fromCurrency!);
          setState(() {
            _hasLoadedRates = true;
          });
        },
      ),
    );
  }

  Widget _buildResultCard() {
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        width: double.infinity,
        child: Column(
          children: [
            Text(
              'Resultado de la conversión',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '${_amountController.text} $_fromCurrency = ',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  '${_result.toStringAsFixed(4)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  ' $_toCurrency',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Última actualización: ${DateTime.now().toString().substring(11, 16)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
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
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          DropdownButton<String>(
            value: value,
            hint: Text(
              'Seleccionar',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
            isExpanded: true,
            underline: SizedBox(),
            dropdownColor: Theme.of(context).cardColor,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Theme.of(context).colorScheme.secondary,
            ),
            items: items.map((String currency) {
              return DropdownMenuItem<String>(
                value: currency,
                child: Text(
                  currency,
                  style: TextStyle(
                    fontSize: 16,
                    letterSpacing: 0.5,
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
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 24),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
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
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Future<void> _handleConversion(CurrencyProvider provider) async {
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

  void _navigateToHistorical() {
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

  void _navigateToDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CurrencyDetailsScreen(),
      ),
    );
  }
}