import '../../model/document_model.dart';

abstract interface class SelectAllDocumentsUseCase {
  Set<int> call(List<DocumentModel> documents);
}
