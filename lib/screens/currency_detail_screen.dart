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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detalles de Monedas',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Información detallada de divisas',
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
                Icon(Icons.info_outline, size: 16),
                SizedBox(width: 4),
                Text(
                  'Details',
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
              // Header con stats
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
                      'Monedas',
                      selectedCurrencies.isEmpty ? '0' : selectedCurrencies.length.toString(),
                      Icons.currency_exchange,
                    ),
                    SizedBox(width: 16),
                    _buildStatBox(
                      'Disponibles',
                      provider.rates.length.toString(),
                      Icons.public,
                    ),
                    SizedBox(width: 16),
                    _buildStatBox(
                      'Estado',
                      provider.isLoadingDetails ? 'Cargando' : 'Listo',
                      Icons.update,
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Búsqueda de Monedas',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 16),
                      
                      // Card de búsqueda
                      Card(
                        elevation: 4,
                        shadowColor: Colors.black12,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: _currencyController,
                                decoration: InputDecoration(
                                  labelText: 'Monedas a consultar',
                                  hintText: 'EUR,USD,GBP',
                                  prefixIcon: Icon(Icons.search),
                                  helperText: 'Ingresa los códigos o selecciona de la lista disponible',
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () => _currencyController.clear(),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              
                              // Selector de monedas
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ExpansionTile(
                                  title: Row(
                                    children: [
                                      Icon(
                                        Icons.monetization_on_outlined,
                                        color: Theme.of(context).colorScheme.primary,
                                        size: 20,
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'Monedas Disponibles',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  children: [
                                    if (provider.isLoading)
                                      Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: CircularProgressIndicator(),
                                      )
                                    else
                                      Container(
                                        padding: EdgeInsets.all(16),
                                        constraints: BoxConstraints(maxHeight: 200),
                                        child: SingleChildScrollView(
                                          child: Wrap(
                                            spacing: 8,
                                            runSpacing: 8,
                                            children: provider.rates.keys.map((currency) {
                                              return FilterChip(
                                                label: Text(currency),
                                                selected: _currencyController.text.contains(currency),
                                                onSelected: (selected) {
                                                  if (selected) {
                                                    if (_currencyController.text.isEmpty) {
                                                      _currencyController.text = currency;
                                                    } else {
                                                      _currencyController.text += ',$currency';
                                                    }
                                                  }
                                                },
                                                avatar: Icon(
                                                  Icons.check_circle_outline,
                                                  size: 18,
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                  ],
                                  onExpansionChanged: (expanded) {
                                    if (expanded && provider.rates.isEmpty) {
                                      provider.initialize();
                                    }
                                    setState(() {
                                      isExpanded = expanded;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 24),
                      
                      // Botón de búsqueda
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
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
                      ),
                      
                      SizedBox(height: 24),
                      
                      // Resultados
                      if (provider.isLoadingDetails)
                        Center(
                          child: Column(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text('Cargando detalles...'),
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
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.error,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (provider.currencyDetails.isNotEmpty)
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
                            ...provider.currencyDetails.entries.map((entry) {
                              final detail = entry.value;
                              return Card(
                                margin: EdgeInsets.only(bottom: 12),
                                child: ExpansionTile(
                                  leading: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      detail.symbol,
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    '${detail.code} - ${detail.name}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    detail.namePlural,
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          _buildDetailRow(
                                            'Símbolos',
                                            '${detail.symbol} (${detail.symbolNative})',
                                            Icons.currency_exchange,
                                          ),
                                          _buildDetailRow(
                                            'Tipo',
                                            detail.type,
                                            Icons.category,
                                          ),
                                          _buildDetailRow(
                                            'Decimales',
                                            detail.decimalDigits.toString(),
                                            Icons.numbers,
                                          ),
                                          _buildDetailRow(
                                            'Redondeo',
                                            detail.rounding.toString(),
                                            Icons.roundabout_right,
                                          ),
                                          if (detail.countries.isNotEmpty) ...[
                                            SizedBox(height: 16),
                                            Text(
                                              'Países',
                                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Wrap(
                                              spacing: 8,
                                              runSpacing: 8,
                                              children: detail.countries.map((country) => 
                                                Chip(
                                                  avatar: Icon(
                                                    Icons.flag_outlined,
                                                    size: 18,
                                                  ),
                                                  label: Text(country),
                                                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
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
                            }).toList(),
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
              ],
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

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}