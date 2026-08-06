part of '../../../home_screen.dart';

class _DocumentQuickActionsMenuItem extends StatelessWidget {
  const _DocumentQuickActionsMenuItem({
    required this.onPrint,
    required this.onShare,
  });

  final VoidCallback onPrint;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          Expanded(
            child: _DocumentQuickActionButton(
              icon: CupertinoIcons.printer_fill,
              label: 'Print',
              onTap: onPrint,
            ),
          ),
          const Gap(6),
          Expanded(
            child: _DocumentQuickActionButton(
              icon: CupertinoIcons.share,
              label: 'Share',
              onTap: onShare,
            ),
          ),
        ],
      ),
    );
  }
}

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

class _DocumentMenuDivider extends StatelessWidget {
  const _DocumentMenuDivider();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 21,
      child: Center(
        child: Padding(
          padding: Pad(horizontal: 12),
          child: SizedBox(
            height: 1,
            width: double.maxFinite,
            child: ColoredBox(
              color: Color(0xffE6E6E6),
            ),
          ),
        ),
      ),
    );
  }
}

class _DocumentDeleteMenuButton extends StatelessWidget {
  const _DocumentDeleteMenuButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tappable(
      scale: .98,
      duration: const Duration(milliseconds: 180),
      onTap: onTap,
      child: SizedBox(
        height: 40,
        child: Padding(
          padding: const Pad(horizontal: 20),
          child: Row(
            children: [
              const SizedBox(
                width: 28,
                child: Icon(
                  CupertinoIcons.delete,
                  size: 20,
                  color: CupertinoColors.systemRed,
                ),
              ),
              const Gap(8),
              Text(
                'Delete',
                style: context.styles.dropdownMenu.copyWith(
                  color: CupertinoColors.systemRed,
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
