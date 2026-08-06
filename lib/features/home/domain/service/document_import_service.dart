import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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
    _logger.i('Document import: opening gallery image picker');
    final imagePath = await _pickGalleryImagePath();
    if (imagePath == null) {
      _logger.i('Document import: gallery image picker cancelled');
      return null;
    }

    _logger.i('Document import: picked gallery image: $imagePath');

    return _buildGalleryImageDraft(imagePath);
  }

  @override
  Future<DocumentImportDraft?> scanWithCunningDocumentScanner() async {
    _logger.i('Document import: opening cunning document scanner as PDF');
    final pdfPath = await _scanPdfPathWithCunningDocumentScanner();
    if (pdfPath == null) {
      _logger.i('Document import: scanner cancelled');
      return null;
    }

    _logger.i('Document import: scanner PDF ready: $pdfPath');

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
    final importsDirectory = await _documentsDirectory();

    final outputPath = _uniqueImportedPdfPath(importsDirectory, pdfPath);

    _logger.i('Document import: copying PDF to app storage: $outputPath');
    final copiedFile = await File(pdfPath).copy(outputPath);
    _logger.i(
      'Document import: copied PDF exists=${copiedFile.existsSync()}, '
      'size=${copiedFile.lengthSync()} bytes',
    );

    return copiedFile.path;
  }

  Future<DocumentImportDraft> _buildGalleryImageDraft(String imagePath) async {
    final documentsDirectory = await _documentsDirectory();
    final previewDirectory = await _previewDirectory();
    final imageExtension = _imageExtensionFromPath(imagePath);
    final pdfPath = _uniqueImportedPath(
      directory: documentsDirectory,
      sourcePath: 'Photo.pdf',
      extension: '.pdf',
    );
    final previewPath = _uniqueImportedPath(
      directory: previewDirectory,
      sourcePath: 'Photo$imageExtension',
      extension: imageExtension,
    );

    _logger.i('Document import: copying gallery image preview: $previewPath');
    final previewFile = await File(imagePath).copy(previewPath);
    _logger.i(
      'Document import: copied gallery preview exists=${previewFile.existsSync()}, '
      'size=${previewFile.lengthSync()} bytes',
    );

    await _createPdfFromImage(
      imagePath: previewFile.path,
      pdfPath: pdfPath,
    );

    return DocumentImportDraft(
      title: _titleFromPath(pdfPath),
      filePath: pdfPath,
      source: DocumentImportSource.gallery,
      previewImagePaths: [previewFile.path],
    );
  }

  Future<void> _createPdfFromImage({
    required String imagePath,
    required String pdfPath,
  }) async {
    _logger.i('Document import: creating PDF from image: $pdfPath');
    final imageBytes = await File(imagePath).readAsBytes();
    final pdf = pw.Document();
    final image = pw.MemoryImage(imageBytes);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (context) {
          return pw.Center(
            child: pw.Image(
              image,
            ),
          );
        },
      ),
    );

    final pdfFile = File(pdfPath);
    await pdfFile.writeAsBytes(await pdf.save(), flush: true);
    _logger.i(
      'Document import: created gallery PDF exists=${pdfFile.existsSync()}, '
      'size=${pdfFile.lengthSync()} bytes',
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

  Future<String?> _pickGalleryImagePath() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      requestFullMetadata: false,
    );

    return image?.path;
  }

  Future<String?> _scanPdfPathWithCunningDocumentScanner() async {
    final paths = await CunningDocumentScanner.getPictures(
      scannerSource: ScannerSource.camera,
      asPdf: true,
    );
    if (paths == null || paths.isEmpty) return null;

    return paths.first;
  }

  String _titleFromPath(String path) {
    final fileName = _fileNameFromPath(path);
    final extensionIndex = fileName.lastIndexOf('.');

    if (extensionIndex <= 0) return fileName;

    return fileName.substring(0, extensionIndex);
  }

  String _uniqueImportedPdfPath(Directory directory, String sourcePath) {
    return _uniqueImportedPath(
      directory: directory,
      sourcePath: sourcePath,
      extension: _extensionFromPath(sourcePath),
    );
  }

  String _uniqueImportedPath({
    required Directory directory,
    required String sourcePath,
    required String extension,
  }) {
    final title = _titleFromPath(sourcePath).trim();
    final baseName = title.isEmpty ? 'Document' : title;
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

  String _imageExtensionFromPath(String path) {
    final extension = _extensionFromPath(path).toLowerCase();
    if (extension == '.jpg' ||
        extension == '.jpeg' ||
        extension == '.png' ||
        extension == '.webp') {
      return extension;
    }

    return '.jpg';
  }

  Future<Directory> _documentsDirectory() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();

    return _ensureDirectory('${documentsDirectory.path}/documents');
  }

  Future<Directory> _previewDirectory() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();

    return _ensureDirectory('${documentsDirectory.path}/document_previews');
  }

  Future<Directory> _ensureDirectory(String path) async {
    final directory = Directory(path);
    if (!directory.existsSync()) {
      await directory.create(recursive: true);
    }

    return directory;
  }
}
