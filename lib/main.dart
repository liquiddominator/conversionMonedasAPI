import 'package:flutter/material.dart';
import 'package:monedas_api_project/provider/currency_provider.dart';
import 'package:monedas_api_project/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Definimos colores personalizados
  static const primaryNavy = Color(0xFF0A1172);
  static const deepBlue = Color(0xFF142396);
  static const royalBlue = Color(0xFF0052FF);
  static const lightBlue = Color(0xFF3D9BFF);
  static const surfaceBlue = Color(0xFF1A237E);
  static const cardBlue = Color(0xFF1E285A);
  
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
          brightness: Brightness.dark,
          colorScheme: ColorScheme.dark(
            primary: royalBlue,
            secondary: lightBlue,
            background: primaryNavy,
            surface: surfaceBlue,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onBackground: Colors.white,
            onSurface: Colors.white.withOpacity(0.87),
            error: Color(0xFFCF6679),
          ),
          scaffoldBackgroundColor: primaryNavy,
          cardColor: cardBlue,
          
          // Configuración de AppBar
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          
          // Configuración de Input
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: cardBlue,
            labelStyle: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              letterSpacing: 0.5,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: royalBlue.withOpacity(0.5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: royalBlue.withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: lightBlue, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
          
          // Configuración de Texto
          textTheme: TextTheme(
            bodyLarge: TextStyle(
              color: Colors.white.withOpacity(0.87),
              fontSize: 16,
              letterSpacing: 0.5,
            ),
            bodyMedium: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              letterSpacing: 0.25,
            ),
            titleLarge: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 28,
              letterSpacing: 0.5,
            ),
            titleMedium: TextStyle(
              color: Colors.white.withOpacity(0.87),
              fontSize: 20,
              letterSpacing: 0.15,
            ),
          ),
          
          // Configuración de Botón Elevado
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: royalBlue,
              foregroundColor: Colors.white,
              elevation: 4,
              shadowColor: royalBlue.withOpacity(0.4),
              minimumSize: Size(double.infinity, 56),
              padding: EdgeInsets.symmetric(horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ).copyWith(
              elevation: MaterialStateProperty.resolveWith<double>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.hovered))
                    return 8;
                  if (states.contains(MaterialState.pressed))
                    return 2;
                  return 4;
                },
              ),
            ),
          ),
          
          // Configuración de Botón Outline
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: lightBlue,
              minimumSize: Size(double.infinity, 56),
              side: BorderSide(color: lightBlue, width: 1.5),
              padding: EdgeInsets.symmetric(horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ).copyWith(
              side: MaterialStateProperty.resolveWith<BorderSide>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.hovered))
                    return BorderSide(color: royalBlue, width: 2);
                  return BorderSide(color: lightBlue, width: 1.5);
                },
              ),
            ),
          ),
          
          // Configuración de Card
          cardTheme: CardTheme(
            color: cardBlue,
            elevation: 8,
            shadowColor: Colors.black.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: royalBlue.withOpacity(0.1),
                width: 1,
              ),
            ),
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          ),
        ),
        home: HomeScreen(),
      ),
    );
  }
}