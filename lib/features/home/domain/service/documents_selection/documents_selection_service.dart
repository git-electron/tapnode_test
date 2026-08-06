import '../../model/document_model.dart';

abstract interface class DocumentsSelectionService {
  Set<int> toggle(Set<int> selectedIds, int id);

  Set<int> selectAll(List<DocumentModel> documents);

  Set<int> remove(Set<int> selectedIds, int id);

  Set<int> sanitize({
    required Set<int> selectedIds,
    required List<DocumentModel> documents,
  });
}
