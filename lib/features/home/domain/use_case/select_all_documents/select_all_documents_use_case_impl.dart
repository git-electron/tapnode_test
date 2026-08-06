import 'package:injectable/injectable.dart';

import '../../model/document_model.dart';
import '../../service/documents_selection/documents_selection_service.dart';
import 'select_all_documents_use_case.dart';

@LazySingleton(as: SelectAllDocumentsUseCase)
class SelectAllDocumentsUseCaseImpl implements SelectAllDocumentsUseCase {
  const SelectAllDocumentsUseCaseImpl(this._selectionService);

  final DocumentsSelectionService _selectionService;

  @override
  Set<int> call(List<DocumentModel> documents) {
    return _selectionService.selectAll(documents);
  }
}
