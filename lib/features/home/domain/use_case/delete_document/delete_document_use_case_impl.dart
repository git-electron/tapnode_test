import 'package:injectable/injectable.dart';

import '../../service/documents/documents_service.dart';
import 'delete_document_use_case.dart';

@LazySingleton(as: DeleteDocumentUseCase)
class DeleteDocumentUseCaseImpl implements DeleteDocumentUseCase {
  const DeleteDocumentUseCaseImpl(this._documentsService);

  final DocumentsService _documentsService;

  @override
  Future<void> call(int id) {
    return _documentsService.delete(id);
  }
}
