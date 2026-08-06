import 'package:injectable/injectable.dart';

import '../../service/service.dart';
import 'toggle_document_selection_use_case.dart';

@LazySingleton(as: ToggleDocumentSelectionUseCase)
class ToggleDocumentSelectionUseCaseImpl
    implements ToggleDocumentSelectionUseCase {
  const ToggleDocumentSelectionUseCaseImpl(this._selectionService);

  final DocumentsSelectionService _selectionService;

  @override
  Set<int> call({
    required Set<int> selectedIds,
    required int id,
  }) {
    return _selectionService.toggle(selectedIds, id);
  }
}
