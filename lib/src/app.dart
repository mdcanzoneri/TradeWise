import 'package:flutter/material.dart';
import 'package:tradewise/src/presentation/screens/home_screen.dart'; // Import the home screen

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TradeWise',
      theme: ThemeData(
        // Define the default brightness and colors.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true, // Enable Material 3 design
      ),
      home: const HomeScreen(), // Set the initial screen
      debugShowCheckedModeBanner: false, // Remove debug banner
    );
  }
}
