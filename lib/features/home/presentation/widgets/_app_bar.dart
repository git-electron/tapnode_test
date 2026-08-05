part of '../home_screen.dart';

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 66,
      child: Padding(
        padding: const Pad(
          top: 12,
          left: 18,
          right: 16,
          bottom: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 10,
              children: [
                Assets.images.logo.image(
                  fit: BoxFit.fitHeight,
                  height: 38,
                  width: 38,
                ),
                Text(
                  'Signica',
                  style: context.styles.logo.copyWith(color: context.colors.white),
                ),
              ],
            ),
            GlassIconButton(
              size: 38,
              borderRadius: 15.2,
              shape: GlassIconButtonShape.roundedSquare,
              icon: Icon(
                CupertinoIcons.ellipsis,
                color: context.colors.white,
                size: 19.55,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
