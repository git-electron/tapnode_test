part of '../../../home_screen.dart';

class _AddDocumentButton extends StatelessWidget {
  const _AddDocumentButton();

  static const height = 61.0;
  static const collapsedWidth = 61.0;
  static const searchCloseSize = 48.0;
  static const animationDuration = Duration(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentsBloc, DocumentsState>(
      buildWhen: (previous, current) => previous.selectionMode != current.selectionMode,
      builder: (context, documentsState) {
        return BlocBuilder<FloatingActionsBloc, FloatingActionsState>(
          builder: (context, state) {
            return _AddDocumentButtonFrame(
              state: state,
              selectionMode: documentsState.selectionMode,
              onTap: () {
                if (documentsState.selectionMode) return;
                _handleTap(context, state);
              },
            );
          },
        );
      },
    );
  }

  void _handleTap(BuildContext context, FloatingActionsState state) {
    if (state.isSearchOpen) {
      context.read<DocumentsBloc>().add(
        const DocumentsEvent.searchChanged(''),
      );
      context.read<FloatingActionsBloc>().add(
        const FloatingActionsEvent.closeSearch(),
      );
      return;
    }
    if (state.isAddDocumentsPopupOpen) {
      context.read<FloatingActionsBloc>().add(
        const FloatingActionsEvent.closeAddDocumentsPopup(),
      );
      return;
    }

    context.read<FloatingActionsBloc>().add(
      const FloatingActionsEvent.openAddDocumentsPopup(),
    );
  }
}
