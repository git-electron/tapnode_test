part of '../../../home_screen.dart';

class _DocumentQuickActionButton extends StatelessWidget {
  const _DocumentQuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tappable(
      scale: .96,
      duration: const Duration(milliseconds: 180),
      onTap: onTap,
      child: SizedBox(
        height: 56,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: context.colors.textPrimary,
            ),
            const Gap(4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.styles.dropdownMenu2,
            ),
          ],
        ),
      ),
    );
  }
}
