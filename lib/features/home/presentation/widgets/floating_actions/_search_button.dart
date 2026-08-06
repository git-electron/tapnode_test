part of '../../home_screen.dart';

class _SearchButton extends StatelessWidget {
  const _SearchButton();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<FloatingActionsBloc, FloatingActionsState, bool>(
      selector: (state) => state.isSearchOpen,
      builder: (context, isSearchOpen) {
        return GlassButton.custom(
          height: 63,
          width: 63,
          label: 'Search',
          onTap: () {
            context.read<FloatingActionsBloc>().add(
              isSearchOpen
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
        );
      },
    );
  }
}
