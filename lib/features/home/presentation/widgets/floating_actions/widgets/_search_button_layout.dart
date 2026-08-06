part of '../../../home_screen.dart';

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
              tween: Tween(end: _targetProgress()),
              duration: _SearchButton.animationDuration,
              curve: Curves.easeOutExpo,
              builder: (context, progress, child) {
                return _SearchButtonFrame(
                  progress: progress,
                  maxWidth: constraints.maxWidth,
                  onTap: selectionMode
                      ? () => _requestSelectedDocumentsDelete(context)
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

  void _requestSelectedDocumentsDelete(BuildContext context) {
    context.read<DocumentsBloc>().add(
      const DocumentsEvent.selectedDeleteRequested(),
    );
  }

  double _targetProgress() {
    if (state.isAddDocumentsPopupOpen) return -1;
    if (selectionMode) return 0;
    if (state.isSearchOpen) return 1;
    return 0;
  }
}
