part of '../../home_screen.dart';

class _EmptyPlaceholder extends StatelessWidget {
  const _EmptyPlaceholder();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
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
              color: const Color(0xff303030).withValues(alpha: .4),
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
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}
