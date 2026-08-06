part of '../../home_screen.dart';

class _SearchButton extends StatefulWidget {
  const _SearchButton();

  @override
  State<_SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<_SearchButton> {
  static const _collapsedSize = 63.0;
  static const _expandedHeight = 48.0;
  static const _leftPadding = 11.0;
  static const _iconSize = 24.0;
  static const _iconTextGap = 8.0;
  static const _animationDuration = Duration(milliseconds: 500);

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
    return BlocListener<FloatingActionsBloc, FloatingActionsState>(
      listenWhen: (previous, current) => previous.isSearchOpen != current.isSearchOpen,
      listener: (context, state) {
        if (state.isSearchOpen) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            if (!context.read<FloatingActionsBloc>().state.isSearchOpen) {
              return;
            }
            _focusNode.requestFocus();
          });
        } else {
          _focusNode.unfocus();
        }
      },
      child: BlocListener<FloatingActionsBloc, FloatingActionsState>(
        listenWhen: (previous, current) => previous.searchText != current.searchText,
        listener: (context, state) {
          if (_controller.text == state.searchText) return;

          _controller.value = TextEditingValue(
            text: state.searchText,
            selection: TextSelection.collapsed(
              offset: state.searchText.length,
            ),
          );
        },
        child: BlocBuilder<FloatingActionsBloc, FloatingActionsState>(
          builder: (context, state) {
            return Expanded(
              child: IgnorePointer(
                ignoring: state.isAddDocumentsPopupOpen,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return TweenAnimationBuilder<double>(
                      tween: Tween(end: _targetProgress(state)),
                      duration: _animationDuration,
                      curve: Curves.easeOutExpo,
                      builder: (context, progress, child) {
                        final searchProgress = progress.clamp(0.0, 1.0);
                        final visibilityProgress = (progress + 1).clamp(
                          0.0,
                          1.0,
                        );
                        final width = _lerp(
                          _collapsedSize,
                          constraints.maxWidth,
                          searchProgress,
                        );
                        final height = _lerp(
                          _collapsedSize,
                          _expandedHeight,
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
                                onTap: () {
                                  if (state.isSearchOpen) {
                                    _focusNode.requestFocus();
                                    return;
                                  }

                                  context.read<FloatingActionsBloc>().add(
                                    const FloatingActionsEvent.openSearch(),
                                  );
                                },
                                shape: const LiquidRoundedRectangle(
                                  borderRadius: 100,
                                ),
                                interactionScale: .97,
                                stretch: .28,
                                resistance: .04,
                                glowColor: context.colors.white,
                                glowRadius: 1.2,
                                glowOpacity: .3,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: _lerp(
                                        _collapsedSize,
                                        _leftPadding + _iconSize,
                                        searchProgress,
                                      ),
                                      height: _collapsedSize,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: _leftPadding * searchProgress,
                                        ),
                                        child: Align(
                                          alignment: Alignment.lerp(
                                            Alignment.center,
                                            Alignment.centerLeft,
                                            searchProgress,
                                          )!,
                                          child: Icon(
                                            CupertinoIcons.search,
                                            size: _iconSize,
                                            color: context.colors.textPrimary,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: _iconTextGap * searchProgress,
                                    ),
                                    Expanded(
                                      child: Opacity(
                                        opacity: searchProgress,
                                        child: CupertinoTextField(
                                          controller: _controller,
                                          focusNode: _focusNode,
                                          placeholder: 'Search Documents',
                                          padding: EdgeInsets.zero,
                                          decoration: const BoxDecoration(),
                                          style: context.styles.text1.copyWith(
                                            color: context.colors.textPrimary,
                                          ),
                                          cursorColor: const Color(0xff0088FF),
                                          onChanged: (text) {
                                            context.read<FloatingActionsBloc>().add(
                                              FloatingActionsEvent.searchTextChanged(
                                                text,
                                              ),
                                            );
                                          },
                                          onEditingComplete: () {
                                            if (_controller.text.isNotEmpty) {
                                              _focusNode.unfocus();
                                              return;
                                            }

                                            context.read<FloatingActionsBloc>().add(
                                              const FloatingActionsEvent.closeSearch(),
                                            );
                                          },
                                          placeholderStyle: context.styles.text1.copyWith(
                                            color: context.colors.textSecondary.withValues(alpha: .35),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  double _targetProgress(FloatingActionsState state) {
    if (state.isAddDocumentsPopupOpen) return -1;
    if (state.isSearchOpen) return 1;
    return 0;
  }

  double _lerp(double begin, double end, double progress) {
    return begin + (end - begin) * progress;
  }
}
