import 'package:flutter/material.dart';
import 'package:tapnode_test/gen/fonts.gen.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'app_text_styles.tailor.dart';

@TailorMixin()
class AppTextStyles extends ThemeExtension<AppTextStyles>
    with _$AppTextStylesTailorMixin {
  const AppTextStyles({
    required this.logo,
    required this.header1,
    required this.header2,
    required this.header3,
    required this.text1,
    required this.text2,
    required this.dropdownMenu,
    required this.dropdownMenu2,
  });

  @override
  final TextStyle logo;
  @override
  final TextStyle header1;
  @override
  final TextStyle header2;
  @override
  final TextStyle header3;
  @override
  final TextStyle text1;
  @override
  final TextStyle text2;
  @override
  final TextStyle dropdownMenu;
  @override
  final TextStyle dropdownMenu2;

  static const light = AppTextStyles(
    logo: TextStyle(
      fontFamily: FontFamily.inter,
      fontWeight: FontWeight.w800,
      fontSize: 18,
      height: 1.2,
      letterSpacing: 0,
    ),
    header1: TextStyle(
      fontFamily: FontFamily.inter,
      fontWeight: FontWeight.w700,
      fontSize: 20,
      height: 1.2,
      letterSpacing: 0,
    ),
    header2: TextStyle(
      fontFamily: FontFamily.inter,
      fontWeight: FontWeight.w700,
      fontSize: 16,
      height: 1,
      letterSpacing: 0,
    ),
    header3: TextStyle(
      fontFamily: FontFamily.inter,
      fontWeight: FontWeight.w700,
      fontSize: 14,
      height: 1.2,
      letterSpacing: 0,
    ),
    text1: TextStyle(
      fontFamily: FontFamily.inter,
      fontWeight: FontWeight.w400,
      fontSize: 15,
      height: 1.3,
      letterSpacing: 0,
    ),
    text2: TextStyle(
      fontFamily: FontFamily.inter,
      fontWeight: FontWeight.w400,
      fontSize: 11,
      height: 1.2,
      letterSpacing: 0,
    ),
    dropdownMenu: TextStyle(
      fontFamily: FontFamily.inter,
      fontWeight: FontWeight.w400,
      fontSize: 17,
      height: 20 / 17,
      letterSpacing: -0.43,
    ),
    dropdownMenu2: TextStyle(
      fontFamily: FontFamily.inter,
      fontWeight: FontWeight.w600,
      fontSize: 12,
      height: 18 / 12,
      letterSpacing: 0,
    ),
  );
}
