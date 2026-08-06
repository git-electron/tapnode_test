import '../../model/document_model.dart';

abstract interface class DocumentsFilterService {
  List<DocumentModel> apply({
    required List<DocumentModel> documents,
    required DocumentsFilter filter,
    required String searchQuery,
  });
}
