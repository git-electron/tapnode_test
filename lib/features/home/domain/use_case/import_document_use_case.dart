import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../data/repository/add_document/add_document_repository.dart';
import '../model/document_model.dart';
import '../service/document_import/document_import_service.dart';

@injectable
class ImportDocumentUseCase {
  const ImportDocumentUseCase({
    required AddDocumentRepository addDocumentRepository,
    required DocumentImportService importService,
    required Logger logger,
  }) : _addDocumentRepository = addDocumentRepository,
       _importService = importService,
       _logger = logger;

  final AddDocumentRepository _addDocumentRepository;
  final DocumentImportService _importService;
  final Logger _logger;

  Future<bool> call(DocumentImportSource source) async {
    _logger.i('Documents import use case: import started source=$source');
    final draft = await _importService.importFrom(source);
    if (draft == null) {
      _logger.i('Documents import use case: import cancelled');
      return false;
    }

    _logger.i(
      'Documents import use case: draft ready '
      'title=${draft.title}, filePath=${draft.filePath}, '
      'previews=${draft.previewImagePaths.length}',
    );
    await _addDocumentRepository(draft.toDocumentModel());
    _logger.i('Documents import use case: import completed');

    return true;
  }
}
