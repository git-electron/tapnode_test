import 'package:injectable/injectable.dart';

import '../../service/service.dart';
import 'remove_selected_document_use_case.dart';

@LazySingleton(as: RemoveSelectedDocumentUseCase)
class RemoveSelectedDocumentUseCaseImpl
    implements RemoveSelectedDocumentUseCase {
  const RemoveSelectedDocumentUseCaseImpl(this._selectionService);

  final DocumentsSelectionService _selectionService;

  @override
  Set<int> call({
    required Set<int> selectedIds,
    required int id,
  }) {
    return _selectionService.remove(selectedIds, id);
  }
}
