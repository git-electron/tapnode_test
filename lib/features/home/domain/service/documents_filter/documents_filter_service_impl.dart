import 'package:injectable/injectable.dart';

import '../../model/document_model.dart';
import 'documents_filter_service.dart';

@LazySingleton(as: DocumentsFilterService)
class DocumentsFilterServiceImpl implements DocumentsFilterService {
  const DocumentsFilterServiceImpl();

  @override
  List<DocumentModel> apply({
    required List<DocumentModel> documents,
    required DocumentsFilter filter,
    required String searchQuery,
  }) {
    final effectiveSearchQuery = searchQuery.trim().toLowerCase();

    return documents
        .where((document) {
          final matchesFilter = switch (filter) {
            DocumentsFilter.all => true,
            DocumentsFilter.signed => document.isSigned,
            DocumentsFilter.unsigned => !document.isSigned,
          };
          final matchesSearch =
              effectiveSearchQuery.isEmpty ||
              document.title.toLowerCase().contains(effectiveSearchQuery);

          return matchesFilter && matchesSearch;
        })
        .toList(growable: false);
  }
}
