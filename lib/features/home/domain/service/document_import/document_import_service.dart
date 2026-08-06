import '../../model/document_model.dart';

abstract interface class DocumentImportService {
  Future<DocumentImportDraft?> importFrom(DocumentImportSource source);
}

abstract interface class DocumentImporter {
  Future<DocumentImportDraft?> import();
}

abstract interface class FileDocumentImporter implements DocumentImporter {}

abstract interface class GalleryDocumentImporter implements DocumentImporter {}

abstract interface class ScannerDocumentImporter implements DocumentImporter {}

abstract interface class PdfFilePicker {
  Future<String?> pickPdfPath();
}

abstract interface class GalleryImagePicker {
  Future<String?> pickImagePath();
}

abstract interface class DocumentScanner {
  Future<String?> scanPdfPath();
}

abstract interface class ImportedDocumentStorage {
  Future<String> copyPdf(String pdfPath);

  Future<ImportedGalleryImage> copyGalleryImage(String imagePath);
}

abstract interface class ImagePdfFactory {
  Future<void> createPdfFromImage({
    required String imagePath,
    required String pdfPath,
  });
}

abstract interface class SafePdfPreviewGenerator {
  Future<List<String>> generateForPdf(String pdfPath);
}

class ImportedGalleryImage {
  const ImportedGalleryImage({
    required this.pdfPath,
    required this.previewImagePath,
  });

  final String pdfPath;
  final String previewImagePath;
}
