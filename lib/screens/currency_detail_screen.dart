import 'package:flutter/material.dart';
import 'package:monedas_api_project/provider/currency_provider.dart';
import 'package:provider/provider.dart';

class CurrencyDetailsScreen extends StatefulWidget {
  @override
  _CurrencyDetailsScreenState createState() => _CurrencyDetailsScreenState();
}

class _CurrencyDetailsScreenState extends State<CurrencyDetailsScreen> {
  final TextEditingController _currencyController = TextEditingController();
  List<String> selectedCurrencies = [];
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de Monedas'),
      ),
      body: Consumer<CurrencyProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Campo para ingresar monedas
                TextFormField(
                  controller: _currencyController,
                  decoration: InputDecoration(
                    labelText: 'Monedas (separadas por coma)',
                    hintText: 'EUR,USD,GBP',
                    border: OutlineInputBorder(),
                    helperText: 'Ingresa los códigos o selecciona de la lista disponible',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        if (_currencyController.text.isNotEmpty) {
                          final currencies = _currencyController.text
                              .split(',')
                              .map((e) => e.trim().toUpperCase())
                              .where((e) => e.isNotEmpty)
                              .toList();
                          setState(() {
                            selectedCurrencies = currencies;
                          });
                          provider.loadCurrencyDetails(currencies);
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16),
                
                // Selector de monedas disponibles
                Card(
                  child: ExpansionTile(
                    title: Text('Mostrar Monedas Disponibles'),
                    onExpansionChanged: (expanded) {
                      // Solo cargar las monedas cuando se expande por primera vez
                      if (expanded && provider.rates.isEmpty) {
                        provider.initialize();
                      }
                      setState(() {
                        isExpanded = expanded;
                      });
                    },
                    children: [
                      if (provider.isLoading)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        )
                      else
                        Container(
                          height: 200,
                          child: SingleChildScrollView(
                            child: Wrap(
                              spacing: 8,
                              children: provider.rates.keys.map((currency) {
                                return ActionChip(
                                  label: Text(currency),
                                  onPressed: () {
                                    if (_currencyController.text.isEmpty) {
                                      _currencyController.text = currency;
                                    } else if (!_currencyController.text.contains(currency)) {
                                      _currencyController.text += ',$currency';
                                    }
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // Botón para buscar detalles
                ElevatedButton.icon(
                  onPressed: _currencyController.text.isEmpty ? null : () {
                    final currencies = _currencyController.text
                        .split(',')
                        .map((e) => e.trim().toUpperCase())
                        .where((e) => e.isNotEmpty)
                        .toList();
                    setState(() {
                      selectedCurrencies = currencies;
                    });
                    provider.loadCurrencyDetails(currencies);
                  },
                  icon: Icon(Icons.search),
                  label: Text('Buscar Detalles'),
                ),
                SizedBox(height: 16),

                // Detalles de las monedas
                if (provider.isLoadingDetails)
                  Center(child: CircularProgressIndicator())
                else if (provider.error.isNotEmpty)
                  Center(child: Text(provider.error))
                else if (provider.currencyDetails.isEmpty && selectedCurrencies.isNotEmpty)
                  Center(child: Text('No se encontraron detalles para las monedas seleccionadas'))
                else if (provider.currencyDetails.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: provider.currencyDetails.length,
                      itemBuilder: (context, index) {
                        final currency = provider.currencyDetails.entries.elementAt(index);
                        final detail = currency.value;

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ExpansionTile(
                            title: Text('${detail.code} - ${detail.name}'),
                            subtitle: Text(detail.namePlural),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      title: Text('Símbolos'),
                                      subtitle: Text('${detail.symbol} (${detail.symbolNative})'),
                                    ),
                                    ListTile(
                                      title: Text('Tipo'),
                                      subtitle: Text(detail.type),
                                    ),
                                    ListTile(
                                      title: Text('Decimales'),
                                      subtitle: Text(detail.decimalDigits.toString()),
                                    ),
                                    ListTile(
                                      title: Text('Redondeo'),
                                      subtitle: Text(detail.rounding.toString()),
                                    ),
                                    if (detail.countries.isNotEmpty) ...[
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16.0, bottom: 8),
                                        child: Text(
                                          'Países',
                                          style: Theme.of(context).textTheme.titleMedium,
                                        ),
                                      ),
                                      Wrap(
                                        spacing: 8,
                                        children: detail.countries.map((country) => 
                                          Chip(
                                            label: Text(country),
                                          )
                                        ).toList(),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
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