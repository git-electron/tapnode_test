import 'package:file_picker/file_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../model/document_model.dart';
import 'pdf_preview_service.dart';

abstract interface class DocumentImportService {
  Future<DocumentImportDraft?> pickFromFiles();

  Future<DocumentImportDraft?> pickFromGallery();

  Future<DocumentImportDraft?> scanWithCunningDocumentScanner();
}

@LazySingleton(as: DocumentImportService)
class StubDocumentImportService implements DocumentImportService {
  const StubDocumentImportService(
    this._pdfPreviewService,
    this._logger,
  );

  final PdfPreviewService _pdfPreviewService;
  final Logger _logger;

  @override
  Future<DocumentImportDraft?> pickFromFiles() async {
    _logger.i('Document import: opening PDF file picker');
    final pdfPath = await _pickPdfFilePath();
    if (pdfPath == null) {
      _logger.i('Document import: PDF file picker cancelled');
      return null;
    }

    _logger.i('Document import: picked PDF file: $pdfPath');

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
    _logger.i('Document import: building draft for $source: $pdfPath');
    final previewImagePaths = await _generatePreviewImagePaths(pdfPath);
    _logger.i(
      'Document import: generated ${previewImagePaths.length} preview(s): '
      '$previewImagePaths',
    );

    return DocumentImportDraft(
      title: _titleFromPath(pdfPath),
      filePath: pdfPath,
      source: source,
      previewImagePaths: previewImagePaths,
    );
  }

  Future<List<String>> _generatePreviewImagePaths(String pdfPath) async {
    try {
      return await _pdfPreviewService.generateForPdf(pdfPath);
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

  Future<String?> _pickPdfFilePath() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf'],
    );

    return result?.files.single.path;
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
