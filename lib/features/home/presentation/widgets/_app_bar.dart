part of '../home_screen.dart';

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.colors.appBar,
      child: const SafeArea(
        bottom: false,
        child: SizedBox(
          height: 66,
          child: Padding(
            padding: Pad(
              top: 12,
              left: 18,
              right: 16,
              bottom: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _AppBarLeading(),
                Row(
                  spacing: 10,
                  children: [
                    // TODO: remove
                    _DeleteAllDocumentsButton(),
                    _DropdownMenuButton(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBarLeading extends StatelessWidget {
  const _AppBarLeading();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentsBloc, DocumentsState>(
      buildWhen: (previous, current) =>
          previous.selectionMode != current.selectionMode ||
          previous.selectedIds != current.selectedIds ||
          previous.documents != current.documents,
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          layoutBuilder: (currentChild, previousChildren) {
            return Stack(
              alignment: Alignment.centerLeft,
              children: [
                ...previousChildren,
                ?currentChild,
              ],
            );
          },
          transitionBuilder: (child, animation) {
            return Align(
              alignment: Alignment.centerLeft,
              widthFactor: 1,
              child: FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  alignment: Alignment.centerLeft,
                  scale: Tween<double>(begin: .92, end: 1).animate(animation),
                  child: child,
                ),
              ),
            );
          },
          child: state.selectionMode
              ? _SelectAllButton(
                  key: const ValueKey('select-all-button'),
                  state: state,
                )
              : const _Logo(key: ValueKey('logo')),
        );
      },
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Assets.images.logo.image(
          fit: BoxFit.fitHeight,
          height: 38,
          width: 38,
        ),
        Text(
          'Signica',
          style: context.styles.logo.copyWith(
            color: context.colors.white,
          ),
        ),
      ],
    );
  }
}

class _SelectAllButton extends StatelessWidget {
  const _SelectAllButton({
    required this.state,
    super.key,
  });

  final DocumentsState state;

  static const _height = 38.0;
  static const _horizontalPadding = 13.0;
  static const _duration = Duration(milliseconds: 220);
  static const _textDuration = Duration(milliseconds: 160);

  bool get _hasVisibleDocuments => state.documents.isNotEmpty;

  bool get _areAllVisibleDocumentsSelected {
    return _hasVisibleDocuments &&
        state.documents.every(
          (document) => state.selectedIds.contains(document.id),
        );
  }

  String get _title {
    if (_areAllVisibleDocumentsSelected) {
      return 'Deselect All (${state.selectedIds.length})';
    }

    return 'Select All';
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = context.styles.header3.copyWith(
      color: context.colors.white,
    );
    final targetWidth = _buttonWidth(
      context: context,
      title: _title,
      textStyle: textStyle,
    );

    return TweenAnimationBuilder<double>(
      tween: Tween(end: targetWidth),
      duration: _duration,
      curve: Curves.easeOutCubic,
      builder: (context, width, child) {
        return Tappable(
          scale: .97,
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutCubic,
          onTap: () {
            context.read<DocumentsBloc>().add(
              _areAllVisibleDocumentsSelected
                  ? const DocumentsEvent.deselectAll()
                  : const DocumentsEvent.selectAll(),
            );
          },
          child: SizedBox(
            height: _height,
            width: width,
            child: GlassContainer(
              useOwnLayer: true,
              settings: const LiquidGlassSettings(),
              shape: const LiquidRoundedRectangle(borderRadius: 15.2),
              child: Padding(
                padding: const Pad(horizontal: _horizontalPadding),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ClipRect(
                    child: SizedBox(
                      width: width - _horizontalPadding * 2,
                      child: AnimatedSwitcher(
                        duration: _textDuration,
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        layoutBuilder: (currentChild, previousChildren) {
                          return Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              ...previousChildren,
                              ?currentChild,
                            ],
                          );
                        },
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, .12),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: Text(
                          _title,
                          key: ValueKey(_title),
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.visible,
                          style: textStyle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double _buttonWidth({
    required BuildContext context,
    required String title,
    required TextStyle textStyle,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(text: title, style: textStyle),
      maxLines: 1,
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();

    return textPainter.width + _horizontalPadding * 2;
  }
}

// TODO: remove
class _DeleteAllDocumentsButton extends StatelessWidget {
  const _DeleteAllDocumentsButton();

  @override
  Widget build(BuildContext context) {
    return GlassIconButton(
      size: 38,
      borderRadius: 15.2,
      useOwnLayer: true,
      settings: const LiquidGlassSettings(),
      shape: GlassIconButtonShape.roundedSquare,
      icon: Icon(
        CupertinoIcons.trash,
        color: context.colors.white,
        size: 19.55,
      ),
      onPressed: () {
        context.read<DocumentsBloc>().add(
          const DocumentsEvent.deleteAllRequested(),
        );
      },
    );
  }
}

class _DropdownMenuButton extends StatefulWidget {
  const _DropdownMenuButton();

  @override
  State<_DropdownMenuButton> createState() => _DropdownMenuButtonState();
}

class _DropdownMenuButtonState extends State<_DropdownMenuButton> {
  late final GlassMenuController _menuController;

  @override
  void initState() {
    super.initState();
    _menuController = GlassMenuController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentsBloc, DocumentsState>(
      buildWhen: (previous, current) =>
          previous.selectionMode != current.selectionMode ||
          previous.searchQuery != current.searchQuery,
      builder: (context, documentsState) {
        return GlassMenu(
          controller: _menuController,
          glowColor: context.colors.white,
          enableInteractionGlow: false,
          selectionColor: const Color(0x14000000),
          settings: LiquidGlassSettings(
            glassColor: const Color(0xF2FFFFFF),
            backerColor: const Color(0xCCFFFFFF),
            blur: 18,
            thickness: 28,
            whitenStrength: 0.75,
            whitenGated: false,
            shadow: [
              const BoxShadow(
                color: Color(0x80FFFFFF),
                blurRadius: 44,
                spreadRadius: 8,
                offset: Offset(0, 18),
              ),
              BoxShadow(
                color: context.colors.black.withValues(alpha: .08),
                blurRadius: 18,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          menuWidth: 262,
          menuHeight: 104,
          menuBorderRadius: 34,
          menuPadding: const Pad(vertical: 10, horizontal: 20, left: 20),
          menuAlignment: GlassMenuAlignment.topRight,
          items: [
            _DropdownMenuItem(
              onTap: () => _toggleSelectionMode(documentsState.selectionMode),
              title: documentsState.selectionMode ? 'Cancel' : 'Select',
              icon: documentsState.selectionMode
                  ? CupertinoIcons.xmark_circle
                  : CupertinoIcons.check_mark_circled,
            ),
            _DropdownMenuItem(
              onTap: () {
                context.read<FloatingActionsBloc>().add(
                  FloatingActionsEvent.openAddDocumentsPopupFromAppBar(
                    shouldRestoreSearchAfterPopup:
                        documentsState.searchQuery.isNotEmpty,
                  ),
                );
                _closeMenu();
              },
              title: 'Add Document',
              icon: CupertinoIcons.add_circled_solid,
            ),
          ],
          triggerBuilder: (context, toggleMenu) {
            return GlassIconButton(
              size: 38,
              borderRadius: 15.2,
              useOwnLayer: true,
              settings: const LiquidGlassSettings(),
              shape: GlassIconButtonShape.roundedSquare,
              icon: Icon(
                CupertinoIcons.ellipsis,
                color: context.colors.white,
                size: 19.55,
              ),
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                context.read<FloatingActionsBloc>().add(
                  FloatingActionsEvent.dismissForAppBarMenu(
                    shouldKeepSearchOpen: documentsState.searchQuery.isNotEmpty,
                  ),
                );
                toggleMenu();
              },
            );
          },
        );
      },
    );
  }

  void _closeMenu() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _menuController.close();
    });
  }

  void _toggleSelectionMode(bool isSelectionMode) {
    context.read<DocumentsBloc>().add(
      isSelectionMode
          ? const DocumentsEvent.selectionCancelled()
          : const DocumentsEvent.selectionStarted(),
    );
    _closeMenu();
  }
}

class _DropdownMenuItem extends StatelessWidget {
  const _DropdownMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlassMenuItem(
      height: 40,
      title: title,
      iconSize: 17,
      onTap: onTap,
      icon: Icon(icon),
      iconColor: context.colors.textPrimary,
      titleStyle: context.styles.dropdownMenu,
    );
  }
}
