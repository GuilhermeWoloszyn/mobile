import 'package:flutter/material.dart';
import 'app_colors.dart';

extension ThemeExtensions on BuildContext {
  AppThemeColors get appColors {
    final colors = Theme.of(this).extension<AppThemeColors>();

    if (colors == null) {
      throw FlutterError(
        'AppThemeColors não foi registrado no ThemeData. '
            'Verifique se o MaterialApp está usando theme: AppTheme.light '
            'e darkTheme: AppTheme.dark.',
      );
    }

    return colors;
  }
}