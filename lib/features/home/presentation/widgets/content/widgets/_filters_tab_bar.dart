part of '../../../home_screen.dart';

class _FiltersTabBar extends StatelessWidget {
  const _FiltersTabBar();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentsBloc, DocumentsState>(
      buildWhen: (previous, current) => previous.filter != current.filter,
      builder: (context, state) {
        final selectedIndex = _selectedIndexForFilter(state.filter);

        return Padding(
          padding: const Pad(all: 16),
          child: SizedBox(
            height: 36,
            child: Stack(
              fit: StackFit.expand,
              children: [
                GlassSegmentedControl(
                  segments: const [
                    GlassSegment(label: 'All'),
                    GlassSegment(label: 'Signed'),
                    GlassSegment(label: 'Unsigned'),
                  ],
                  selectedIndex: selectedIndex,
                  onSegmentSelected: (index) {
                    context.read<DocumentsBloc>().add(
                      DocumentsEvent.filterChanged(_filterForIndex(index)),
                    );
                  },
                  height: 36,
                  borderRadius: 18,
                  indicatorBorderRadius: 18,
                  padding: const Pad(all: 4),
                  backgroundColor: context.colors.inactiveButton.withValues(
                    alpha: .12,
                  ),
                  indicatorColor: context.colors.white,
                  selectedTextStyle: context.styles.header3.copyWith(
                    color: context.colors.textPrimary,
                  ),
                  unselectedTextStyle: context.styles.header3.copyWith(
                    color: context.colors.textPrimary,
                  ),
                  quality: GlassQuality.premium,
                ),
                _FiltersTabBarDividers(selectedIndex: selectedIndex),
              ],
            ),
          ),
        );
      },
    );
  }

  int _selectedIndexForFilter(DocumentsFilter filter) {
    return switch (filter) {
      DocumentsFilter.all => 0,
      DocumentsFilter.signed => 1,
      DocumentsFilter.unsigned => 2,
    };
  }

  DocumentsFilter _filterForIndex(int index) {
    return switch (index) {
      1 => DocumentsFilter.signed,
      2 => DocumentsFilter.unsigned,
      _ => DocumentsFilter.all,
    };
  }
}
