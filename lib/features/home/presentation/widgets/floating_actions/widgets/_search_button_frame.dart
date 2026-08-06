part of '../../../home_screen.dart';

class _SearchButtonFrame extends StatelessWidget {
  const _SearchButtonFrame({
    required this.progress,
    required this.maxWidth,
    required this.onTap,
    required this.child,
  });

  final double progress;
  final double maxWidth;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final searchProgress = progress.clamp(0.0, 1.0);
    final visibilityProgress = (progress + 1).clamp(0.0, 1.0);
    final width = _searchButtonLerp(
      _SearchButton.collapsedSize,
      maxWidth,
      searchProgress,
    );
    final height = _searchButtonLerp(
      _SearchButton.collapsedSize,
      _SearchButton.expandedHeight,
      searchProgress,
    );

    return Opacity(
      opacity: visibilityProgress,
      child: Transform.scale(
        scale: _searchButtonLerp(.88, 1, visibilityProgress),
        alignment: Alignment.centerLeft,
        child: Align(
          alignment: Alignment.centerLeft,
          child: GlassButton.custom(
            height: height,
            width: width,
            label: 'Search',
            onTap: onTap,
            shape: const LiquidRoundedRectangle(borderRadius: 100),
            interactionScale: .97,
            stretch: .28,
            resistance: .04,
            glowColor: context.colors.white,
            glowRadius: 1.2,
            glowOpacity: .3,
            child: child,
          ),
        ),
      ),
    );
  }
}

double _searchButtonLerp(double begin, double end, double progress) {
  return begin + (end - begin) * progress;
}
