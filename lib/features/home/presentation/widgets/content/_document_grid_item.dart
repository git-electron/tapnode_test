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
          const Gap(15),
          Text(document.title, style: context.styles.header3),
          const Gap(4),
          Text(
            document.createdAt.formattedDate,
            style: context.styles.text2.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
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
        clipBehavior: Clip.none,
        children: [
          _ImagePreview(path: document.firstPreviewImagePath!),
          Positioned(
            left: 12,
            child: Transform.rotate(
              angle: 7.35 * pi / 180,
              child: _ImagePreview(path: document.lastPreviewImagePath!),
            ),
          ),
        ],
      );
    }
    if (document.hasSinglePreviewImage) return _ImagePreview(path: document.firstPreviewImagePath!);
    return const _ImagePreview.broken();
  }
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.path});
  const _ImagePreview.broken() : path = null;

  final String? path;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 167,
      width: 123,
      decoration: BoxDecoration(
        color: context.colors.white,
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
        child: path != null
            ? Image.file(
                File(path!),
                fit: BoxFit.cover,
              )
            : const Icon(CupertinoIcons.exclamationmark_triangle),
      ),
    );
  }
}
