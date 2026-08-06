part of '../../../home_screen.dart';

class _SelectionModeActionButton extends StatelessWidget {
  const _SelectionModeActionButton({
    required this.state,
    super.key,
  });

  final DocumentsState state;

  static const _height = 38.0;
  static const _horizontalPadding = 13.0;
  static const _widthAnimationDuration = Duration(milliseconds: 220);
  static const _textAnimationDuration = Duration(milliseconds: 160);

  bool get _hasSelectedDocuments => state.selectedIds.isNotEmpty;

  String get _title {
    if (_hasSelectedDocuments) {
      return 'Deselect All (${state.selectedIds.length})';
    }

    return 'Select All';
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = context.styles.header3.copyWith(
      color: context.colors.white,
    );
    final targetWidth = _measureButtonWidth(
      context: context,
      title: _title,
      textStyle: textStyle,
    );

    return TweenAnimationBuilder<double>(
      tween: Tween(end: targetWidth),
      duration: _widthAnimationDuration,
      curve: Curves.easeOutCubic,
      builder: (context, width, child) {
        return Tappable(
          scale: .97,
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutCubic,
          onTap: () => _handleTap(context),
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
                  child: _SelectionModeActionText(
                    title: _title,
                    textStyle: textStyle,
                    width: width - _horizontalPadding * 2,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleTap(BuildContext context) {
    context.read<DocumentsBloc>().add(
      _hasSelectedDocuments
          ? const DocumentsEvent.deselectAll()
          : const DocumentsEvent.selectAll(),
    );
  }

  double _measureButtonWidth({
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

class _SelectionModeActionText extends StatelessWidget {
  const _SelectionModeActionText({
    required this.title,
    required this.textStyle,
    required this.width,
  });

  final String title;
  final TextStyle textStyle;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizedBox(
        width: width,
        child: AnimatedSwitcher(
          duration: _SelectionModeActionButton._textAnimationDuration,
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          layoutBuilder: _alignTextToLeft,
          transitionBuilder: _buildTextTransition,
          child: Text(
            title,
            key: ValueKey(title),
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.visible,
            style: textStyle,
          ),
        ),
      ),
    );
  }

  Widget _alignTextToLeft(
    Widget? currentChild,
    List<Widget> previousChildren,
  ) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        ...previousChildren,
        ?currentChild,
      ],
    );
  }

  Widget _buildTextTransition(
    Widget child,
    Animation<double> animation,
  ) {
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
  }
}
