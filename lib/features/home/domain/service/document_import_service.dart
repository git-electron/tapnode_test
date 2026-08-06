import 'package:injectable/injectable.dart';

import '../model/document_model.dart';

abstract interface class DocumentImportService {
  Future<DocumentImportDraft?> pickFromFiles();

  Future<DocumentImportDraft?> pickFromGallery();

  Future<DocumentImportDraft?> scanWithCunningDocumentScanner();
}

@LazySingleton(as: DocumentImportService)
class StubDocumentImportService implements DocumentImportService {
  const StubDocumentImportService();

  @override
  Future<DocumentImportDraft?> pickFromFiles() async {
    // TODO: Wire file picker and build a DocumentImportDraft.
    return null;
  }

  @override
  Future<DocumentImportDraft?> pickFromGallery() async {
    // TODO: Wire gallery picker and build a DocumentImportDraft.
    return null;
  }

  @override
  Future<DocumentImportDraft?> scanWithCunningDocumentScanner() async {
    // TODO: Wire cunning_document_scanner and build a DocumentImportDraft.
    return null;
  }
}
