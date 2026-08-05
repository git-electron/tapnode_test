import 'package:flutter/material.dart';
import 'package:tapnode_test/app/theme/app_colors.dart';
import 'package:tapnode_test/app/theme/app_text_styles.dart';
import 'package:tapnode_test/gen/fonts.gen.dart';

abstract final class AppTheme {
  static ThemeData get light {
    const colors = AppColors.light;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: FontFamily.inter,
      scaffoldBackgroundColor: colors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors.brand,
        brightness: Brightness.light,
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
      extensions: const [colors, AppTextStyles.light],
    );
  }
}
