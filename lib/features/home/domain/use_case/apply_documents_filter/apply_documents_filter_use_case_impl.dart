import 'package:injectable/injectable.dart';

import '../../model/document_model.dart';
import '../../service/service.dart';
import 'apply_documents_filter_use_case.dart';

@LazySingleton(as: ApplyDocumentsFilterUseCase)
class ApplyDocumentsFilterUseCaseImpl implements ApplyDocumentsFilterUseCase {
  const ApplyDocumentsFilterUseCaseImpl(this._filterService);

  final DocumentsFilterService _filterService;

  @override
  List<DocumentModel> call({
    required List<DocumentModel> documents,
    required DocumentsFilter filter,
    required String searchQuery,
  }) {
    return _filterService.apply(
      documents: documents,
      filter: filter,
      searchQuery: searchQuery,
    );
  }
}
