import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors;

import '../../gen/fonts.gen.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'system_ui_overlay.dart';

abstract final class AppTheme {
  static CupertinoThemeData get light {
    const colors = Colors.light;

    return CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: colors.brand,
      scaffoldBackgroundColor: colors.background,
      barBackgroundColor: colors.appBar,
      primaryContrastingColor: colors.white,
      textTheme: CupertinoTextThemeData(
        primaryColor: colors.textPrimary,
        textStyle: TextStyle(
          fontFamily: FontFamily.inter,
          color: colors.textPrimary,
          fontSize: 17,
          letterSpacing: 0,
        ),
        navTitleTextStyle: TextStyle(
          fontFamily: FontFamily.inter,
          color: colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
      ),
    );
  }

  static ThemeData get materialLight {
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
        systemOverlayStyle: appSystemUiOverlayStyle,
      ),
      extensions: const [colors, Styles.light],
    );
  }
}
