part of '../../home_screen.dart';

class _FloatingActions extends StatelessWidget {
  const _FloatingActions();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          const Positioned.fill(
            child: IgnorePointer(
              child: GlassContainer(
                useOwnLayer: true,
                settings: LiquidGlassSettings(blur: 0),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const Pad(all: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GlassButton.custom(
                      height: 63,
                      width: 63,
                      label: 'Search',
                      onTap: () {},
                      shape: const LiquidRoundedRectangle(borderRadius: 61 / 2),
                      interactionScale: .97,
                      stretch: .28,
                      resistance: .04,
                      glowColor: context.colors.white,
                      glowRadius: 1.2,
                      glowOpacity: .3,
                      child: const Icon(CupertinoIcons.search),
                    ),
                    GlassButton.custom(
                      height: 61,
                      label: 'Add Document',
                      onTap: () {},
                      shape: const LiquidRoundedRectangle(borderRadius: 100),
                      useOwnLayer: true,
                      settings: LiquidGlassSettings(
                        glassColor: context.colors.brand,
                        backerColor: context.colors.brand,
                        blur: 0,
                        thickness: 0,
                        refractiveIndex: 1,
                        chromaticAberration: 0,
                        lightIntensity: 0,
                        saturation: 1,
                        whitenGated: false,
                        shadow: const [],
                      ),
                      interactionScale: .97,
                      stretch: .28,
                      resistance: .04,
                      glowColor: context.colors.white,
                      glowRadius: 1.2,
                      glowOpacity: .1,
                      child: Padding(
                        padding: const Pad(vertical: 19, horizontal: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox.square(
                              dimension: 24,
                              child: Icon(CupertinoIcons.add_circled_solid),
                            ),
                            const Gap(8),
                            Text(
                              'Add Document',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.styles.header2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
