import '../../../domain/model/document_model.dart';

abstract interface class AddDocumentRepository {
  Future<DocumentModel> call(DocumentModel document);
}
