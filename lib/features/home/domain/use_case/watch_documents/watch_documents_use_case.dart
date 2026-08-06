import '../../model/document_model.dart';

abstract interface class WatchDocumentsUseCase {
  Stream<List<DocumentModel>> call();
}
