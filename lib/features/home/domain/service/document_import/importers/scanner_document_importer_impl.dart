import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../../model/document_model.dart';
import '../document_import_service.dart';
import '../utils/path_utils.dart';

@LazySingleton(as: ScannerDocumentImporter)
class ScannerDocumentImporterImpl implements ScannerDocumentImporter {
  const ScannerDocumentImporterImpl({
    required DocumentScanner scanner,
    required ImportedDocumentStorage storage,
    required SafePdfPreviewGenerator previewGenerator,
    required Logger logger,
  }) : _scanner = scanner,
       _storage = storage,
       _previewGenerator = previewGenerator,
       _logger = logger;

  final DocumentScanner _scanner;
  final ImportedDocumentStorage _storage;
  final SafePdfPreviewGenerator _previewGenerator;
  final Logger _logger;

  @override
  Future<DocumentImportDraft?> import() async {
    _logger.i('Document import: opening document scanner as PDF');
    final pdfPath = await _scanner.scanPdfPath();
    if (pdfPath == null) {
      _logger.i('Document import: scanner cancelled');
      return null;
    }

    _logger.i('Document import: scanner PDF ready: $pdfPath');
    final importedPdfPath = await _storage.copyPdf(pdfPath);
    final previewImagePaths = await _previewGenerator.generateForPdf(
      importedPdfPath,
    );

    return DocumentImportDraft(
      title: documentImportTitleFromPath(importedPdfPath),
      filePath: importedPdfPath,
      source: DocumentImportSource.scanner,
      previewImagePaths: previewImagePaths,
    );
  }
}
