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
