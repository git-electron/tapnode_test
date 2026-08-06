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
              label: 'Files',
              icon: Assets.images.files.image(),
              onTap: () => _requestImport(
                context,
                DocumentImportSource.file,
              ),
            ),
            const Gap(12),
            AppGlassButton(
              label: 'Photos',
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
          label: 'Scanner',
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
