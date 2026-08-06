part of '../../../home_screen.dart';

class _DocumentSelectionMark extends StatelessWidget {
  const _DocumentSelectionMark({
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
                      painter: _DocumentSelectionMarkShadowPainter(
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

class _DocumentSelectionMarkShadowPainter extends CustomPainter {
  const _DocumentSelectionMarkShadowPainter({
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
    final radius = _lerp(
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
    final outerPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
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
  bool shouldRepaint(
    covariant _DocumentSelectionMarkShadowPainter oldDelegate,
  ) {
    return oldDelegate.progress != progress ||
        oldDelegate.shadowColor != shadowColor;
  }

  double _lerp(double begin, double end, double progress) {
    return begin + (end - begin) * progress;
  }
}
