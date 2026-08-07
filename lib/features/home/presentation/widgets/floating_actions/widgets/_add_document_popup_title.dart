part of '../../../home_screen.dart';

class _AddDocumentPopupTitle extends StatelessWidget {
  const _AddDocumentPopupTitle();

  static const _rightOffset = _AddDocumentButton.collapsedWidth + 18;
  static const _width = 190.0;
  static const _duration = Duration(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FloatingActionsBloc, FloatingActionsState>(
      builder: (context, state) {
        return Positioned.fill(
          child: IgnorePointer(
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: state.isAddDocumentsPopupOpen ? 1 : 0),
              duration: _duration,
              curve: Curves.easeOutExpo,
              builder: (context, progress, child) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const Pad(right: _rightOffset),
                    child: Opacity(
                      opacity: progress,
                      child: Transform.translate(
                        offset: Offset(
                          _lerp(132, 0, progress),
                          0,
                        ),
                        child: child,
                      ),
                    ),
                  ),
                );
              },
              child: SizedBox(
                width: _width,
                child: Text(
                  'home.floating_actions.add_document.add_document_from'.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: context.styles.header2.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double _lerp(double begin, double end, double progress) {
    return begin + (end - begin) * progress;
  }
}
