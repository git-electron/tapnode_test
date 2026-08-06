part of '../../home_screen.dart';

class _DocumentGridItem extends StatelessWidget {
  const _DocumentGridItem({
    required this.document,
    required this.selectionMode,
    required this.isSelected,
  });

  final DocumentModel document;
  final bool selectionMode;
  final bool isSelected;

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
                  Positioned.fill(
                    child: Align(
                      child: _SelectionMark(
                        visible: selectionMode,
                        selected: isSelected,
                      ),
                    ),
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

class _SelectionMark extends StatelessWidget {
  const _SelectionMark({
    required this.visible,
    required this.selected,
  });

  final bool visible;
  final bool selected;

  static const _duration = Duration(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedOpacity(
        duration: _duration,
        curve: Curves.easeOutExpo,
        opacity: visible ? 1 : 0,
        child: AnimatedScale(
          duration: _duration,
          curve: Curves.easeOutExpo,
          scale: visible ? 1 : .72,
          child: TweenAnimationBuilder<double>(
            tween: Tween(end: selected ? 1 : 0),
            duration: _duration,
            curve: Curves.easeOutExpo,
            builder: (context, progress, child) {
              return SizedBox.square(
                dimension: 50,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size.square(50),
                      painter: _SelectionMarkShadowPainter(
                        progress: progress,
                        shadowColor: context.colors.black.withValues(
                          alpha: .28,
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      duration: _duration,
                      curve: Curves.easeOutCubic,
                      opacity: selected ? 0 : 1,
                      child: Assets.icons.check.svg(),
                    ),
                    AnimatedOpacity(
                      duration: _duration,
                      curve: Curves.easeOutCubic,
                      opacity: selected ? 1 : 0,
                      child: AnimatedScale(
                        duration: _duration,
                        curve: Curves.easeOutBack,
                        scale: selected ? 1 : .82,
                        child: Assets.icons.checkSelected.svg(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SelectionMarkShadowPainter extends CustomPainter {
  const _SelectionMarkShadowPainter({
    required this.progress,
    required this.shadowColor,
  });

  final double progress;
  final Color shadowColor;

  static const _strokeWidth = 4.0;
  static const _uncheckedRadius = 18.0;
  static const _checkedRadius = 21.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = _selectionMarkLerp(
      _uncheckedRadius,
      _checkedRadius,
      progress,
    );
    final ringPath = _ringPath(center: center, radius: radius);

    canvas.drawPath(
      ringPath.shift(const Offset(0, .5)),
      Paint()
        ..color = shadowColor
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.4),
    );
  }

  Path _ringPath({
    required Offset center,
    required double radius,
  }) {
    final outerPath = Path()..addOval(Rect.fromCircle(center: center, radius: radius));
    final innerPath = Path()
      ..addOval(
        Rect.fromCircle(
          center: center,
          radius: radius - _strokeWidth,
        ),
      );

    return Path.combine(PathOperation.difference, outerPath, innerPath);
  }

  @override
  bool shouldRepaint(covariant _SelectionMarkShadowPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.shadowColor != shadowColor;
  }
}

double _selectionMarkLerp(double begin, double end, double progress) {
  return begin + (end - begin) * progress;
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
