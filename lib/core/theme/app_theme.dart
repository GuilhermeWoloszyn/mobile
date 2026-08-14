import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppThemeColors.light.fundoDefault,
    extensions: const [
      AppThemeColors.light,
    ],
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppThemeColors.light.botao,
      brightness: Brightness.light,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppThemeColors.light.barra,
      foregroundColor: AppThemeColors.light.fonteDefault,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppThemeColors.light.fundoBarraInferior,
      selectedItemColor: AppThemeColors.light.icones,
      unselectedItemColor: AppThemeColors.light.cinzaPrincipal,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppThemeColors.light.botao,
        foregroundColor: AppThemeColors.light.fonteDestaque2,
      ),
    ),
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppThemeColors.dark.fundoDefault,
    extensions: const [
      AppThemeColors.dark,
    ],
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppThemeColors.dark.botao,
      brightness: Brightness.dark,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppThemeColors.dark.barra,
      foregroundColor: AppThemeColors.dark.fonteDefault,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppThemeColors.dark.fundoBarraInferior,
      selectedItemColor: AppThemeColors.dark.icones,
      unselectedItemColor: AppThemeColors.dark.cinzaPrincipal,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppThemeColors.dark.botao,
        foregroundColor: AppThemeColors.dark.fonteDestaque2,
      ),
    ),
  );
}