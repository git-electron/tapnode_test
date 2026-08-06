part of '../home_screen.dart';

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: context.colors.background),
        Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: 36,
            width: double.maxFinite,
            child: ColoredBox(color: context.colors.appBar),
          ),
        ),
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(36),
          ),
          child: ColoredBox(
            color: context.colors.background,
            child: const Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      _Content(),
                      _ContentScrollFade(),
                      _FiltersTabBar(),
                      _FloatingActions(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ContentScrollFade extends StatelessWidget {
  const _ContentScrollFade();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 80,
        width: double.maxFinite,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                context.colors.white.withValues(alpha: .9),
                context.colors.white.withValues(alpha: .9),
                context.colors.white.withValues(alpha: 0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
    );
  }
}
