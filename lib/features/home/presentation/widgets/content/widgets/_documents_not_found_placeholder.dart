part of '../../../home_screen.dart';

class _DocumentsNotFoundPlaceholder extends StatelessWidget {
  const _DocumentsNotFoundPlaceholder();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          Assets.images.emptyPlaceholder.image(
            height: 160,
            opacity: const AlwaysStoppedAnimation(.62),
          ),
          const Gap(18),
          Text(
            'home.content.not_found_placeholder.title'.tr(),
            style: context.styles.header1,
          ),
          const Gap(10),
          Text(
            'home.content.not_found_placeholder.description'.tr(),
            style: context.styles.text1.copyWith(
              color: const Color(0xff303030).withValues(alpha: .4),
            ),
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}
