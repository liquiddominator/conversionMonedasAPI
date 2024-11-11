import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monedas_api_project/provider/currency_provider.dart';
import 'package:monedas_api_project/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Colores personalizados
  static const primaryNavy = Color(0xFF1A237E);     // Azul principal
  static const deepBlue = Color(0xFF283593);        // Azul medio
  static const royalBlue = Color(0xFF1565C0);       // Azul brillante
  static const lightBlue = Color(0xFF42A5F5);       // Azul claro
  static const surfaceBlue = Color(0xFFFFFFFF);     // Blanco para superficies
  static const cardBlue = Color(0xFFF5F9FF);        // Azul muy claro para cards
  static const headerLight = Color(0xFF2C3E87);     // Azul para header superior
  static const headerDark = Color(0xFF1A237E);      // Azul para header inferior
  
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
          brightness: Brightness.light,
          colorScheme: ColorScheme.light(
            primary: royalBlue,
            secondary: lightBlue,
            background: Colors.white,
            surface: surfaceBlue,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onBackground: deepBlue,
            onSurface: deepBlue.withOpacity(0.87),
            error: Color(0xFFB00020),
          ),
          scaffoldBackgroundColor: Colors.white,
          cardColor: cardBlue,
          
          // Configuración mejorada de AppBar
          appBarTheme: AppBarTheme(
            backgroundColor: headerLight,
            foregroundColor: Colors.white,
            elevation: 0,
            toolbarHeight: 140, // Altura aumentada para el header
            titleSpacing: 0,
            centerTitle: false,
            titleTextStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              height: 1.2,
            ),
            iconTheme: IconThemeData(
              color: Colors.white,
              size: 24,
            ),
            actionsIconTheme: IconThemeData(
              color: Colors.white,
              size: 24,
            ),
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          
          // Configuración de Input
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            labelStyle: TextStyle(
              color: deepBlue.withOpacity(0.7),
              fontSize: 16,
              letterSpacing: 0.5,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: royalBlue.withOpacity(0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: royalBlue.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: royalBlue, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            prefixIconColor: royalBlue,
            suffixIconColor: royalBlue,
            floatingLabelStyle: TextStyle(
              color: royalBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          // Configuración de Texto mejorada
          textTheme: TextTheme(
            bodyLarge: TextStyle(
              color: deepBlue.withOpacity(0.87),
              fontSize: 16,
              letterSpacing: 0.5,
              height: 1.5,
            ),
            bodyMedium: TextStyle(
              color: deepBlue.withOpacity(0.7),
              fontSize: 14,
              letterSpacing: 0.25,
              height: 1.4,
            ),
            titleLarge: TextStyle(
              color: primaryNavy,
              fontWeight: FontWeight.bold,
              fontSize: 28,
              letterSpacing: 0.5,
              height: 1.3,
            ),
            titleMedium: TextStyle(
              color: deepBlue,
              fontSize: 20,
              letterSpacing: 0.15,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
            labelLarge: TextStyle(
              color: Colors.white,
              fontSize: 14,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          // Configuración de Botón Elevado mejorada
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
                  if (states.contains(MaterialState.hovered)) return 8;
                  if (states.contains(MaterialState.pressed)) return 2;
                  return 4;
                },
              ),
            ),
          ),
          
          // Configuración de Botón Outline mejorada
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: royalBlue,
              backgroundColor: Colors.white,
              minimumSize: Size(double.infinity, 56),
              side: BorderSide(color: royalBlue, width: 1.5),
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
                    return BorderSide(color: primaryNavy, width: 2);
                  return BorderSide(color: royalBlue, width: 1.5);
                },
              ),
            ),
          ),
          
          // Configuración de Card mejorada
          cardTheme: CardTheme(
            color: cardBlue,
            elevation: 4,
            shadowColor: deepBlue.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: royalBlue.withOpacity(0.05),
                width: 1,
              ),
            ),
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            clipBehavior: Clip.antiAlias,
          ),
          
          // Configuración de Divider
          dividerTheme: DividerThemeData(
            color: deepBlue.withOpacity(0.1),
            thickness: 1,
            space: 24,
          ),
        ),
        home: HomeScreen(),
      ),
    );
  }
}