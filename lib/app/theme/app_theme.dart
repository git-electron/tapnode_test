import 'package:flutter/material.dart' hide Colors;

import '../../gen/fonts.gen.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

abstract final class AppTheme {
  static ThemeData get light {
    const colors = Colors.light;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: FontFamily.inter,
      scaffoldBackgroundColor: colors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors.brand,
        primary: colors.brand,
        error: colors.error,
        surface: colors.background,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.appBar,
        foregroundColor: colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      extensions: const [colors, Styles.light],
    );
  }
}
