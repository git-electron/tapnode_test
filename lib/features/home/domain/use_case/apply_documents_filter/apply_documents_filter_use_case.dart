import '../../model/document_model.dart';

abstract interface class ApplyDocumentsFilterUseCase {
  List<DocumentModel> call({
    required List<DocumentModel> documents,
    required DocumentsFilter filter,
    required String searchQuery,
  });
}
