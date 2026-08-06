import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../model/document_model.dart';
import 'pdf_preview_service.dart';

abstract interface class DocumentImportService {
  Future<DocumentImportDraft?> pickFromFiles();

  Future<DocumentImportDraft?> pickFromGallery();

  Future<DocumentImportDraft?> scanWithCunningDocumentScanner();
}

@LazySingleton(as: DocumentImportService)
class DefaultDocumentImportService implements DocumentImportService {
  const DefaultDocumentImportService(
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
    final importedPdfPath = await _copyPdfToDocumentsDirectory(pdfPath);
    final previewImagePaths = await _generatePreviewImagePaths(importedPdfPath);
    _logger.i(
      'Document import: generated ${previewImagePaths.length} preview(s): '
      '$previewImagePaths',
    );

    return DocumentImportDraft(
      title: _titleFromPath(importedPdfPath),
      filePath: importedPdfPath,
      source: source,
      previewImagePaths: previewImagePaths,
    );
  }

  Future<String> _copyPdfToDocumentsDirectory(String pdfPath) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final importsDirectory = Directory('${documentsDirectory.path}/documents');

    if (!importsDirectory.existsSync()) {
      await importsDirectory.create(recursive: true);
    }

    final outputPath = _uniqueImportedPdfPath(importsDirectory, pdfPath);

    _logger.i('Document import: copying PDF to app storage: $outputPath');
    final copiedFile = await File(pdfPath).copy(outputPath);
    _logger.i(
      'Document import: copied PDF exists=${copiedFile.existsSync()}, '
      'size=${copiedFile.lengthSync()} bytes',
    );

    return copiedFile.path;
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
    final fileName = _fileNameFromPath(path);
    final extensionIndex = fileName.lastIndexOf('.');

    if (extensionIndex <= 0) return fileName;

    return fileName.substring(0, extensionIndex);
  }

  String _uniqueImportedPdfPath(Directory directory, String sourcePath) {
    final title = _titleFromPath(sourcePath).trim();
    final baseName = title.isEmpty ? 'Document' : title;
    final extension = _extensionFromPath(sourcePath);
    var candidatePath = '${directory.path}/$baseName$extension';

    if (!File(candidatePath).existsSync()) return candidatePath;

    var index = 2;
    while (true) {
      candidatePath = '${directory.path}/$baseName $index$extension';
      if (!File(candidatePath).existsSync()) return candidatePath;
      index++;
    }
  }

  String _fileNameFromPath(String path) {
    final normalizedPath = path.replaceAll(r'\', '/');

    return normalizedPath.split('/').last;
  }

  String _extensionFromPath(String path) {
    final fileName = _fileNameFromPath(path);
    final extensionIndex = fileName.lastIndexOf('.');

    if (extensionIndex <= 0 || extensionIndex == fileName.length - 1) {
      return '.pdf';
    }

    return fileName.substring(extensionIndex);
  }
}
