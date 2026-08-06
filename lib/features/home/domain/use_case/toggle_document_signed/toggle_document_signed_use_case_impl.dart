import 'package:injectable/injectable.dart';

import '../../service/documents/documents_service.dart';
import 'toggle_document_signed_use_case.dart';

@LazySingleton(as: ToggleDocumentSignedUseCase)
class ToggleDocumentSignedUseCaseImpl implements ToggleDocumentSignedUseCase {
  const ToggleDocumentSignedUseCaseImpl(this._documentsService);

  final DocumentsService _documentsService;

  @override
  Future<void> call(int id) {
    return _documentsService.toggleSigned(id);
  }
}
