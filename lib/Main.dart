import 'package:flutter/material.dart';
import 'package:untitled1/views/ItineraryPage.dart';
import 'core/theme/app_theme.dart';
import 'views/HomePage.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      home: ItineraryPage(),
    );
  }
}