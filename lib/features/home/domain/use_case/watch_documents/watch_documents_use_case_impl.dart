import 'package:injectable/injectable.dart';

import '../../model/document_model.dart';
import '../../service/documents/documents_service.dart';
import 'watch_documents_use_case.dart';

@LazySingleton(as: WatchDocumentsUseCase)
class WatchDocumentsUseCaseImpl implements WatchDocumentsUseCase {
  const WatchDocumentsUseCaseImpl(this._documentsService);

  final DocumentsService _documentsService;

  @override
  Stream<List<DocumentModel>> call() {
    return _documentsService.watch();
  }
}
