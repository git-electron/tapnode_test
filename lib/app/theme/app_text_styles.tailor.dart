// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_text_styles.dart';

// **************************************************************************
// TailorAnnotationsGenerator
// **************************************************************************

mixin _$AppTextStylesTailorMixin on ThemeExtension<AppTextStyles> {
  TextStyle get logo;
  TextStyle get header1;
  TextStyle get header2;
  TextStyle get header3;
  TextStyle get text1;
  TextStyle get text2;
  TextStyle get dropdownMenu;
  TextStyle get dropdownMenu2;

  @override
  AppTextStyles copyWith({
    TextStyle? logo,
    TextStyle? header1,
    TextStyle? header2,
    TextStyle? header3,
    TextStyle? text1,
    TextStyle? text2,
    TextStyle? dropdownMenu,
    TextStyle? dropdownMenu2,
  }) {
    return AppTextStyles(
      logo: logo ?? this.logo,
      header1: header1 ?? this.header1,
      header2: header2 ?? this.header2,
      header3: header3 ?? this.header3,
      text1: text1 ?? this.text1,
      text2: text2 ?? this.text2,
      dropdownMenu: dropdownMenu ?? this.dropdownMenu,
      dropdownMenu2: dropdownMenu2 ?? this.dropdownMenu2,
    );
  }

  @override
  AppTextStyles lerp(covariant ThemeExtension<AppTextStyles>? other, double t) {
    if (other is! AppTextStyles) return this as AppTextStyles;
    return AppTextStyles(
      logo: TextStyle.lerp(logo, other.logo, t)!,
      header1: TextStyle.lerp(header1, other.header1, t)!,
      header2: TextStyle.lerp(header2, other.header2, t)!,
      header3: TextStyle.lerp(header3, other.header3, t)!,
      text1: TextStyle.lerp(text1, other.text1, t)!,
      text2: TextStyle.lerp(text2, other.text2, t)!,
      dropdownMenu: TextStyle.lerp(dropdownMenu, other.dropdownMenu, t)!,
      dropdownMenu2: TextStyle.lerp(dropdownMenu2, other.dropdownMenu2, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppTextStyles &&
            const DeepCollectionEquality().equals(logo, other.logo) &&
            const DeepCollectionEquality().equals(header1, other.header1) &&
            const DeepCollectionEquality().equals(header2, other.header2) &&
            const DeepCollectionEquality().equals(header3, other.header3) &&
            const DeepCollectionEquality().equals(text1, other.text1) &&
            const DeepCollectionEquality().equals(text2, other.text2) &&
            const DeepCollectionEquality().equals(
              dropdownMenu,
              other.dropdownMenu,
            ) &&
            const DeepCollectionEquality().equals(
              dropdownMenu2,
              other.dropdownMenu2,
            ));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType.hashCode,
      const DeepCollectionEquality().hash(logo),
      const DeepCollectionEquality().hash(header1),
      const DeepCollectionEquality().hash(header2),
      const DeepCollectionEquality().hash(header3),
      const DeepCollectionEquality().hash(text1),
      const DeepCollectionEquality().hash(text2),
      const DeepCollectionEquality().hash(dropdownMenu),
      const DeepCollectionEquality().hash(dropdownMenu2),
    );
  }
}

extension AppTextStylesBuildContextProps on BuildContext {
  AppTextStyles get appTextStyles => Theme.of(this).extension<AppTextStyles>()!;
  TextStyle get logo => appTextStyles.logo;
  TextStyle get header1 => appTextStyles.header1;
  TextStyle get header2 => appTextStyles.header2;
  TextStyle get header3 => appTextStyles.header3;
  TextStyle get text1 => appTextStyles.text1;
  TextStyle get text2 => appTextStyles.text2;
  TextStyle get dropdownMenu => appTextStyles.dropdownMenu;
  TextStyle get dropdownMenu2 => appTextStyles.dropdownMenu2;
}
