part of '../home_screen.dart';

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
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
            _Logo(),
            _DropdownMenuButton(),
          ],
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

class _DropdownMenuButton extends StatelessWidget {
  const _DropdownMenuButton();

  @override
  Widget build(BuildContext context) {
    return GlassMenu(
      glowColor: context.colors.white,
      enableInteractionGlow: false,

      selectionColor: const Color(0x14000000),
      settings: LiquidGlassSettings(
        glassColor: const Color(0xF2FFFFFF),
        backerColor: const Color(0xCCFFFFFF),
        blur: 18,
        thickness: 28,
        whitenStrength: 0.75,
        whitenGated: false,
        shadow: [
          const BoxShadow(
            color: Color(0x80FFFFFF),
            blurRadius: 44,
            spreadRadius: 8,
            offset: Offset(0, 18),
          ),
          BoxShadow(
            color: context.colors.black.withValues(alpha: .08),
            blurRadius: 18,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      menuWidth: 262,
      menuHeight: 104,
      menuBorderRadius: 34,
      menuPadding: const Pad(vertical: 10, horizontal: 20, left: 20),
      menuAlignment: GlassMenuAlignment.topRight,
      items: [
        _DropdownMenuItem(
          onTap: () {},
          title: 'Select',
          icon: CupertinoIcons.check_mark_circled,
        ),
        _DropdownMenuItem(
          onTap: () {},
          title: 'Add Document',
          icon: CupertinoIcons.add_circled_solid,
        ),
      ],
      triggerBuilder: (context, toggleMenu) {
        return GlassIconButton(
          size: 38,
          borderRadius: 15.2,
          useOwnLayer: true,
          settings: const LiquidGlassSettings(),
          shape: GlassIconButtonShape.roundedSquare,
          icon: Icon(
            CupertinoIcons.ellipsis,
            color: context.colors.white,
            size: 19.55,
          ),
          onPressed: toggleMenu,
        );
      },
    );
  }
}

class _DropdownMenuItem extends StatelessWidget {
  const _DropdownMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlassMenuItem(
      height: 40,
      title: title,
      iconSize: 17,
      onTap: onTap,
      icon: Icon(icon),
      iconColor: context.colors.textPrimary,
      titleStyle: context.styles.dropdownMenu,
    );
  }
}
