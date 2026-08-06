part of '../../home_screen.dart';

class _AddDocumentPopupActions extends StatelessWidget {
  const _AddDocumentPopupActions();

  static const _width = 148.0;
  static const _gap = 12.0;
  static const _right = 28.0;
  static const _bottom = 121.0;
  static const _openDuration = Duration(milliseconds: 500);
  static const _closeDuration = Duration(milliseconds: 300);
  static const _staggerDelay = .13;

  static final _actions = [
    _AddDocumentPopupAction(
      label: 'Files',
      icon: Assets.images.files.image(fit: BoxFit.cover),
    ),
    _AddDocumentPopupAction(
      label: 'Photos',
      icon: Assets.images.gallery.image(fit: BoxFit.cover),
    ),
    _AddDocumentPopupAction(
      label: 'Scanner',
      icon: Assets.images.camera.image(fit: BoxFit.cover),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FloatingActionsBloc, FloatingActionsState>(
      builder: (context, state) {
        return Positioned(
          right: _right,
          bottom: _bottom,
          child: IgnorePointer(
            ignoring: !state.isAddDocumentsPopupOpen,
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: state.isAddDocumentsPopupOpen ? 1 : 0),
              duration: state.isAddDocumentsPopupOpen ? _openDuration : _closeDuration,
              builder: (context, progress, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final indexedAction in _actions.indexed) ...[
                      _AnimatedAddDocumentPopupAction(
                        action: indexedAction.$2,
                        index: indexedAction.$1,
                        progress: progress,
                        isOpen: state.isAddDocumentsPopupOpen,
                      ),
                      if (indexedAction.$1 != _actions.length - 1) const Gap(_gap),
                    ],
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedAddDocumentPopupAction extends StatelessWidget {
  const _AnimatedAddDocumentPopupAction({
    required this.action,
    required this.index,
    required this.progress,
    required this.isOpen,
  });

  final _AddDocumentPopupAction action;
  final int index;
  final double progress;
  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    final itemProgress = _delayedProgress(
      progress,
      index * _AddDocumentPopupActions._staggerDelay,
      isOpen,
    );

    return Opacity(
      opacity: itemProgress,
      child: Transform.translate(
        offset: Offset(
          _addDocumentPopupLerp(58, 0, itemProgress),
          _addDocumentPopupLerp(64 + index * 14, 0, itemProgress),
        ),
        child: Transform.scale(
          scale: _addDocumentPopupLerp(.86, 1, itemProgress),
          alignment: Alignment.centerRight,
          child: AppGlassButton(
            width: _AddDocumentPopupActions._width,
            icon: action.icon,
            label: action.label,
            onTap: () {
              context.read<FloatingActionsBloc>().add(
                const FloatingActionsEvent.closeAddDocumentsPopup(),
              );
            },
          ),
        ),
      ),
    );
  }

  double _delayedProgress(double value, double start, bool isOpen) {
    if (value <= start) return 0;
    if (value >= 1) return 1;

    final shiftedValue = ((value - start) / (1 - start)).clamp(0.0, 1.0);
    if (isOpen) return Curves.easeOutCubic.transform(shiftedValue);

    return 1 - Curves.easeOutCubic.transform(1 - shiftedValue);
  }
}

class _AddDocumentPopupAction {
  const _AddDocumentPopupAction({
    required this.label,
    required this.icon,
  });

  final String label;
  final Widget icon;
}

double _addDocumentPopupLerp(double begin, double end, double progress) {
  return begin + (end - begin) * progress;
}
