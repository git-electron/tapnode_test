part of '../../home_screen.dart';

class _SearchButton extends StatelessWidget {
  const _SearchButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FloatingActionsBloc, FloatingActionsState>(
      builder: (context, state) {
        return IgnorePointer(
          ignoring: state.isAddDocumentsPopupOpen,
          child: AnimatedOpacity(
            opacity: state.isAddDocumentsPopupOpen ? 0 : 1,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOutCubic,
            child: AnimatedScale(
              scale: state.isAddDocumentsPopupOpen ? .88 : 1,
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOutCubic,
              child: GlassButton.custom(
                height: 63,
                width: 63,
                label: 'Search',
                onTap: () {
                  context.read<FloatingActionsBloc>().add(
                    state.isSearchOpen
                        ? const FloatingActionsEvent.closeSearch()
                        : const FloatingActionsEvent.openSearch(),
                  );
                },
                shape: const LiquidRoundedRectangle(borderRadius: 61 / 2),
                interactionScale: .97,
                stretch: .28,
                resistance: .04,
                glowColor: context.colors.white,
                glowRadius: 1.2,
                glowOpacity: .3,
                child: const Icon(CupertinoIcons.search),
              ),
            ),
          ),
        );
      },
    );
  }
}
