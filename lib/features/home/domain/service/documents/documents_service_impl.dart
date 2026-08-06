import 'package:injectable/injectable.dart';

import '../../../data/repository/repository.dart';
import '../../model/document_model.dart';
import 'documents_service.dart';

@LazySingleton(as: DocumentsService)
class DocumentsServiceImpl implements DocumentsService {
  const DocumentsServiceImpl({
    required WatchDocumentsRepository watchDocumentsRepository,
    required AddDocumentRepository addDocumentRepository,
    required ToggleDocumentSignedRepository toggleDocumentSignedRepository,
    required DeleteDocumentRepository deleteDocumentRepository,
  }) : _watchDocumentsRepository = watchDocumentsRepository,
       _addDocumentRepository = addDocumentRepository,
       _toggleDocumentSignedRepository = toggleDocumentSignedRepository,
       _deleteDocumentRepository = deleteDocumentRepository;

  final WatchDocumentsRepository _watchDocumentsRepository;
  final AddDocumentRepository _addDocumentRepository;
  final ToggleDocumentSignedRepository _toggleDocumentSignedRepository;
  final DeleteDocumentRepository _deleteDocumentRepository;

  @override
  Stream<List<DocumentModel>> watch() {
    return _watchDocumentsRepository();
  }

  @override
  Future<DocumentModel> add(DocumentModel document) {
    return _addDocumentRepository(document);
  }

  @override
  Future<void> toggleSigned(int id) {
    return _toggleDocumentSignedRepository(id);
  }

  @override
  Future<void> delete(int id) {
    return _deleteDocumentRepository(id);
  }
}
