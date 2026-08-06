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
      itemBuilder: (context, document) {
        return CupertinoContextMenu(
          actions: [
            CupertinoContextMenuAction(
              isDestructiveAction: true,
              trailingIcon: CupertinoIcons.delete,
              onPressed: () {
                Navigator.of(context).pop();
                context.read<DocumentsBloc>().add(
                  DocumentsEvent.deleteRequested(document.id),
                );
              },
              child: const Text('Delete'),
            ),
          ],
          child: _DocumentGridItem(document: document),
        );
      },
    );
  }
}
