import '../../../domain/model/document_model.dart';

abstract interface class WatchDocumentsRepository {
  Stream<List<DocumentModel>> call();
}
