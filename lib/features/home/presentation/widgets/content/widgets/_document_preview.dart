part of '../../../home_screen.dart';

class _DocumentPreview extends StatelessWidget {
  const _DocumentPreview({required this.document});

  final DocumentModel document;

  static const _height = 167.0;
  static const _width = 150.0;

  @override
  Widget build(BuildContext context) {
    if (document.hasDoublePreviewImages) {
      return SizedBox(
        height: _height,
        width: _width,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _DocumentImagePreview(path: document.lastPreviewImagePath!),
            Positioned(
              left: 12,
              child: Transform.rotate(
                angle: 7.35 * pi / 180,
                child: _DocumentImagePreview(
                  path: document.firstPreviewImagePath!,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (document.hasSinglePreviewImage) {
      return SizedBox(
        height: _height,
        width: _width,
        child: Center(
          child: _DocumentImagePreview(path: document.firstPreviewImagePath!),
        ),
      );
    }

    return const SizedBox(
      height: _height,
      width: _width,
      child: Center(
        child: _DocumentImagePreview.broken(),
      ),
    );
  }
}
