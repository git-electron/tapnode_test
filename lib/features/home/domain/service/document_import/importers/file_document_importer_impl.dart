import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../../model/document_model.dart';
import '../document_import_service.dart';
import '../utils/path_utils.dart';

@LazySingleton(as: FileDocumentImporter)
class FileDocumentImporterImpl implements FileDocumentImporter {
  const FileDocumentImporterImpl({
    required PdfFilePicker picker,
    required ImportedDocumentStorage storage,
    required SafePdfPreviewGenerator previewGenerator,
    required Logger logger,
  }) : _picker = picker,
       _storage = storage,
       _previewGenerator = previewGenerator,
       _logger = logger;

  final PdfFilePicker _picker;
  final ImportedDocumentStorage _storage;
  final SafePdfPreviewGenerator _previewGenerator;
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
    final previewImagePaths = await _previewGenerator.generateForPdf(
      importedPdfPath,
    );

    return DocumentImportDraft(
      title: documentImportTitleFromPath(importedPdfPath),
      filePath: importedPdfPath,
      source: DocumentImportSource.file,
      previewImagePaths: previewImagePaths,
    );
  }
}
