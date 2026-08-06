import 'package:injectable/injectable.dart';

import '../../../data/repository/add_document/add_document_repository.dart';
import '../../../data/repository/delete_document/delete_document_repository.dart';
import '../../../data/repository/toggle_document_signed/toggle_document_signed_repository.dart';
import '../../../data/repository/watch_documents/watch_documents_repository.dart';
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
