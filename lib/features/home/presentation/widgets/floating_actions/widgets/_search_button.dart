part of '../../../home_screen.dart';

class _SearchButton extends StatefulWidget {
  const _SearchButton();

  static const collapsedSize = 63.0;
  static const expandedHeight = 48.0;
  static const leftPadding = 11.0;
  static const iconSize = 24.0;
  static const iconTextGap = 8.0;
  static const animationDuration = Duration(milliseconds: 500);

  @override
  State<_SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<_SearchButton> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentsBloc, DocumentsState>(
      buildWhen: (previous, current) =>
          previous.selectionMode != current.selectionMode ||
          previous.searchQuery != current.searchQuery,
      builder: (context, documentsState) {
        return BlocListener<FloatingActionsBloc, FloatingActionsState>(
          listenWhen: (previous, current) =>
              previous.isSearchOpen != current.isSearchOpen,
          listener: _handleSearchOpenChanged,
          child: BlocListener<DocumentsBloc, DocumentsState>(
            listenWhen: (previous, current) =>
                previous.searchQuery != current.searchQuery,
            listener: _syncControllerText,
            child: BlocBuilder<FloatingActionsBloc, FloatingActionsState>(
              builder: (context, state) {
                return _SearchButtonLayout(
                  state: state,
                  selectionMode: documentsState.selectionMode,
                  controller: _controller,
                  focusNode: _focusNode,
                  onTap: () => _handleTap(context, state),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _handleSearchOpenChanged(
    BuildContext context,
    FloatingActionsState state,
  ) {
    if (state.isSearchOpen) {
      if (!state.shouldFocusSearchOnOpen) return;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final state = context.read<FloatingActionsBloc>().state;
        if (!state.isSearchOpen || !state.shouldFocusSearchOnOpen) return;
        _focusNode.requestFocus();
      });
      return;
    }

    _focusNode.unfocus();
  }

  void _syncControllerText(
    BuildContext context,
    DocumentsState state,
  ) {
    if (_controller.text == state.searchQuery) return;

    _controller.value = TextEditingValue(
      text: state.searchQuery,
      selection: TextSelection.collapsed(offset: state.searchQuery.length),
    );
  }

  void _handleTap(BuildContext context, FloatingActionsState state) {
    if (state.isSearchOpen) {
      _focusNode.requestFocus();
      return;
    }

    context.read<FloatingActionsBloc>().add(
      const FloatingActionsEvent.openSearch(),
    );
  }
}

class _SearchButtonLayout extends StatelessWidget {
  const _SearchButtonLayout({
    required this.state,
    required this.selectionMode,
    required this.controller,
    required this.focusNode,
    required this.onTap,
  });

  final FloatingActionsState state;
  final bool selectionMode;
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: IgnorePointer(
        ignoring: state.isAddDocumentsPopupOpen,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return TweenAnimationBuilder<double>(
              tween: Tween(end: _targetProgress(state)),
              duration: _SearchButton.animationDuration,
              curve: Curves.easeOutExpo,
              builder: (context, progress, child) {
                return _AnimatedSearchButtonFrame(
                  progress: progress,
                  maxWidth: constraints.maxWidth,
                  onTap: selectionMode
                      ? () {
                          context.read<DocumentsBloc>().add(
                            const DocumentsEvent.selectedDeleteRequested(),
                          );
                        }
                      : onTap,
                  child: _SearchButtonContent(
                    progress: progress.clamp(0.0, 1.0),
                    selectionMode: selectionMode,
                    controller: controller,
                    focusNode: focusNode,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  double _targetProgress(FloatingActionsState state) {
    if (state.isAddDocumentsPopupOpen) return -1;
    if (selectionMode) return 0;
    if (state.isSearchOpen) return 1;
    return 0;
  }
}

class _AnimatedSearchButtonFrame extends StatelessWidget {
  const _AnimatedSearchButtonFrame({
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
    final width = _lerp(
      _SearchButton.collapsedSize,
      maxWidth,
      searchProgress,
    );
    final height = _lerp(
      _SearchButton.collapsedSize,
      _SearchButton.expandedHeight,
      searchProgress,
    );

    return Opacity(
      opacity: visibilityProgress,
      child: Transform.scale(
        scale: _lerp(.88, 1, visibilityProgress),
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

class _SearchButtonContent extends StatelessWidget {
  const _SearchButtonContent({
    required this.progress,
    required this.selectionMode,
    required this.controller,
    required this.focusNode,
  });

  final double progress;
  final bool selectionMode;
  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SearchButtonIcon(
          progress: progress,
          selectionMode: selectionMode,
        ),
        SizedBox(width: _SearchButton.iconTextGap * progress),
        Expanded(
          child: Opacity(
            opacity: progress,
            child: _SearchTextField(
              controller: controller,
              focusNode: focusNode,
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchButtonIcon extends StatelessWidget {
  const _SearchButtonIcon({
    required this.progress,
    required this.selectionMode,
  });

  final double progress;
  final bool selectionMode;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _lerp(
        _SearchButton.collapsedSize,
        _SearchButton.leftPadding + _SearchButton.iconSize,
        progress,
      ),
      height: _SearchButton.collapsedSize,
      child: Padding(
        padding: EdgeInsets.only(left: _SearchButton.leftPadding * progress),
        child: Align(
          alignment: Alignment.lerp(
            Alignment.center,
            Alignment.centerLeft,
            progress,
          )!,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: Icon(
              selectionMode ? CupertinoIcons.delete : CupertinoIcons.search,
              key: ValueKey(selectionMode),
              size: _SearchButton.iconSize,
              color: selectionMode
                  ? context.colors.error
                  : context.colors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchTextField extends StatelessWidget {
  const _SearchTextField({
    required this.controller,
    required this.focusNode,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      focusNode: focusNode,
      placeholder: 'Search Documents',
      autocorrect: false,
      enableSuggestions: false,
      smartDashesType: SmartDashesType.disabled,
      smartQuotesType: SmartQuotesType.disabled,
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(),
      style: context.styles.text1.copyWith(
        color: context.colors.textPrimary,
      ),
      cursorColor: const Color(0xff0088FF),
      onChanged: (text) {
        context.read<DocumentsBloc>().add(
          DocumentsEvent.searchChanged(text),
        );
      },
      onTapOutside: (event) {
        focusNode.unfocus();
      },
      onEditingComplete: () {
        if (controller.text.isNotEmpty) {
          focusNode.unfocus();
          return;
        }

        context.read<FloatingActionsBloc>().add(
          const FloatingActionsEvent.closeSearch(),
        );
      },
      placeholderStyle: context.styles.text1.copyWith(
        color: context.colors.textSecondary.withValues(alpha: .35),
      ),
    );
  }
}

double _lerp(double begin, double end, double progress) {
  return begin + (end - begin) * progress;
}
