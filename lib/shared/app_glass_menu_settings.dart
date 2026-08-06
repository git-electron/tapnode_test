import 'package:flutter/cupertino.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../app/theme/app_colors.dart';

LiquidGlassSettings appGlassMenuSettings(BuildContext context) {
  return LiquidGlassSettings(
    glassColor: const Color(0xF2FFFFFF),
    backerColor: const Color(0xCCFFFFFF),
    blur: 18,
    thickness: 28,
    whitenStrength: .75,
    whitenGated: false,
    shadow: [
      const BoxShadow(
        color: Color(0x80FFFFFF),
        blurRadius: 44,
        spreadRadius: 8,
        offset: Offset(0, 18),
      ),
      BoxShadow(
        color: context.colors.black.withValues(alpha: .08),
        blurRadius: 18,
        spreadRadius: 2,
        offset: const Offset(0, 4),
      ),
    ],
  );
}
