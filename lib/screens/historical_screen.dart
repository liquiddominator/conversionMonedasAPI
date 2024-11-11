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
    // Solo inicializamos los valores pero no hacemos peticiones
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
        title: Text('Histórico de Tasas'),
      ),
      body: Consumer<CurrencyProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Selector de moneda base
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Moneda Base',
                    border: OutlineInputBorder(),
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
                    labelText: 'Monedas a comparar (separadas por coma)',
                    hintText: 'EUR,USD,GBP',
                    border: OutlineInputBorder(),
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
                Card(
                  child: ListTile(
                    leading: Icon(Icons.calendar_today),
                    title: Text('Fecha'),
                    subtitle: Text(
                      selectedDate != null 
                        ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                        : 'Seleccione una fecha'
                    ),
                    onTap: () => _selectDate(context),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: (selectedDate != null && 
                            selectedBaseCurrency != null && 
                            selectedCurrencies.isNotEmpty)
                      ? _loadHistoricalData
                      : null,
                  child: Text('Buscar Datos Históricos'),
                ),
                SizedBox(height: 20),
                if (provider.isLoadingHistorical)
                  CircularProgressIndicator()
                else if (provider.error.isNotEmpty)
                  Text(provider.error)
                else if (provider.historicalRates.isEmpty)
                  Text('No hay datos históricos disponibles')
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: provider.historicalRates.length,
                      itemBuilder: (context, index) {
                        final rate = provider.historicalRates[index];
                        return Card(
                          child: ListTile(
                            title: Text(
                              '1 $selectedBaseCurrency = ${rate.rate.toStringAsFixed(4)} ${rate.currency}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}