import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../../model/document_model.dart';
import '../document_import_service.dart';
import '../utils/path_utils.dart';

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
      title: documentImportTitleFromPath(importedImage.pdfPath),
      filePath: importedImage.pdfPath,
      source: DocumentImportSource.gallery,
      previewImagePaths: [importedImage.previewImagePath],
    );
  }
}
