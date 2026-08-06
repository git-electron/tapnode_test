part of '../../../home_screen.dart';

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
