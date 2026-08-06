import '../../model/document_model.dart';

abstract interface class DocumentFilesCleanerService {
  Future<void> deleteManagedFiles(DocumentModel document);
}
