part of '../../../home_screen.dart';

class _AddDocumentPopupActionButton extends StatelessWidget {
  const _AddDocumentPopupActionButton({
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
          _lerp(58, 0, itemProgress),
          _lerp(64 + index * 14, 0, itemProgress),
        ),
        child: Transform.scale(
          scale: _lerp(.86, 1, itemProgress),
          alignment: Alignment.centerRight,
          child: AppGlassButton(
            width: _AddDocumentPopupActions._width,
            icon: action.icon,
            label: action.label,
            onTap: () => _requestImport(context),
          ),
        ),
      ),
    );
  }

  void _requestImport(BuildContext context) {
    context.read<DocumentsBloc>().add(
      DocumentsEvent.importRequested(action.source),
    );
    context.read<FloatingActionsBloc>().add(
      const FloatingActionsEvent.closeAddDocumentsPopup(),
    );
  }

  double _delayedProgress(double value, double start, bool isOpen) {
    if (value <= start) return 0;
    if (value >= 1) return 1;

    final shiftedValue = ((value - start) / (1 - start)).clamp(0.0, 1.0);
    if (isOpen) return Curves.easeOutExpo.transform(shiftedValue);

    return 1 - Curves.easeOutExpo.transform(1 - shiftedValue);
  }

  double _lerp(double begin, double end, double progress) {
    return begin + (end - begin) * progress;
  }
}
