part of '../../../home_screen.dart';

class _DocumentSignedMark extends StatelessWidget {
  const _DocumentSignedMark({required this.visible});

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
