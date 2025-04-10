import 'package:flutter/material.dart';
import 'package:tradewise/constants/colors.dart';
import 'package:tradewise/screens/recording_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TradeWise',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.constructionOrange,
          primary: AppColors.constructionOrange,
          secondary: AppColors.electricBlue,
        ),
        useMaterial3: true,
      ),
      home: const RecordingScreen(),
    );
  }
}
