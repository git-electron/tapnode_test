import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../document_import_service.dart';
import '../utils/path_utils.dart';

@LazySingleton(as: ImportedDocumentStorage)
class ImportedDocumentStorageImpl implements ImportedDocumentStorage {
  const ImportedDocumentStorageImpl(this._logger);

  final Logger _logger;

  @override
  Future<String> copyPdf(String pdfPath) async {
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

  @override
  Future<ImportedGalleryImage> copyGalleryImage(String imagePath) async {
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

    return ImportedGalleryImage(
      pdfPath: pdfPath,
      previewImagePath: previewFile.path,
    );
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
    final title = documentImportTitleFromPath(sourcePath).trim();
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

  String _extensionFromPath(String path) {
    final fileName = documentImportFileNameFromPath(path);
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
