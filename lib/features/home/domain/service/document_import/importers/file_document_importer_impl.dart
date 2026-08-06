import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../../model/document_model.dart';
import '../../pdf_preview/pdf_preview_service.dart';
import '../utils/path_utils.dart';
import '../document_import_service.dart';

@LazySingleton(as: FileDocumentImporter)
class FileDocumentImporterImpl implements FileDocumentImporter {
  const FileDocumentImporterImpl({
    required PdfFilePicker picker,
    required ImportedDocumentStorage storage,
    required PdfPreviewService previewService,
    required Logger logger,
  }) : _picker = picker,
       _storage = storage,
       _previewService = previewService,
       _logger = logger;

  final PdfFilePicker _picker;
  final ImportedDocumentStorage _storage;
  final PdfPreviewService _previewService;
  final Logger _logger;

  @override
  Future<DocumentImportDraft?> import() async {
    _logger.i('Document import: opening PDF file picker');
    final pdfPath = await _picker.pickPdfPath();
    if (pdfPath == null) {
      _logger.i('Document import: PDF file picker cancelled');
      return null;
    }

    _logger.i('Document import: picked PDF file: $pdfPath');
    final importedPdfPath = await _storage.copyPdf(pdfPath);
    final previewImagePaths = await _generatePreviewImagePaths(importedPdfPath);

    return DocumentImportDraft(
      title: documentImportTitleFromPath(importedPdfPath),
      filePath: importedPdfPath,
      source: DocumentImportSource.file,
      previewImagePaths: previewImagePaths,
    );
  }

  Future<List<String>> _generatePreviewImagePaths(String pdfPath) async {
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
