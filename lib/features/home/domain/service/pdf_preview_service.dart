import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

abstract interface class PdfPreviewService {
  Future<List<String>> generateForPdf(String pdfPath);
}

@LazySingleton(as: PdfPreviewService)
class PdfxPreviewService implements PdfPreviewService {
  const PdfxPreviewService();

  static const _renderWidth = 512.0;

  @override
  Future<List<String>> generateForPdf(String pdfPath) async {
    final document = await PdfDocument.openFile(pdfPath);

    try {
      final pagesCount = document.pagesCount;
      if (pagesCount <= 0) return const [];

      final previewDirectory = await _previewDirectory();
      final firstPagePath = await _renderPage(
        document: document,
        pageNumber: 1,
        outputDirectory: previewDirectory,
        pdfPath: pdfPath,
      );

      if (pagesCount == 1) return [firstPagePath];

      final lastPagePath = await _renderPage(
        document: document,
        pageNumber: pagesCount,
        outputDirectory: previewDirectory,
        pdfPath: pdfPath,
      );

      return [firstPagePath, lastPagePath];
    } finally {
      await document.close();
    }
  }

  Future<Directory> _previewDirectory() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final previewDirectory = Directory(
      '${documentsDirectory.path}/document_previews',
    );

    if (!previewDirectory.existsSync()) {
      await previewDirectory.create(recursive: true);
    }

    return previewDirectory;
  }

  Future<String> _renderPage({
    required PdfDocument document,
    required int pageNumber,
    required Directory outputDirectory,
    required String pdfPath,
  }) async {
    final page = await document.getPage(pageNumber);

    try {
      final scale = _renderWidth / page.width;
      final image = await page.render(
        width: _renderWidth,
        height: page.height * scale,
        backgroundColor: '#FFFFFF',
      );
      final outputPath =
          '${outputDirectory.path}/${_fileName(pdfPath, pageNumber)}.jpg';

      await File(outputPath).writeAsBytes(image!.bytes, flush: true);

      return outputPath;
    } finally {
      await page.close();
    }
  }

  String _fileName(String pdfPath, int pageNumber) {
    final sanitizedPath = pdfPath
        .replaceAll(RegExp(r'[^a-zA-Z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_');
    final timestamp = DateTime.now().microsecondsSinceEpoch;

    return '${sanitizedPath}_${pageNumber}_$timestamp';
  }
}
