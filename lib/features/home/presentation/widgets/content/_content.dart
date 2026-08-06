part of '../../home_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentsBloc, DocumentsState>(
      builder: (context, state) {
        if (state.hasNoDocuments) return const _EmptyPlaceholder();
        if (state.hasNoVisibleDocumentsByFilters) {
          return const _DocumentsNotFoundPlaceholder();
        }

        return const _DocumentsList();
      },
    );
  }
}
