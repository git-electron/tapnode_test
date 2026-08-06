part of '../../home_screen.dart';

class _DocumentsList extends StatefulWidget {
  const _DocumentsList({required this.documents});

  final List<DocumentModel> documents;

  @override
  State<_DocumentsList> createState() => _DocumentsListState();
}

class _DocumentsListState extends State<_DocumentsList> {
  int? _activeMenuDocumentId;

  void _setActiveMenuDocumentId(int? documentId) {
    if (_activeMenuDocumentId == documentId) return;
    setState(() => _activeMenuDocumentId = documentId);
  }

  @override
  Widget build(BuildContext context) {
    return AppAnimatedGrid<DocumentModel, int>(
      items: widget.documents,
      idOf: (document) => document.id,
      padding: const EdgeInsets.fromLTRB(28, 84, 28, 140),
      itemHeightBuilder: (context, document, itemWidth) {
        return _documentGridItemHeight(
          context: context,
          document: document,
          maxWidth: itemWidth,
        );
      },
      itemBuilder: (context, document) {
        final shouldFade = _activeMenuDocumentId != null && _activeMenuDocumentId != document.id;

        return AnimatedOpacity(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          opacity: shouldFade ? .2 : 1,
          child: _DocumentGridMenu(
            document: document,
            onOpen: () => _setActiveMenuDocumentId(document.id),
            onClose: () {
              if (_activeMenuDocumentId != document.id) return;
              _setActiveMenuDocumentId(null);
            },
          ),
        );
      },
    );
  }
}

class _DocumentGridMenu extends StatefulWidget {
  const _DocumentGridMenu({
    required this.document,
    required this.onOpen,
    required this.onClose,
  });

  final DocumentModel document;
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
            menuHeight: 142,
            menuBorderRadius: 34,
            menuPadding: const Pad(vertical: 10, horizontal: 20, left: 20),
            menuAlignment: _menuAlignment,
            onClose: widget.onClose,
            items: [
              _DocumentMenuItem(
                title: 'Print',
                icon: CupertinoIcons.printer,
                onTap: _closeMenu,
              ),
              _DocumentMenuItem(
                title: 'Share',
                icon: CupertinoIcons.share,
                onTap: _closeMenu,
              ),
              _DocumentMenuItem(
                title: 'Delete',
                icon: CupertinoIcons.delete,
                destructive: true,
                onTap: _deleteDocument,
              ),
            ],
            trigger: const SizedBox.expand(),
          ),
        ),
        Tappable(
          onLongTap: _openMenu,
          child: _DocumentGridItem(document: widget.document),
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
          : _documentGridItemHeight(
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
      return isLeftSide ? GlassMenuAlignment.bottomLeft : GlassMenuAlignment.bottomRight;
    }

    return isLeftSide ? GlassMenuAlignment.topLeft : GlassMenuAlignment.topRight;
  }

  bool _shouldOpenMenuUp() {
    final renderBox = context.findRenderObject() as RenderBox?;
    final screenHeight = MediaQuery.sizeOf(context).height;
    if (renderBox == null || !renderBox.hasSize) {
      return false;
    }

    final position = renderBox.localToGlobal(Offset.zero);
    final cardCenterY = position.dy + renderBox.size.height / 2;

    return cardCenterY > screenHeight / 2;
  }

  bool _isLeftSide() {
    final renderBox = context.findRenderObject() as RenderBox?;
    final screenWidth = MediaQuery.sizeOf(context).width;
    if (renderBox == null || !renderBox.hasSize) {
      return true;
    }

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

  void _closeMenu() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _menuController.close();
    });
  }
}

class _DocumentMenuItem extends StatelessWidget {
  const _DocumentMenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
    this.destructive = false,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color = destructive ? CupertinoColors.systemRed : context.colors.textPrimary;

    return GlassMenuItem(
      height: 40,
      title: title,
      iconSize: 17,
      onTap: onTap,
      icon: Icon(icon),
      iconColor: color,
      titleStyle: context.styles.dropdownMenu.copyWith(color: color),
    );
  }
}
