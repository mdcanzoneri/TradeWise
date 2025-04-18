import 'package:flutter/material.dart';
import 'package:tradewise/src/presentation/screens/home_screen.dart'; // Import the home screen

// Define the custom color scheme using provided hex codes
final _lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFFF57C00),      // Construction Orange
  onPrimary: Colors.white,
  secondary: Color(0xFF00B0FF),    // Electric Blue (Accent)
  onSecondary: Colors.white,
  background: Color(0xFFE0E0E0),   // Light Gray (Base)
  onBackground: Color(0xFF424242), // Dark Gray (Base)
  surface: Colors.white,          // Default surface
  onSurface: Color(0xFF424242),   // Dark Gray (Base)
  error: Color(0xFFB00020),       // Standard error red
  onError: Colors.white,
);

// Define the custom text theme
final _textTheme = TextTheme(
  displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: _lightColorScheme.onBackground),
  titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _lightColorScheme.onBackground),
  titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: _lightColorScheme.onBackground),
  bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: _lightColorScheme.onBackground),
  bodyMedium: TextStyle(fontSize: 14, color: _lightColorScheme.onSurface.withOpacity(0.75)), // Slightly lighter than base text
  labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _lightColorScheme.onPrimary), // For buttons on primary bg
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TradeWise',
      theme: ThemeData(
        // Apply the custom themes
        colorScheme: _lightColorScheme,
        textTheme: _textTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: _lightColorScheme.primary, // Construction Orange BG
          foregroundColor: _lightColorScheme.onPrimary, // White text/icons on AppBar
          surfaceTintColor: _lightColorScheme.primary, // Match surface tint to BG
          elevation: 0, // No shadow
        ),
        useMaterial3: true, // Ensure Material 3 is enabled
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}