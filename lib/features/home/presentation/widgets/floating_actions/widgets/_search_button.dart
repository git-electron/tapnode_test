part of '../../../home_screen.dart';

class _SearchButton extends StatefulWidget {
  const _SearchButton();

  static const collapsedSize = 63.0;
  static const expandedHeight = 48.0;
  static const leftPadding = 11.0;
  static const iconSize = 24.0;
  static const iconTextGap = 8.0;
  static const animationDuration = Duration(milliseconds: 500);

  static double lerp(double begin, double end, double progress) {
    return begin + (end - begin) * progress;
  }

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
