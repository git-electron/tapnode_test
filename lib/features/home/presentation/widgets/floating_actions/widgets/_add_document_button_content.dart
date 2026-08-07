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
          child: selectionMode ? const _AddDocumentShareIcon() : const _AddDocumentCloseIcon(),
        ),
      ],
    );
  }
}

class _AddDocumentExpandedContent extends StatelessWidget {
  const _AddDocumentExpandedContent();

  static const horizontalPadding = 14.0;
  static const iconSize = 24.0;
  static const iconTextGap = 8.0;

  static String title(BuildContext context) {
    return 'home.floating_actions.add_document.add_document'.tr();
  }

  static double width(BuildContext context) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: title(context),
        style: context.styles.header2,
      ),
      maxLines: 1,
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();

    return horizontalPadding * 2 + iconSize + iconTextGap + textPainter.width;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const Pad(
        vertical: 19,
        horizontal: horizontalPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox.square(
            dimension: iconSize,
            child: Icon(CupertinoIcons.add_circled_solid),
          ),
          const Gap(iconTextGap),
          Text(
            title(context),
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.visible,
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
