part of '../../home_screen.dart';

class _AddDocumentButton extends StatelessWidget {
  const _AddDocumentButton();

  static const _height = 61.0;
  static const _expandedWidth = 178.0;
  static const _collapsedWidth = 61.0;
  static const _searchCloseSize = 48.0;
  static const _animationDuration = Duration(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FloatingActionsBloc, FloatingActionsState>(
      builder: (context, state) {
        return TweenAnimationBuilder<double>(
          tween: Tween(
            end: _targetWidth(state),
          ),
          duration: _animationDuration,
          curve: Curves.easeOutExpo,
          builder: (context, width, child) {
            return TweenAnimationBuilder<double>(
              tween: Tween(
                end: _targetHeight(state),
              ),
              duration: _animationDuration,
              curve: Curves.easeOutExpo,
              builder: (context, height, child) {
                return TweenAnimationBuilder<double>(
                  tween: Tween(
                    end: _activeProgress(state),
                  ),
                  duration: _animationDuration,
                  curve: Curves.easeOutExpo,
                  builder: (context, progress, child) {
                    return GlassButton.custom(
                      height: height,
                      width: width,
                      label: 'Add Document',
                      onTap: () {
                        context.read<FloatingActionsBloc>().add(
                          _eventFor(state),
                        );
                      },
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
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Opacity(
                            opacity: 1 - progress,
                            child: Padding(
                              padding: const Pad(
                                vertical: 19,
                                horizontal: 14,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox.square(
                                    dimension: 24,
                                    child: Icon(
                                      CupertinoIcons.add_circled_solid,
                                    ),
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
                          Opacity(
                            opacity: progress,
                            child: const Icon(
                              CupertinoIcons.xmark,
                              size: 29,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
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

  double _targetWidth(FloatingActionsState state) {
    if (state.isSearchOpen) return _searchCloseSize;
    if (state.isAddDocumentsPopupOpen) return _collapsedWidth;
    return _expandedWidth;
  }

  double _targetHeight(FloatingActionsState state) {
    if (state.isSearchOpen) return _searchCloseSize;
    return _height;
  }

  double _activeProgress(FloatingActionsState state) {
    return state.isSearchOpen || state.isAddDocumentsPopupOpen ? 1 : 0;
  }

  FloatingActionsEvent _eventFor(FloatingActionsState state) {
    if (state.isSearchOpen) return const FloatingActionsEvent.closeSearch();
    if (state.isAddDocumentsPopupOpen) {
      return const FloatingActionsEvent.closeAddDocumentsPopup();
    }

    return const FloatingActionsEvent.openAddDocumentsPopup();
  }

  double _lerp(double begin, double end, double progress) {
    return begin + (end - begin) * progress;
  }
}
