part of '../../home_screen.dart';

class _DocumentsList extends StatelessWidget {
  const _DocumentsList({required this.documents});

  final List<DocumentModel> documents;

  @override
  Widget build(BuildContext context) {
    return AppAnimatedGrid<DocumentModel, int>(
      items: documents,
      idOf: (document) => document.id,
      padding: const EdgeInsets.fromLTRB(28, 84, 28, 140),
      itemHeightBuilder: (context, document, itemWidth) {
        return _documentGridItemHeight(
          context: context,
          document: document,
          maxWidth: itemWidth,
        );
      },
      itemBuilder: (context, document) => _DocumentGridItem(document: document),
    );
  }
}
