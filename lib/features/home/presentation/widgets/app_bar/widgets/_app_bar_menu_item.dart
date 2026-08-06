part of '../../../home_screen.dart';

class _AppBarMenuItem extends StatelessWidget {
  const _AppBarMenuItem({
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
