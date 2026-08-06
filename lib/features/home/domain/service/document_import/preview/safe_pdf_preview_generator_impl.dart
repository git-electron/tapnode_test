import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../pdf_preview/pdf_preview_service.dart';
import '../document_import_service.dart';

@LazySingleton(as: SafePdfPreviewGenerator)
class SafePdfPreviewGeneratorImpl implements SafePdfPreviewGenerator {
  const SafePdfPreviewGeneratorImpl({
    required PdfPreviewService previewService,
    required Logger logger,
  }) : _previewService = previewService,
       _logger = logger;

  final PdfPreviewService _previewService;
  final Logger _logger;

  @override
  Future<List<String>> generateForPdf(String pdfPath) async {
    try {
      return await _previewService.generateForPdf(pdfPath);
    } on Object catch (error, stackTrace) {
      _logger.w(
        'Document import: failed to generate PDF preview, '
        'document will be imported without previews: $pdfPath',
        error: error,
        stackTrace: stackTrace,
      );

      return const [];
    }
  }
}
