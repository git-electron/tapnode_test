part of '../home_screen.dart';

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return const _EmptyPlaceholder();
  }
}

class _EmptyPlaceholder extends StatelessWidget {
  const _EmptyPlaceholder();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.images.emptyPlaceholder.image(height: 160),
          const Gap(18),
          Text(
            'No Documents Yet',
            style: context.styles.header1,
          ),
          const Gap(10),
          Text(
            'Your can add documents from',
            style: context.styles.text1.copyWith(
              color: const Color(0xff303030).withValues(alpha: .3),
            ),
          ),
          const Gap(18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppGlassButton(
                label: 'Files',
                icon: Assets.images.files.image(),
                onTap: () {},
              ),
              const Gap(12),
              AppGlassButton(
                label: 'Photos',
                icon: Assets.images.gallery.image(),
                onTap: () {},
              ),
            ],
          ),
          const Gap(12),
          AppGlassButton(
            label: 'Scanner',
            icon: Assets.images.camera.image(),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
