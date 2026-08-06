import '../../model/document_model.dart';

abstract interface class DocumentsService {
  Stream<List<DocumentModel>> watch();

  Future<DocumentModel> add(DocumentModel document);

  Future<void> toggleSigned(int id);

  Future<void> delete(int id);
}
