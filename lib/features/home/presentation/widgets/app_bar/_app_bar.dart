part of '../../home_screen.dart';

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.colors.appBar,
      child: const SafeArea(
        bottom: false,
        child: SizedBox(
          height: 66,
          child: Padding(
            padding: Pad(
              top: 12,
              left: 18,
              right: 16,
              bottom: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _AppBarLeading(),
                _AppBarMenuButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
