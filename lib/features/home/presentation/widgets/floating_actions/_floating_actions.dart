part of '../../home_screen.dart';

class _FloatingActions extends StatelessWidget {
  const _FloatingActions();

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
      child: Stack(
        children: [
          _FloatingActionsBackdrop(),
          _FloatingActionButtons(),
        ],
      ),
    );
  }
}

class _FloatingActionButtons extends StatelessWidget {
  const _FloatingActionButtons();

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        child: Padding(
          padding: Pad(all: 12),
          child: Row(
            children: [
              _SearchButton(),
              Gap(12),
              _AddDocumentButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _FloatingActionsBackdrop extends StatelessWidget {
  const _FloatingActionsBackdrop();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: BlocBuilder<FloatingActionsBloc, FloatingActionsState>(
        builder: (context, state) {
          return IgnorePointer(
            ignoring: !state.isAddDocumentsPopupOpen && !state.isSearchOpen,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (state.isAddDocumentsPopupOpen) {
                  context.read<FloatingActionsBloc>().add(
                    const FloatingActionsEvent.closeAddDocumentsPopup(),
                  );
                  return;
                }

                if (state.searchText.isNotEmpty) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  return;
                }

                context.read<FloatingActionsBloc>().add(
                  const FloatingActionsEvent.closeSearch(),
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
