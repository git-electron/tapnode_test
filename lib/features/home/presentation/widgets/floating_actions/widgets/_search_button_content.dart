part of '../../../home_screen.dart';

class _SearchButtonContent extends StatelessWidget {
  const _SearchButtonContent({
    required this.progress,
    required this.selectionMode,
    required this.controller,
    required this.focusNode,
  });

  final double progress;
  final bool selectionMode;
  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SearchButtonIcon(
          progress: progress,
          selectionMode: selectionMode,
        ),
        SizedBox(width: _SearchButton.iconTextGap * progress),
        Expanded(
          child: Opacity(
            opacity: progress,
            child: _SearchTextField(
              controller: controller,
              focusNode: focusNode,
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchButtonIcon extends StatelessWidget {
  const _SearchButtonIcon({
    required this.progress,
    required this.selectionMode,
  });

  final double progress;
  final bool selectionMode;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _SearchButton.lerp(
        _SearchButton.collapsedSize,
        _SearchButton.leftPadding + _SearchButton.iconSize,
        progress,
      ),
      height: _SearchButton.collapsedSize,
      child: Padding(
        padding: EdgeInsets.only(left: _SearchButton.leftPadding * progress),
        child: Align(
          alignment: Alignment.lerp(
            Alignment.center,
            Alignment.centerLeft,
            progress,
          )!,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: Icon(
              selectionMode ? CupertinoIcons.delete : CupertinoIcons.search,
              key: ValueKey(selectionMode),
              size: _SearchButton.iconSize,
              color: selectionMode
                  ? context.colors.error
                  : context.colors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
