import 'package:injectable/injectable.dart';

import '../../model/document_model.dart';
import 'documents_selection_service.dart';

@LazySingleton(as: DocumentsSelectionService)
class DocumentsSelectionServiceImpl implements DocumentsSelectionService {
  const DocumentsSelectionServiceImpl();

  @override
  Set<int> toggle(Set<int> selectedIds, int id) {
    final updatedSelectedIds = {...selectedIds};
    if (!updatedSelectedIds.add(id)) {
      updatedSelectedIds.remove(id);
    }

    return updatedSelectedIds;
  }

  @override
  Set<int> selectAll(List<DocumentModel> documents) {
    return {
      for (final document in documents) document.id,
    };
  }

  @override
  Set<int> remove(Set<int> selectedIds, int id) {
    return {...selectedIds}..remove(id);
  }

  @override
  Set<int> sanitize({
    required Set<int> selectedIds,
    required List<DocumentModel> documents,
  }) {
    final documentIds = documents.map((document) => document.id).toSet();

    return selectedIds.where(documentIds.contains).toSet();
  }
}
