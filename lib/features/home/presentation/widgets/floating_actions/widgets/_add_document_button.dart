part of '../../../home_screen.dart';

class _AddDocumentButton extends StatelessWidget {
  const _AddDocumentButton();

  static const height = 61.0;
  static const expandedWidth = 178.0;
  static const collapsedWidth = 61.0;
  static const searchCloseSize = 48.0;
  static const animationDuration = Duration(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentsBloc, DocumentsState>(
      buildWhen: (previous, current) =>
          previous.selectionMode != current.selectionMode,
      builder: (context, documentsState) {
        return BlocBuilder<FloatingActionsBloc, FloatingActionsState>(
          builder: (context, state) {
            return _AddDocumentButtonAnimator(
              state: state,
              selectionMode: documentsState.selectionMode,
              onTap: () {
                if (documentsState.selectionMode) return;
                _handleTap(context, state);
              },
            );
          },
        );
      },
    );
  }

  void _handleTap(BuildContext context, FloatingActionsState state) {
    if (state.isSearchOpen) {
      context.read<DocumentsBloc>().add(
        const DocumentsEvent.searchChanged(''),
      );
      context.read<FloatingActionsBloc>().add(
        const FloatingActionsEvent.closeSearch(),
      );
      return;
    }
    if (state.isAddDocumentsPopupOpen) {
      context.read<FloatingActionsBloc>().add(
        const FloatingActionsEvent.closeAddDocumentsPopup(),
      );
      return;
    }

    context.read<FloatingActionsBloc>().add(
      const FloatingActionsEvent.openAddDocumentsPopup(),
    );
  }
}

class _AddDocumentButtonAnimator extends StatelessWidget {
  const _AddDocumentButtonAnimator({
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
      tween: Tween(end: _targetWidth(state)),
      duration: _AddDocumentButton.animationDuration,
      curve: Curves.easeOutExpo,
      builder: (context, width, child) {
        return TweenAnimationBuilder<double>(
          tween: Tween(end: _targetHeight(state)),
          duration: _AddDocumentButton.animationDuration,
          curve: Curves.easeOutExpo,
          builder: (context, height, child) {
            return TweenAnimationBuilder<double>(
              tween: Tween(end: _activeProgress(state)),
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

  double _targetWidth(FloatingActionsState state) {
    if (selectionMode) return _AddDocumentButton.collapsedWidth;
    if (state.isSearchOpen) return _AddDocumentButton.searchCloseSize;
    if (state.isAddDocumentsPopupOpen) return _AddDocumentButton.collapsedWidth;
    return _AddDocumentButton.expandedWidth;
  }

  double _targetHeight(FloatingActionsState state) {
    if (selectionMode) return _AddDocumentButton.collapsedWidth;
    if (state.isSearchOpen) return _AddDocumentButton.searchCloseSize;
    return _AddDocumentButton.height;
  }

  double _activeProgress(FloatingActionsState state) {
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
      glowOpacity: _addDocumentLerp(.1, .3, progress),
      child: _AddDocumentButtonContent(
        progress: progress,
        selectionMode: selectionMode,
      ),
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
}

class _AddDocumentButtonContent extends StatelessWidget {
  const _AddDocumentButtonContent({
    required this.progress,
    required this.selectionMode,
  });

  final double progress;
  final bool selectionMode;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: 1 - progress,
          child: const _AddDocumentExpandedContent(),
        ),
        Opacity(
          opacity: progress,
          child: selectionMode
              ? const _AddDocumentShareIcon()
              : const _AddDocumentCloseIcon(),
        ),
      ],
    );
  }
}

class _AddDocumentExpandedContent extends StatelessWidget {
  const _AddDocumentExpandedContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}

class _AddDocumentCloseIcon extends StatelessWidget {
  const _AddDocumentCloseIcon();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      CupertinoIcons.xmark,
      size: 29,
    );
  }
}

class _AddDocumentShareIcon extends StatelessWidget {
  const _AddDocumentShareIcon();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      CupertinoIcons.share,
      size: 29,
    );
  }
}

double _addDocumentLerp(double begin, double end, double progress) {
  return begin + (end - begin) * progress;
}
