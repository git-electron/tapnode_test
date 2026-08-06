part of '../../../home_screen.dart';

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
