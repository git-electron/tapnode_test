part of '../../../home_screen.dart';

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
          layoutBuilder: _alignChildrenToLeft,
          transitionBuilder: _buildLeadingTransition,
          child: state.selectionMode
              ? _SelectionModeActionButton(
                  key: const ValueKey('selection-mode-action-button'),
                  state: state,
                )
              : const _AppLogo(key: ValueKey('app-logo')),
        );
      },
    );
  }

  Widget _alignChildrenToLeft(
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

  Widget _buildLeadingTransition(
    Widget child,
    Animation<double> animation,
  ) {
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
  }
}
