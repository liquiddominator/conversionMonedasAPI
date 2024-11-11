import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:monedas_api_project/provider/currency_provider.dart';
import 'package:provider/provider.dart';

class HistoricalRatesScreen extends StatefulWidget {
  final String baseCurrency;
  final String targetCurrency;

  const HistoricalRatesScreen({
    Key? key,
    required this.baseCurrency,
    required this.targetCurrency,
  }) : super(key: key);

  @override
  _HistoricalRatesScreenState createState() => _HistoricalRatesScreenState();
}

class _HistoricalRatesScreenState extends State<HistoricalRatesScreen> {
  DateTime? selectedDate;
  String? selectedBaseCurrency;
  List<String> selectedCurrencies = [];
  final TextEditingController _currenciesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedBaseCurrency = widget.baseCurrency;
    _currenciesController.text = widget.targetCurrency;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now().subtract(Duration(days: 1)),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      if (selectedBaseCurrency != null && selectedCurrencies.isNotEmpty) {
        _loadHistoricalData();
      }
    }
  }

  void _loadHistoricalData() {
    if (selectedDate != null && selectedBaseCurrency != null && selectedCurrencies.isNotEmpty) {
      context.read<CurrencyProvider>().loadHistoricalRates(
        selectedBaseCurrency!,
        selectedCurrencies,
        date: selectedDate!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Histórico de Tasas',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Análisis histórico de divisas',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white70,
                letterSpacing: 0.25,
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.date_range, size: 16),
                SizedBox(width: 4),
                Text(
                  'Historical',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Consumer<CurrencyProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
                decoration: BoxDecoration(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    _buildStatBox(
                      'Moneda Base',
                      selectedBaseCurrency ?? '-',
                      Icons.currency_exchange,
                    ),
                    SizedBox(width: 16),
                    _buildStatBox(
                      'Monedas',
                      selectedCurrencies.isEmpty ? '0' : selectedCurrencies.length.toString(),
                      Icons.format_list_numbered,
                    ),
                    SizedBox(width: 16),
                    _buildStatBox(
                      'Fecha',
                      selectedDate != null ? '${selectedDate!.day}/${selectedDate!.month}' : '-',
                      Icons.event,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Configuración',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 16),
                      Card(
                        elevation: 4,
                        shadowColor: Colors.black12,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Selector de moneda base
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Moneda Base',
                                  prefixIcon: Icon(Icons.paid),
                                ),
                                value: selectedBaseCurrency,
                                items: provider.rates.keys.map((String currency) {
                                  return DropdownMenuItem<String>(
                                    value: currency,
                                    child: Text(currency),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      selectedBaseCurrency = newValue;
                                    });
                                    if (selectedDate != null && selectedCurrencies.isNotEmpty) {
                                      _loadHistoricalData();
                                    }
                                  }
                                },
                              ),
                              SizedBox(height: 16),
                              
                              // Campo para monedas a comparar
                              TextFormField(
                                controller: _currenciesController,
                                decoration: InputDecoration(
                                  labelText: 'Monedas a comparar',
                                  hintText: 'EUR,USD,GBP',
                                  prefixIcon: Icon(Icons.public),
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.search),
                                    onPressed: () {
                                      final currencies = _currenciesController.text
                                          .split(',')
                                          .map((e) => e.trim().toUpperCase())
                                          .where((e) => e.isNotEmpty)
                                          .toList();
                                      setState(() {
                                        selectedCurrencies = currencies;
                                      });
                                      if (selectedDate != null && selectedBaseCurrency != null) {
                                        _loadHistoricalData();
                                      }
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              
                              // Selector de fecha
                              InkWell(
                                onTap: () => _selectDate(context),
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                      SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Fecha seleccionada',
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.primary,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            selectedDate != null 
                                              ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                                              : 'Seleccione una fecha',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: (selectedDate != null && 
                                    selectedBaseCurrency != null && 
                                    selectedCurrencies.isNotEmpty)
                              ? _loadHistoricalData
                              : null,
                          icon: Icon(Icons.search),
                          label: Text('Buscar Datos Históricos'),
                        ),
                      ),
                      
                      SizedBox(height: 24),
                      
                      if (provider.isLoadingHistorical)
                        Center(
                          child: Column(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text('Cargando datos históricos...'),
                            ],
                          ),
                        )
                      else if (provider.error.isNotEmpty)
                        Card(
                          color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    provider.error,
                                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (provider.historicalRates.isEmpty)
                        Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.history,
                                size: 48,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No hay datos históricos disponibles',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Resultados',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 16),
                            ...provider.historicalRates.map((rate) => Card(
                              margin: EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.currency_exchange,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                title: Text(
                                  '1 $selectedBaseCurrency = ${rate.rate.toStringAsFixed(4)} ${rate.currency}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                              ),
                            )).toList(),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatBox(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: Colors.white70,
                ),
                SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],//
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}