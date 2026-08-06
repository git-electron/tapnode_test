import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

abstract interface class PdfPreviewService {
  Future<List<String>> generateForPdf(String pdfPath);
}

@LazySingleton(as: PdfPreviewService)
class PdfxPreviewService implements PdfPreviewService {
  const PdfxPreviewService(this._logger);

  final Logger _logger;
  static const _renderWidth = 512.0;

  @override
  Future<List<String>> generateForPdf(String pdfPath) async {
    _logger.i('PDF preview: opening document: $pdfPath');
    final document = await PdfDocument.openFile(pdfPath);

    try {
      final pagesCount = document.pagesCount;
      _logger.i('PDF preview: pages count: $pagesCount');
      if (pagesCount <= 0) {
        _logger.w('PDF preview: document has no pages: $pdfPath');
        return const [];
      }

      final previewDirectory = await _previewDirectory();
      _logger.i('PDF preview: output directory: ${previewDirectory.path}');
      final firstPagePath = await _renderPage(
        document: document,
        pageNumber: 1,
        outputDirectory: previewDirectory,
        pdfPath: pdfPath,
      );

      if (pagesCount == 1) {
        _logger.i('PDF preview: single-page PDF, generated: $firstPagePath');
        return [firstPagePath];
      }

      final lastPagePath = await _renderPage(
        document: document,
        pageNumber: pagesCount,
        outputDirectory: previewDirectory,
        pdfPath: pdfPath,
      );

      final previewPaths = [firstPagePath, lastPagePath];
      _logger.i('PDF preview: generated previews: $previewPaths');
      return previewPaths;
    } finally {
      await document.close();
      _logger.i('PDF preview: closed document: $pdfPath');
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
    _logger.i('PDF preview: rendering page $pageNumber');
    final page = await document.getPage(pageNumber);

    try {
      final scale = _renderWidth / page.width;
      final renderHeight = page.height * scale;
      _logger.i(
        'PDF preview: page $pageNumber size ${page.width}x${page.height}, '
        'render ${_renderWidth}x$renderHeight',
      );
      final image = await page.render(
        width: _renderWidth,
        height: renderHeight,
        backgroundColor: '#FFFFFF',
      );
      final outputPath =
          '${outputDirectory.path}/${_fileName(pdfPath, pageNumber)}.jpg';

      if (image == null) {
        throw StateError(
          'PDF preview render returned null for page $pageNumber',
        );
      }

      await File(outputPath).writeAsBytes(image.bytes, flush: true);
      _logger.i(
        'PDF preview: wrote page $pageNumber preview '
        '(${image.bytes.length} bytes): $outputPath',
      );

      return outputPath;
    } finally {
      await page.close();
      _logger.i('PDF preview: closed page $pageNumber');
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
