import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'app_colors.tailor.dart';

@TailorMixin()
class Colors extends ThemeExtension<Colors> with _$ColorsTailorMixin {
  const Colors({
    required this.white,
    required this.background,
    required this.appBar,
    required this.brand,
    required this.brandGradient,
    required this.activeButton,
    required this.inactiveButton,
    required this.error,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  final Color white;
  @override
  final Color background;
  @override
  final Color appBar;
  @override
  final Color brand;
  @override
  final LinearGradient brandGradient;
  @override
  final Color activeButton;
  @override
  final Color inactiveButton;
  @override
  final Color error;
  @override
  final Color textPrimary;
  @override
  final Color textSecondary;

  static const light = Colors(
    white: Color(0xFFFFFFFF),
    background: Color(0xFFF0F0F0),
    appBar: Color(0xFF242424),
    brand: Color(0xFF6AD528),
    brandGradient: LinearGradient(
      colors: [Color(0xFF87E64C), Color(0xFFA1FF67)],
    ),
    activeButton: Color(0xFFFFFFFF),
    inactiveButton: Color(0x1F767680),
    error: Color(0xFFFF383C),
    textPrimary: Color(0xFF191919),
    textSecondary: Color(0xFF929292),
  );
}
