part of '../../../home_screen.dart';

class _FiltersTabBarDividers extends StatelessWidget {
  const _FiltersTabBarDividers({required this.selectedIndex});

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: [
          for (var boundaryIndex = 1; boundaryIndex < 3; boundaryIndex++)
            _FiltersTabBarDivider(
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

class _FiltersTabBarDivider extends StatefulWidget {
  const _FiltersTabBarDivider({
    required this.boundaryIndex,
    required this.isVisible,
  });

  final int boundaryIndex;
  final bool isVisible;

  @override
  State<_FiltersTabBarDivider> createState() => _FiltersTabBarDividerState();
}

class _FiltersTabBarDividerState extends State<_FiltersTabBarDivider>
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
  void didUpdateWidget(covariant _FiltersTabBarDivider oldWidget) {
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
