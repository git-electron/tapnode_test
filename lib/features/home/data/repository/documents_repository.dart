import '../../domain/model/document_model.dart';

abstract interface class DocumentsRepository {
  Stream<List<DocumentModel>> watchDocuments();

  Future<DocumentModel> addDocument(DocumentModel document);

  Future<void> toggleDocumentSigned(int id);

  Future<void> deleteDocument(int id);
}
