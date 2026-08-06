part of '../../../home_screen.dart';

class _DocumentGridMenu extends StatefulWidget {
  const _DocumentGridMenu({
    required this.document,
    required this.selectionMode,
    required this.isSelected,
    required this.onOpen,
    required this.onClose,
  });

  final DocumentModel document;
  final bool selectionMode;
  final bool isSelected;
  final VoidCallback onOpen;
  final VoidCallback onClose;

  @override
  State<_DocumentGridMenu> createState() => _DocumentGridMenuState();
}

class _DocumentGridMenuState extends State<_DocumentGridMenu> {
  late final GlassMenuController _menuController;
  var _menuAlignment = GlassMenuAlignment.topCenter;
  var _menuAnchorTop = 224.0;

  @override
  void initState() {
    super.initState();
    _menuController = GlassMenuController();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: _menuAnchorTop,
          height: 1,
          child: GlassMenu(
            controller: _menuController,
            glowColor: context.colors.white,
            enableInteractionGlow: false,
            selectionColor: const Color(0x14000000),
            settings: appGlassMenuSettings(context),
            menuWidth: 250,
            menuHeight: 145,
            menuBorderRadius: 34,
            menuPadding: const Pad(vertical: 10),
            menuAlignment: _menuAlignment,
            onClose: widget.onClose,
            items: [
              _DocumentQuickActionsMenuItem(
                onPrint: _closeMenu,
                onShare: _closeMenu,
              ),
              const _DocumentMenuDivider(),
              _DocumentDeleteMenuButton(onTap: _deleteDocument),
            ],
            trigger: const SizedBox.expand(),
          ),
        ),
        Tappable(
          onTap: _handleTap,
          onLongTap: widget.selectionMode ? null : _openMenu,
          child: _DocumentGridItem(
            document: widget.document,
            selectionMode: widget.selectionMode,
            isSelected: widget.isSelected,
          ),
        ),
      ],
    );
  }

  void _openMenu() {
    widget.onOpen();
    final opensUp = _shouldOpenMenuUp();
    final isLeftSide = _isLeftSide();
    setState(() {
      _menuAlignment = _effectiveMenuAlignment(
        opensUp: opensUp,
        isLeftSide: isLeftSide,
      );
      _menuAnchorTop = opensUp
          ? 0
          : _DocumentGridItem.itemHeight(
              context: context,
              document: widget.document,
              maxWidth: _itemWidth(),
            );
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _menuController.open();
    });
  }

  GlassMenuAlignment _effectiveMenuAlignment({
    required bool opensUp,
    required bool isLeftSide,
  }) {
    if (opensUp) {
      return isLeftSide
          ? GlassMenuAlignment.bottomLeft
          : GlassMenuAlignment.bottomRight;
    }

    return isLeftSide
        ? GlassMenuAlignment.topLeft
        : GlassMenuAlignment.topRight;
  }

  bool _shouldOpenMenuUp() {
    final renderBox = context.findRenderObject() as RenderBox?;
    final screenHeight = MediaQuery.sizeOf(context).height;
    if (renderBox == null || !renderBox.hasSize) return false;

    final position = renderBox.localToGlobal(Offset.zero);
    final cardCenterY = position.dy + renderBox.size.height / 2;

    return cardCenterY > screenHeight / 2;
  }

  bool _isLeftSide() {
    final renderBox = context.findRenderObject() as RenderBox?;
    final screenWidth = MediaQuery.sizeOf(context).width;
    if (renderBox == null || !renderBox.hasSize) return true;

    final position = renderBox.localToGlobal(Offset.zero);
    final cardCenterX = position.dx + renderBox.size.width / 2;

    return cardCenterX < screenWidth / 2;
  }

  double _itemWidth() {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return 150;

    return renderBox.size.width;
  }

  void _deleteDocument() {
    context.read<DocumentsBloc>().add(
      DocumentsEvent.deleteRequested(widget.document.id),
    );
    _closeMenu();
  }

  void _handleTap() {
    if (widget.selectionMode) {
      context.read<DocumentsBloc>().add(
        DocumentsEvent.documentSelectionToggled(widget.document.id),
      );
      return;
    }

    context.read<DocumentsBloc>().add(
      DocumentsEvent.documentSignedToggled(widget.document.id),
    );
  }

  void _closeMenu() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _menuController.close();
    });
  }
}
