import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../app/theme/app_colors.dart';
import '../app/theme/app_text_styles.dart';

class AppGlassButton extends StatelessWidget {
  const AppGlassButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.width,
    super.key,
  });

  final Widget icon;
  final String label;
  final VoidCallback onTap;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return GlassButton.custom(
      height: 56,
      width: width,
      label: label,
      onTap: onTap,
      useOwnLayer: true,

      shape: const LiquidRoundedRectangle(borderRadius: 28),
      interactionScale: .97,
      stretch: .28,
      resistance: .04,
      glowColor: context.colors.white,
      glowRadius: 1.2,
      glowOpacity: .3,
      settings: LiquidGlassSettings(
        blur: 14,
        thickness: 28,
        refractiveIndex: 1.14,
        chromaticAberration: .18,
        lightIntensity: 1.4,
        saturation: 1.2,
        whitenStrength: .35,
        whitenGated: false,

        shadow: [
          BoxShadow(
            color: context.colors.white.withValues(alpha: .72),
            blurRadius: 34,
            spreadRadius: 3,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: context.colors.black.withValues(alpha: .08),
            blurRadius: 18,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const Pad(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: 24,
              child: icon,
            ),
            const Gap(8),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.styles.header2,
            ),
          ],
        ),
      ),
    );
  }
}
