part of '../../../home_screen.dart';

class _EmptyPlaceholderImportActions extends StatelessWidget {
  const _EmptyPlaceholderImportActions();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppGlassButton(
              label: 'home.content.empty_placeholder.buttons.files'.tr(),
              icon: Assets.images.files.image(),
              onTap: () => _requestImport(
                context,
                DocumentImportSource.file,
              ),
            ),
            const Gap(12),
            AppGlassButton(
              label: 'home.content.empty_placeholder.buttons.photos'.tr(),
              icon: Assets.images.gallery.image(),
              onTap: () => _requestImport(
                context,
                DocumentImportSource.gallery,
              ),
            ),
          ],
        ),
        const Gap(12),
        AppGlassButton(
          label: 'home.content.empty_placeholder.buttons.scanner'.tr(),
          icon: Assets.images.camera.image(),
          onTap: () => _requestImport(
            context,
            DocumentImportSource.scanner,
          ),
        ),
      ],
    );
  }

  void _requestImport(
    BuildContext context,
    DocumentImportSource source,
  ) {
    context.read<DocumentsBloc>().add(
      DocumentsEvent.importRequested(source),
    );
  }
}
