import 'package:injectable/injectable.dart';

import '../model/document_model.dart';
import 'pdf_preview_service.dart';

abstract interface class DocumentImportService {
  Future<DocumentImportDraft?> pickFromFiles();

  Future<DocumentImportDraft?> pickFromGallery();

  Future<DocumentImportDraft?> scanWithCunningDocumentScanner();
}

@LazySingleton(as: DocumentImportService)
class StubDocumentImportService implements DocumentImportService {
  const StubDocumentImportService(this._pdfPreviewService);

  final PdfPreviewService _pdfPreviewService;

  @override
  Future<DocumentImportDraft?> pickFromFiles() async {
    // TODO: Wire file picker and pass selected PDF path into _buildPdfDraft.
    final pdfPath = await _pickPdfFilePath();
    if (pdfPath == null) return null;

    return _buildPdfDraft(
      pdfPath: pdfPath,
      source: DocumentImportSource.file,
    );
  }

  @override
  Future<DocumentImportDraft?> pickFromGallery() async {
    // TODO: Wire gallery picker. Gallery imports intentionally skip PDF preview
    // generation because the imported image is already the visual preview.
    return null;
  }

  @override
  Future<DocumentImportDraft?> scanWithCunningDocumentScanner() async {
    // TODO: Wire cunning_document_scanner and pass produced PDF path into
    // _buildPdfDraft.
    final pdfPath = await _scanPdfPathWithCunningDocumentScanner();
    if (pdfPath == null) return null;

    return _buildPdfDraft(
      pdfPath: pdfPath,
      source: DocumentImportSource.scanner,
    );
  }

  Future<DocumentImportDraft> _buildPdfDraft({
    required String pdfPath,
    required DocumentImportSource source,
  }) async {
    final previewImagePaths = await _pdfPreviewService.generateForPdf(pdfPath);

    return DocumentImportDraft(
      title: _titleFromPath(pdfPath),
      filePath: pdfPath,
      source: source,
      previewImagePaths: previewImagePaths,
    );
  }

  Future<String?> _pickPdfFilePath() async {
    return null;
  }

  Future<String?> _scanPdfPathWithCunningDocumentScanner() async {
    return null;
  }

  String _titleFromPath(String path) {
    final normalizedPath = path.replaceAll(r'\', '/');
    final fileName = normalizedPath.split('/').last;
    final extensionIndex = fileName.lastIndexOf('.');

    if (extensionIndex <= 0) return fileName;

    return fileName.substring(0, extensionIndex);
  }
}
