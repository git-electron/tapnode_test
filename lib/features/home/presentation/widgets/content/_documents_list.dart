part of '../../home_screen.dart';

class _DocumentsList extends StatelessWidget {
  const _DocumentsList({required this.documents});

  final List<DocumentModel> documents;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const Pad(horizontal: 28, top: 84, bottom: 140),
      itemCount: documents.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: .72,
      ),
      itemBuilder: (context, index) {
        final document = documents[index];

        return document.hasSinglePreviewImage
            ? Image.file(File(document.firstPreviewImagePath!))
            : Text(document.title);
      },
    );
  }
}
