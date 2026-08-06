part of '../../home_screen.dart';

class _DocumentGridItem extends StatelessWidget {
  const _DocumentGridItem({required this.document});

  final DocumentModel document;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        children: [
          _Preview(document: document),
          Gap(document.hasDoublePreviewImages ? 7 : 15),
          Text(document.title),
          Text(document.createdAt.toIso8601String()),
        ],
      ),
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({required this.document});

  final DocumentModel document;

  @override
  Widget build(BuildContext context) {
    if (document.hasDoublePreviewImages) {
      return Stack(
        children: [
          _ImagePreview(path: document.firstPreviewImagePath!),
          Transform.rotate(
            angle: 7.35 * pi / 180,
            child: _ImagePreview(path: document.lastPreviewImagePath!),
          ),
        ],
      );
    }
    if (document.hasSinglePreviewImage) return _ImagePreview(path: document.firstPreviewImagePath!);
    return const Placeholder();
  }
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 167,
      width: 123,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: context.colors.black.withValues(alpha: .08),
            blurRadius: 11,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      foregroundDecoration: BoxDecoration(
        border: Border.all(color: const Color(0xffDADADA)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          File(path),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
