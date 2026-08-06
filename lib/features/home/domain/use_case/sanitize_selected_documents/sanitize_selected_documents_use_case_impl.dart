import 'package:injectable/injectable.dart';

import '../../model/document_model.dart';
import '../../service/documents_selection/documents_selection_service.dart';
import 'sanitize_selected_documents_use_case.dart';

@LazySingleton(as: SanitizeSelectedDocumentsUseCase)
class SanitizeSelectedDocumentsUseCaseImpl
    implements SanitizeSelectedDocumentsUseCase {
  const SanitizeSelectedDocumentsUseCaseImpl(this._selectionService);

  final DocumentsSelectionService _selectionService;

  @override
  Set<int> call({
    required Set<int> selectedIds,
    required List<DocumentModel> documents,
  }) {
    return _selectionService.sanitize(
      selectedIds: selectedIds,
      documents: documents,
    );
  }
}
