import 'package:injectable/injectable.dart';

import '../../model/document_model.dart';
import 'document_import_service.dart';

@LazySingleton(as: DocumentImportService)
class DocumentImportServiceImpl implements DocumentImportService {
  const DocumentImportServiceImpl({
    required FileDocumentImporter fileImporter,
    required GalleryDocumentImporter galleryImporter,
    required ScannerDocumentImporter scannerImporter,
  }) : _fileImporter = fileImporter,
       _galleryImporter = galleryImporter,
       _scannerImporter = scannerImporter;

  final FileDocumentImporter _fileImporter;
  final GalleryDocumentImporter _galleryImporter;
  final ScannerDocumentImporter _scannerImporter;

  @override
  Future<DocumentImportDraft?> importFrom(DocumentImportSource source) {
    return switch (source) {
      DocumentImportSource.file => _fileImporter.import(),
      DocumentImportSource.gallery => _galleryImporter.import(),
      DocumentImportSource.scanner => _scannerImporter.import(),
    };
  }
}
