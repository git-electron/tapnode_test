part of '../../../home_screen.dart';

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
      label: 'home.floating_actions.add_document.buttons.files'.tr(),
      icon: Assets.images.files.image(fit: BoxFit.cover),
      source: DocumentImportSource.file,
    ),
    _AddDocumentPopupAction(
      label: 'home.floating_actions.add_document.buttons.photos'.tr(),
      icon: Assets.images.gallery.image(fit: BoxFit.cover),
      source: DocumentImportSource.gallery,
    ),
    _AddDocumentPopupAction(
      label: 'home.floating_actions.add_document.buttons.scanner'.tr(),
      icon: Assets.images.camera.image(fit: BoxFit.cover),
      source: DocumentImportSource.scanner,
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
                      _AddDocumentPopupActionButton(
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
