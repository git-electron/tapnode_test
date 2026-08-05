// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_colors.dart';

// **************************************************************************
// TailorAnnotationsGenerator
// **************************************************************************

mixin _$AppColorsTailorMixin on ThemeExtension<AppColors> {
  Color get white;
  Color get background;
  Color get appBar;
  Color get brand;
  LinearGradient get brandGradient;
  Color get activeButton;
  Color get inactiveButton;
  Color get error;
  Color get textPrimary;
  Color get textSecondary;

  @override
  AppColors copyWith({
    Color? white,
    Color? background,
    Color? appBar,
    Color? brand,
    LinearGradient? brandGradient,
    Color? activeButton,
    Color? inactiveButton,
    Color? error,
    Color? textPrimary,
    Color? textSecondary,
  }) {
    return AppColors(
      white: white ?? this.white,
      background: background ?? this.background,
      appBar: appBar ?? this.appBar,
      brand: brand ?? this.brand,
      brandGradient: brandGradient ?? this.brandGradient,
      activeButton: activeButton ?? this.activeButton,
      inactiveButton: inactiveButton ?? this.inactiveButton,
      error: error ?? this.error,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
    );
  }

  @override
  AppColors lerp(covariant ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this as AppColors;
    return AppColors(
      white: Color.lerp(white, other.white, t)!,
      background: Color.lerp(background, other.background, t)!,
      appBar: Color.lerp(appBar, other.appBar, t)!,
      brand: Color.lerp(brand, other.brand, t)!,
      brandGradient: t < 0.5 ? brandGradient : other.brandGradient,
      activeButton: Color.lerp(activeButton, other.activeButton, t)!,
      inactiveButton: Color.lerp(inactiveButton, other.inactiveButton, t)!,
      error: Color.lerp(error, other.error, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppColors &&
            const DeepCollectionEquality().equals(white, other.white) &&
            const DeepCollectionEquality().equals(
              background,
              other.background,
            ) &&
            const DeepCollectionEquality().equals(appBar, other.appBar) &&
            const DeepCollectionEquality().equals(brand, other.brand) &&
            const DeepCollectionEquality().equals(
              brandGradient,
              other.brandGradient,
            ) &&
            const DeepCollectionEquality().equals(
              activeButton,
              other.activeButton,
            ) &&
            const DeepCollectionEquality().equals(
              inactiveButton,
              other.inactiveButton,
            ) &&
            const DeepCollectionEquality().equals(error, other.error) &&
            const DeepCollectionEquality().equals(
              textPrimary,
              other.textPrimary,
            ) &&
            const DeepCollectionEquality().equals(
              textSecondary,
              other.textSecondary,
            ));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType.hashCode,
      const DeepCollectionEquality().hash(white),
      const DeepCollectionEquality().hash(background),
      const DeepCollectionEquality().hash(appBar),
      const DeepCollectionEquality().hash(brand),
      const DeepCollectionEquality().hash(brandGradient),
      const DeepCollectionEquality().hash(activeButton),
      const DeepCollectionEquality().hash(inactiveButton),
      const DeepCollectionEquality().hash(error),
      const DeepCollectionEquality().hash(textPrimary),
      const DeepCollectionEquality().hash(textSecondary),
    );
  }
}

extension AppColorsBuildContextProps on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
  Color get white => appColors.white;
  Color get background => appColors.background;
  Color get appBar => appColors.appBar;
  Color get brand => appColors.brand;
  LinearGradient get brandGradient => appColors.brandGradient;
  Color get activeButton => appColors.activeButton;
  Color get inactiveButton => appColors.inactiveButton;
  Color get error => appColors.error;
  Color get textPrimary => appColors.textPrimary;
  Color get textSecondary => appColors.textSecondary;
}
