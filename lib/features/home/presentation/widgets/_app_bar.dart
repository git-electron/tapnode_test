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
                  style: context.styles.logo.copyWith(
                    color: context.colors.white,
                  ),
                ),
              ],
            ),
            GlassMenu(
              glowColor: context.colors.white,
              settings: const LiquidGlassSettings(
                glassColor: Color(0xF2FFFFFF),
                backerColor: Color(0xCCFFFFFF),
                blur: 18,
                thickness: 28,
                whitenStrength: 0.75,
                whitenGated: false,
                shadow: [
                  BoxShadow(
                    color: Color(0x80FFFFFF),
                    blurRadius: 44,
                    spreadRadius: 8,
                    offset: Offset(0, 18),
                  ),
                  BoxShadow(
                    color: Color(0x59FFFFFF),
                    blurRadius: 18,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              menuWidth: 262,
              menuHeight: 100,
              menuBorderRadius: 34,
              menuPadding: const Pad(vertical: 10, horizontal: 20, left: 20),
              menuAlignment: GlassMenuAlignment.topRight,
              items: const [
                _AppMenuItem(
                  title: 'Select',
                  icon: CupertinoIcons.check_mark_circled,
                ),
                _AppMenuItem(
                  title: 'Add Document',
                  icon: CupertinoIcons.add_circled_solid,
                ),
              ],
              triggerBuilder: (context, toggleMenu) {
                return GlassIconButton(
                  size: 38,
                  borderRadius: 15.2,
                  shape: GlassIconButtonShape.roundedSquare,
                  icon: Icon(
                    CupertinoIcons.ellipsis,
                    color: context.colors.white,
                    size: 19.55,
                  ),
                  semanticLabel: 'Open menu',
                  onPressed: toggleMenu,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AppMenuItem extends StatelessWidget {
  const _AppMenuItem({
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final color = context.colors.textPrimary;

    return GlassMenuItem(
      title: title,
      height: 40,
      iconSize: 17,
      iconColor: color,
      titleStyle: context.styles.dropdownMenu,
      icon: Icon(icon),
      onTap: () {},
    );
  }
}
