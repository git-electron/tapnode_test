import '../../model/document_model.dart';

abstract interface class SanitizeSelectedDocumentsUseCase {
  Set<int> call({
    required Set<int> selectedIds,
    required List<DocumentModel> documents,
  });
}
