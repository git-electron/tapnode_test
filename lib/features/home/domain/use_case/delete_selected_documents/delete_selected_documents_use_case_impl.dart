import 'package:injectable/injectable.dart';

import '../../service/service.dart';
import 'delete_selected_documents_use_case.dart';

@LazySingleton(as: DeleteSelectedDocumentsUseCase)
class DeleteSelectedDocumentsUseCaseImpl
    implements DeleteSelectedDocumentsUseCase {
  const DeleteSelectedDocumentsUseCaseImpl(this._documentsService);

  final DocumentsService _documentsService;

  @override
  Future<void> call(Iterable<int> ids) async {
    for (final id in ids) {
      await _documentsService.delete(id);
    }
  }
}
