part of '../../../home_screen.dart';

class _AppBarMenuButton extends StatefulWidget {
  const _AppBarMenuButton();

  @override
  State<_AppBarMenuButton> createState() => _AppBarMenuButtonState();
}

class _AppBarMenuButtonState extends State<_AppBarMenuButton> {
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
          settings: _menuSettings(context),
          menuWidth: 262,
          menuHeight: 104,
          menuBorderRadius: 34,
          menuPadding: const Pad(vertical: 10, horizontal: 20, left: 20),
          menuAlignment: GlassMenuAlignment.topRight,
          items: _menuItems(documentsState),
          triggerBuilder: (context, toggleMenu) {
            return _AppBarMenuTrigger(
              onPressed: () => _handleMenuPressed(
                documentsState: documentsState,
                toggleMenu: toggleMenu,
              ),
            );
          },
        );
      },
    );
  }

  List<Widget> _menuItems(DocumentsState documentsState) {
    return [
      _AppBarMenuItem(
        onTap: () => _toggleSelectionMode(documentsState.selectionMode),
        title: documentsState.selectionMode ? 'Cancel' : 'Select',
        icon: documentsState.selectionMode
            ? CupertinoIcons.xmark_circle
            : CupertinoIcons.check_mark_circled,
      ),
      _AppBarMenuItem(
        onTap: () => _openAddDocumentsPopup(documentsState),
        title: 'Add Document',
        icon: CupertinoIcons.add_circled_solid,
      ),
    ];
  }

  LiquidGlassSettings _menuSettings(BuildContext context) {
    return LiquidGlassSettings(
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
    );
  }

  void _handleMenuPressed({
    required DocumentsState documentsState,
    required VoidCallback toggleMenu,
  }) {
    FocusManager.instance.primaryFocus?.unfocus();
    context.read<FloatingActionsBloc>().add(
      FloatingActionsEvent.dismissForAppBarMenu(
        shouldKeepSearchOpen: documentsState.searchQuery.isNotEmpty,
      ),
    );
    toggleMenu();
  }

  void _openAddDocumentsPopup(DocumentsState documentsState) {
    context.read<FloatingActionsBloc>().add(
      FloatingActionsEvent.openAddDocumentsPopupFromAppBar(
        shouldRestoreSearchAfterPopup: documentsState.searchQuery.isNotEmpty,
      ),
    );
    _closeMenu();
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

class _AppBarMenuTrigger extends StatelessWidget {
  const _AppBarMenuTrigger({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
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
      onPressed: onPressed,
    );
  }
}
