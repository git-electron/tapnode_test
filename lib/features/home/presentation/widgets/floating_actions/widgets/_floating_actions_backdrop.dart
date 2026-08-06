part of '../../../home_screen.dart';

class _FloatingActionsBackdrop extends StatelessWidget {
  const _FloatingActionsBackdrop();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: BlocBuilder<FloatingActionsBloc, FloatingActionsState>(
        builder: (context, state) {
          return IgnorePointer(
            ignoring: !state.isAddDocumentsPopupOpen,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                context.read<FloatingActionsBloc>().add(
                  const FloatingActionsEvent.closeAddDocumentsPopup(),
                );
              },
              child: TweenAnimationBuilder<double>(
                tween: Tween(
                  end: state.isAddDocumentsPopupOpen ? 5 : 0,
                ),
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeInOutCubic,
                builder: (context, blur, child) {
                  return GlassContainer(
                    useOwnLayer: true,
                    settings: LiquidGlassSettings(blur: blur),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
