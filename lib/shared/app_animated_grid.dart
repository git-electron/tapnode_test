import 'dart:async';

import 'package:flutter/widgets.dart';

typedef AppAnimatedGridIdOf<T, K extends Object> = K Function(T item);
typedef AppAnimatedGridItemBuilder<T> =
    Widget Function(BuildContext context, T item);

class AppAnimatedGrid<T, K extends Object> extends StatefulWidget {
  const AppAnimatedGrid({
    super.key,
    required this.items,
    required this.idOf,
    required this.itemBuilder,
    this.animationDuration = const Duration(milliseconds: 500),
    this.padding = EdgeInsets.zero,
    this.crossAxisCount = 2,
    this.crossAxisSpacing = 19,
    this.mainAxisSpacing = 24,
    this.childAspectRatio = 150 / 240,
    this.positionCurve = Curves.easeOutExpo,
    this.opacityCurve = Curves.easeOutExpo,
    this.scaleCurve = Curves.easeOutExpo,
    this.hiddenScale = .8,
  });

  final List<T> items;
  final AppAnimatedGridIdOf<T, K> idOf;
  final AppAnimatedGridItemBuilder<T> itemBuilder;
  final Duration animationDuration;
  final EdgeInsets padding;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;
  final Curve positionCurve;
  final Curve opacityCurve;
  final Curve scaleCurve;
  final double hiddenScale;

  @override
  State<AppAnimatedGrid<T, K>> createState() => _AppAnimatedGridState<T, K>();
}

class _AppAnimatedGridState<T, K extends Object>
    extends State<AppAnimatedGrid<T, K>> {
  final List<_AppAnimatedGridEntry<T, K>> _entries = [];
  final List<Timer> _removeTimers = [];

  @override
  void initState() {
    super.initState();
    for (var index = 0; index < widget.items.length; index++) {
      final item = widget.items[index];
      _entries.add(
        _AppAnimatedGridEntry(
          item: item,
          id: widget.idOf(item),
          index: index,
        ),
      );
    }
  }

  @override
  void didUpdateWidget(covariant AppAnimatedGrid<T, K> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncItems(widget.items);
  }

  @override
  void dispose() {
    for (final timer in _removeTimers) {
      timer.cancel();
    }
    super.dispose();
  }

  void _syncItems(List<T> nextItems) {
    final currentVisibleEntries = _entries
        .where((entry) => !entry.removing)
        .toList(growable: false);
    final nextIds = nextItems.map(widget.idOf).toSet();
    final removingEntries = _entries.where((entry) => entry.removing).toList();
    final nextEntries = <_AppAnimatedGridEntry<T, K>>[];

    for (var index = 0; index < currentVisibleEntries.length; index++) {
      final entry = currentVisibleEntries[index];
      if (nextIds.contains(entry.id)) continue;

      entry
        ..removing = true
        ..index = index;
      removingEntries.add(entry);
      final timer = Timer(widget.animationDuration, () {
        if (!mounted) return;
        setState(() => _entries.remove(entry));
      });
      _removeTimers.add(timer);
    }

    for (var index = 0; index < nextItems.length; index++) {
      final nextItem = nextItems[index];
      final nextId = widget.idOf(nextItem);
      final existingEntry = currentVisibleEntries.firstWhere(
        (entry) => entry.id == nextId,
        orElse: () => _AppAnimatedGridEntry(
          item: nextItem,
          id: nextId,
          index: index,
          appearing: true,
        ),
      );

      existingEntry
        ..item = nextItem
        ..index = index;
      nextEntries.add(existingEntry);
    }

    setState(() {
      _entries
        ..clear()
        ..addAll(nextEntries)
        ..addAll(removingEntries);
    });

    for (final entry in nextEntries.where((entry) => entry.appearing)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() => entry.appearing = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.crossAxisCount > 0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalSpacing =
            widget.crossAxisSpacing * (widget.crossAxisCount - 1);
        final availableWidth =
            constraints.maxWidth - widget.padding.horizontal - totalSpacing;
        final itemWidth = availableWidth > 0
            ? availableWidth / widget.crossAxisCount
            : 0.0;
        final itemHeight = itemWidth / widget.childAspectRatio;
        final visibleCount = _entries.where((entry) => !entry.removing).length;
        final rows = (visibleCount / widget.crossAxisCount).ceil();
        final gapsCount = rows > 0 ? rows - 1 : 0;
        final contentHeight =
            widget.padding.top +
            widget.padding.bottom +
            rows * itemHeight +
            gapsCount * widget.mainAxisSpacing;

        return SingleChildScrollView(
          child: SizedBox(
            height: contentHeight < constraints.maxHeight
                ? constraints.maxHeight
                : contentHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                for (final entry in _entries)
                  _AppAnimatedGridPositionedItem<T, K>(
                    key: ValueKey(entry.id),
                    entry: entry,
                    itemWidth: itemWidth,
                    itemHeight: itemHeight,
                    widget: widget,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AppAnimatedGridPositionedItem<T, K extends Object>
    extends StatelessWidget {
  const _AppAnimatedGridPositionedItem({
    super.key,
    required this.entry,
    required this.itemWidth,
    required this.itemHeight,
    required this.widget,
  });

  final _AppAnimatedGridEntry<T, K> entry;
  final double itemWidth;
  final double itemHeight;
  final AppAnimatedGrid<T, K> widget;

  @override
  Widget build(BuildContext context) {
    final column = entry.index % widget.crossAxisCount;
    final row = entry.index ~/ widget.crossAxisCount;

    return AnimatedPositioned(
      duration: widget.animationDuration,
      curve: widget.positionCurve,
      left:
          widget.padding.left + column * (itemWidth + widget.crossAxisSpacing),
      top: widget.padding.top + row * (itemHeight + widget.mainAxisSpacing),
      width: itemWidth,
      height: itemHeight,
      child: AnimatedOpacity(
        duration: widget.animationDuration,
        curve: widget.opacityCurve,
        opacity: entry.removing || entry.appearing ? 0 : 1,
        child: AnimatedScale(
          duration: widget.animationDuration,
          curve: widget.scaleCurve,
          scale: entry.removing || entry.appearing ? widget.hiddenScale : 1,
          child: widget.itemBuilder(context, entry.item),
        ),
      ),
    );
  }
}

class _AppAnimatedGridEntry<T, K extends Object> {
  _AppAnimatedGridEntry({
    required this.item,
    required this.id,
    required this.index,
    this.appearing = false,
  });

  T item;
  final K id;
  int index;
  bool appearing;
  bool removing = false;
}
