import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../model/document_model.dart';
import '../pdf_preview/pdf_preview_service.dart';
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
      title: _titleFromPath(importedPdfPath),
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

@LazySingleton(as: GalleryDocumentImporter)
class GalleryDocumentImporterImpl implements GalleryDocumentImporter {
  const GalleryDocumentImporterImpl({
    required GalleryImagePicker picker,
    required ImportedDocumentStorage storage,
    required ImagePdfFactory pdfFactory,
    required Logger logger,
  }) : _picker = picker,
       _storage = storage,
       _pdfFactory = pdfFactory,
       _logger = logger;

  final GalleryImagePicker _picker;
  final ImportedDocumentStorage _storage;
  final ImagePdfFactory _pdfFactory;
  final Logger _logger;

  @override
  Future<DocumentImportDraft?> import() async {
    _logger.i('Document import: opening gallery image picker');
    final imagePath = await _picker.pickImagePath();
    if (imagePath == null) {
      _logger.i('Document import: gallery image picker cancelled');
      return null;
    }

    _logger.i('Document import: picked gallery image: $imagePath');
    final importedImage = await _storage.copyGalleryImage(imagePath);

    await _pdfFactory.createPdfFromImage(
      imagePath: importedImage.previewImagePath,
      pdfPath: importedImage.pdfPath,
    );

    return DocumentImportDraft(
      title: _titleFromPath(importedImage.pdfPath),
      filePath: importedImage.pdfPath,
      source: DocumentImportSource.gallery,
      previewImagePaths: [importedImage.previewImagePath],
    );
  }
}

@LazySingleton(as: ScannerDocumentImporter)
class ScannerDocumentImporterImpl implements ScannerDocumentImporter {
  const ScannerDocumentImporterImpl({
    required DocumentScanner scanner,
    required ImportedDocumentStorage storage,
    required PdfPreviewService previewService,
    required Logger logger,
  }) : _scanner = scanner,
       _storage = storage,
       _previewService = previewService,
       _logger = logger;

  final DocumentScanner _scanner;
  final ImportedDocumentStorage _storage;
  final PdfPreviewService _previewService;
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
    final previewImagePaths = await _generatePreviewImagePaths(importedPdfPath);

    return DocumentImportDraft(
      title: _titleFromPath(importedPdfPath),
      filePath: importedPdfPath,
      source: DocumentImportSource.scanner,
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

@LazySingleton(as: PdfFilePicker)
class PdfFilePickerImpl implements PdfFilePicker {
  const PdfFilePickerImpl();

  @override
  Future<String?> pickPdfPath() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf'],
    );

    return result?.files.single.path;
  }
}

@LazySingleton(as: GalleryImagePicker)
class GalleryImagePickerImpl implements GalleryImagePicker {
  const GalleryImagePickerImpl();

  @override
  Future<String?> pickImagePath() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      requestFullMetadata: false,
    );

    return image?.path;
  }
}

@LazySingleton(as: DocumentScanner)
class DocumentScannerImpl implements DocumentScanner {
  const DocumentScannerImpl();

  @override
  Future<String?> scanPdfPath() async {
    final paths = await CunningDocumentScanner.getPictures(
      scannerSource: ScannerSource.camera,
      asPdf: true,
    );
    if (paths == null || paths.isEmpty) return null;

    return paths.first;
  }
}

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

@LazySingleton(as: ImagePdfFactory)
class ImagePdfFactoryImpl implements ImagePdfFactory {
  const ImagePdfFactoryImpl(this._logger);

  final Logger _logger;

  @override
  Future<void> createPdfFromImage({
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
}

String _titleFromPath(String path) {
  final fileName = _fileNameFromPath(path);
  final extensionIndex = fileName.lastIndexOf('.');

  if (extensionIndex <= 0) return fileName;

  return fileName.substring(0, extensionIndex);
}

String _fileNameFromPath(String path) {
  final normalizedPath = path.replaceAll(r'\', '/');

  return normalizedPath.split('/').last;
}
