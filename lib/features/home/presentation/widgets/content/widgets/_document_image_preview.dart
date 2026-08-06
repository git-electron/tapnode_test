part of '../../../home_screen.dart';

class _DocumentImagePreview extends StatelessWidget {
  const _DocumentImagePreview({required this.path});
  const _DocumentImagePreview.broken() : path = null;

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
