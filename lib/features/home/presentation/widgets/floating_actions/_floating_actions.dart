part of '../../home_screen.dart';

class _FloatingActions extends StatelessWidget {
  const _FloatingActions();

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
      child: Stack(
        children: [
          Positioned.fill(
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
                padding: Pad(all: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SearchButton(),
                    _AddDocumentButton(),
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
