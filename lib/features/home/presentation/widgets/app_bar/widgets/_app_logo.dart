part of '../../../home_screen.dart';

class _AppLogo extends StatelessWidget {
  const _AppLogo({super.key});

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
