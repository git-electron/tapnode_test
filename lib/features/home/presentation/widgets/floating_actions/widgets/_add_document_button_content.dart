part of '../../../home_screen.dart';

class _AddDocumentButtonContent extends StatelessWidget {
  const _AddDocumentButtonContent({
    required this.progress,
    required this.selectionMode,
  });

  final double progress;
  final bool selectionMode;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: 1 - progress,
          child: const _AddDocumentExpandedContent(),
        ),
        Opacity(
          opacity: progress,
          child: selectionMode
              ? const _AddDocumentShareIcon()
              : const _AddDocumentCloseIcon(),
        ),
      ],
    );
  }
}

class _AddDocumentExpandedContent extends StatelessWidget {
  const _AddDocumentExpandedContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const Pad(
        vertical: 19,
        horizontal: 14,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox.square(
            dimension: 24,
            child: Icon(CupertinoIcons.add_circled_solid),
          ),
          const Gap(8),
          Text(
            'Add Document',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.styles.header2,
          ),
        ],
      ),
    );
  }
}

class _AddDocumentCloseIcon extends StatelessWidget {
  const _AddDocumentCloseIcon();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      CupertinoIcons.xmark,
      size: 29,
    );
  }
}

class _AddDocumentShareIcon extends StatelessWidget {
  const _AddDocumentShareIcon();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      CupertinoIcons.share,
      size: 29,
    );
  }
}
