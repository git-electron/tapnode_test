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
      itemBuilder: (context, document) => _DocumentGridItem(document: document),
    );
  }
}

class _DocumentGridItem extends StatelessWidget {
  const _DocumentGridItem({required this.document});

  final DocumentModel document;

  @override
  Widget build(BuildContext context) {
    return document.hasSinglePreviewImage
        ? Image.file(File(document.firstPreviewImagePath!))
        : Text(document.firstPreviewImagePath ?? 't');
  }
}
