import 'package:flutter/material.dart';
import 'package:monedas_api_project/provider/currency_provider.dart';
import 'package:monedas_api_project/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final provider = CurrencyProvider();
        provider.initialize();
        return provider;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Conversor de Monedas',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: Color(0xFF1B3A57),
            secondary: Color(0xFF2E5984),
            background: Color(0xFF121212),
            surface: Color(0xFF1E1E1E),
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onBackground: Colors.white,
            onSurface: Colors.white,
          ),
          scaffoldBackgroundColor: Color(0xFF121212),
          cardColor: Color(0xFF1E1E1E),
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF1B3A57),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Color(0xFF2A2A2A),
            labelStyle: TextStyle(color: Colors.white70),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFF2E5984)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFF2E5984)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFF2E5984), width: 2),
            ),
          ),
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white70),
            titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            titleMedium: TextStyle(color: Colors.white),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2E5984),
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: Color(0xFF2E5984),
              minimumSize: Size(double.infinity, 56),
              side: BorderSide(color: Color(0xFF2E5984)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        home: HomeScreen(),
      ),
    );
  }
}