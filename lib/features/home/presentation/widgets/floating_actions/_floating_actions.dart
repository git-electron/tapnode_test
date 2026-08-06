part of '../../home_screen.dart';

class _FloatingActions extends StatelessWidget {
  const _FloatingActions();

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
      child: GlassContainer(
        useOwnLayer: true,
        settings: LiquidGlassSettings(blur: 0),
      ),
    );
  }
}
