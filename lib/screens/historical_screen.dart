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
  @override
  void initState() {
    super.initState();
    // Cargar datos de los últimos 30 días
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: 30));
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CurrencyProvider>().loadHistoricalRates(
        widget.baseCurrency,
        widget.targetCurrency,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico ${widget.baseCurrency}/${widget.targetCurrency}'),
      ),
      body: Consumer<CurrencyProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingHistorical) {
            return Center(child: CircularProgressIndicator());
          }

          if (provider.error.isNotEmpty) {
            return Center(child: Text(provider.error));
          }

          if (provider.historicalRates.isEmpty) {
            return Center(child: Text('No hay datos históricos disponibles'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Evolución de la tasa de cambio',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 20),
                Expanded(
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() >= 0 && 
                                  value.toInt() < provider.historicalRates.length) {
                                final date = provider.historicalRates[value.toInt()].date;
                                return Text(
                                  '${date.day}/${date.month}',
                                  style: TextStyle(fontSize: 10),
                                );
                              }
                              return Text('');
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: provider.historicalRates
                              .asMap()
                              .entries
                              .map((entry) => FlSpot(
                                    entry.key.toDouble(),
                                    entry.value.rate,
                                  ))
                              .toList(),
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: 3,
                          dotData: FlDotData(show: false),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Últimos 30 días',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}