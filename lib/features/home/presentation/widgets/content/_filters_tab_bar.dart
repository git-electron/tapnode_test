part of '../../home_screen.dart';

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
                _FilterDividers(selectedIndex: selectedIndex),
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

class _FilterDividers extends StatelessWidget {
  const _FilterDividers({required this.selectedIndex});

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: [
          for (var boundaryIndex = 1; boundaryIndex < 3; boundaryIndex++)
            _FilterDivider(
              boundaryIndex: boundaryIndex,
              isVisible: _isBetweenUnselectedTabs(boundaryIndex),
            ),
        ],
      ),
    );
  }

  bool _isBetweenUnselectedTabs(int boundaryIndex) {
    final leftTabIndex = boundaryIndex - 1;
    final rightTabIndex = boundaryIndex;
    return selectedIndex != leftTabIndex && selectedIndex != rightTabIndex;
  }
}

class _FilterDivider extends StatefulWidget {
  const _FilterDivider({
    required this.boundaryIndex,
    required this.isVisible,
  });

  final int boundaryIndex;
  final bool isVisible;

  @override
  State<_FilterDivider> createState() => _FilterDividerState();
}

class _FilterDividerState extends State<_FilterDivider>
    with SingleTickerProviderStateMixin {
  late final AnimationController _opacityController;

  @override
  void initState() {
    super.initState();
    _opacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      value: widget.isVisible ? 1 : 0,
    );
  }

  @override
  void didUpdateWidget(covariant _FilterDivider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isVisible == widget.isVisible) return;

    _opacityController.animateTo(
      widget.isVisible ? 1 : 0,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(-1 + 2 * widget.boundaryIndex / 3, 0),
      child: FadeTransition(
        opacity: _opacityController,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFF8E8E93).withValues(alpha: .3),
            borderRadius: BorderRadius.circular(.5),
          ),
          child: const SizedBox(
            width: 1,
            height: 28,
          ),
        ),
      ),
    );
  }
}
