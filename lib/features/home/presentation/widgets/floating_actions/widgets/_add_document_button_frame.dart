part of '../../../home_screen.dart';

class _AddDocumentButtonFrame extends StatelessWidget {
  const _AddDocumentButtonFrame({
    required this.state,
    required this.selectionMode,
    required this.onTap,
  });

  final FloatingActionsState state;
  final bool selectionMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: _targetWidth()),
      duration: _AddDocumentButton.animationDuration,
      curve: Curves.easeOutExpo,
      builder: (context, width, child) {
        return TweenAnimationBuilder<double>(
          tween: Tween(end: _targetHeight()),
          duration: _AddDocumentButton.animationDuration,
          curve: Curves.easeOutExpo,
          builder: (context, height, child) {
            return TweenAnimationBuilder<double>(
              tween: Tween(end: _activeProgress()),
              duration: _AddDocumentButton.animationDuration,
              curve: Curves.easeOutExpo,
              builder: (context, progress, child) {
                return _AddDocumentGlassButton(
                  width: width,
                  height: height,
                  progress: progress,
                  selectionMode: selectionMode,
                  onTap: onTap,
                );
              },
            );
          },
        );
      },
    );
  }

  double _targetWidth() {
    if (selectionMode) return _AddDocumentButton.collapsedWidth;
    if (state.isSearchOpen) return _AddDocumentButton.searchCloseSize;
    if (state.isAddDocumentsPopupOpen) return _AddDocumentButton.collapsedWidth;
    return _AddDocumentButton.expandedWidth;
  }

  double _targetHeight() {
    if (selectionMode) return _AddDocumentButton.collapsedWidth;
    if (state.isSearchOpen) return _AddDocumentButton.searchCloseSize;
    return _AddDocumentButton.height;
  }

  double _activeProgress() {
    if (selectionMode) return 1;
    return state.isSearchOpen || state.isAddDocumentsPopupOpen ? 1 : 0;
  }
}

class _AddDocumentGlassButton extends StatelessWidget {
  const _AddDocumentGlassButton({
    required this.width,
    required this.height,
    required this.progress,
    required this.selectionMode,
    required this.onTap,
  });

  final double width;
  final double height;
  final double progress;
  final bool selectionMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlassButton.custom(
      height: height,
      width: width,
      label: 'Add Document',
      onTap: onTap,
      shape: const LiquidRoundedRectangle(borderRadius: 100),
      useOwnLayer: true,
      settings: LiquidGlassSettings.lerp(
        _solidSettings(context),
        const LiquidGlassSettings(),
        progress,
      ),
      interactionScale: .97,
      stretch: .28,
      resistance: .04,
      glowColor: context.colors.white,
      glowRadius: 1.2,
      glowOpacity: _lerp(.1, .3, progress),
      child: _AddDocumentButtonContent(
        progress: progress,
        selectionMode: selectionMode,
      ),
    );
  }

  double _lerp(double begin, double end, double progress) {
    return begin + (end - begin) * progress;
  }

  LiquidGlassSettings _solidSettings(BuildContext context) {
    return LiquidGlassSettings(
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
    );
  }
}
