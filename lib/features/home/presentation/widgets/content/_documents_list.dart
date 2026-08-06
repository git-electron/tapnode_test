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
        final shouldFade =
            _activeMenuDocumentId != null &&
            _activeMenuDocumentId != document.id;

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
