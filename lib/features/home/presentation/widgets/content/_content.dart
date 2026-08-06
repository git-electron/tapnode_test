part of '../../home_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentsBloc, DocumentsState>(
      builder: (context, state) {
        return Stack(
          fit: StackFit.expand,
          children: [
            _DocumentsList(documents: state.documents),
            if (state.hasNoDocuments) const _EmptyPlaceholder(),
            if (state.hasNoVisibleDocumentsByFilters)
              const _DocumentsNotFoundPlaceholder(),
          ],
        );
      },
    );
  }
}
