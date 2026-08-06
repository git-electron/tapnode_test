part of '../../home_screen.dart';

class _DocumentGridItem extends StatelessWidget {
  const _DocumentGridItem({required this.document});

  final DocumentModel document;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final titleHasTwoLines = _titleHasTwoLines(
          context: context,
          maxWidth: constraints.maxWidth,
        );
        final height = titleHasTwoLines ? 240.0 : 224.0;

        return SizedBox(
          height: height,
          width: double.maxFinite,
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  _Preview(document: document),
                  Positioned(
                    bottom: -10,
                    child: _SignedMark(visible: document.isSigned),
                  ),
                ],
              ),
              const Gap(15),
              Text(
                document.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: context.styles.header3,
              ),
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
      },
    );
  }

  bool _titleHasTwoLines({
    required BuildContext context,
    required double maxWidth,
  }) {
    return _documentTitleHasTwoLines(
      context: context,
      title: document.title,
      maxWidth: maxWidth,
    );
  }
}

class _SignedMark extends StatelessWidget {
  const _SignedMark({required this.visible});

  final bool visible;

  static const _duration = Duration(milliseconds: 220);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedOpacity(
        duration: _duration,
        curve: Curves.easeOutCubic,
        opacity: visible ? 1 : 0,
        child: AnimatedScale(
          duration: _duration,
          curve: Curves.easeOutBack,
          scale: visible ? 1 : .72,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colors.white,
              boxShadow: [
                BoxShadow(
                  color: context.colors.black.withValues(alpha: .08),
                  blurRadius: 11,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SizedBox.square(
              dimension: 42,
              child: Padding(
                padding: const Pad(all: 8),
                child: Assets.icons.signed.svg(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

double _documentGridItemHeight({
  required BuildContext context,
  required DocumentModel document,
  required double maxWidth,
}) {
  return _documentTitleHasTwoLines(
        context: context,
        title: document.title,
        maxWidth: maxWidth,
      )
      ? 240
      : 224;
}

bool _documentTitleHasTwoLines({
  required BuildContext context,
  required String title,
  required double maxWidth,
}) {
  final textScaler = MediaQuery.textScalerOf(context);
  final textPainter = TextPainter(
    text: TextSpan(
      text: title,
      style: context.styles.header3,
    ),
    maxLines: 2,
    textDirection: Directionality.of(context),
    textScaler: textScaler,
  )..layout(maxWidth: maxWidth);

  return textPainter.computeLineMetrics().length > 1;
}

class _Preview extends StatelessWidget {
  const _Preview({required this.document});

  final DocumentModel document;

  @override
  Widget build(BuildContext context) {
    if (document.hasDoublePreviewImages) {
      return SizedBox(
        height: 167,
        width: 150,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _ImagePreview(path: document.lastPreviewImagePath!),
            Positioned(
              left: 12,
              child: Transform.rotate(
                angle: 7.35 * pi / 180,
                child: _ImagePreview(path: document.firstPreviewImagePath!),
              ),
            ),
          ],
        ),
      );
    }
    if (document.hasSinglePreviewImage) {
      return SizedBox(
        height: 167,
        width: 150,
        child: Center(
          child: _ImagePreview(path: document.firstPreviewImagePath!),
        ),
      );
    }

    return const SizedBox(
      height: 167,
      width: 150,
      child: Center(
        child: _ImagePreview.broken(),
      ),
    );
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
