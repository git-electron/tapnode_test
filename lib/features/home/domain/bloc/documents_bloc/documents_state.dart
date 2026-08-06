part of 'documents_bloc.dart';

@freezed
sealed class DocumentsState with _$DocumentsState {
  const factory DocumentsState({
    @Default([]) List<DocumentModel> documents,
    @Default(0) int totalDocumentsCount,
    @Default(DocumentsFilter.all) DocumentsFilter filter,
    @Default('') String searchQuery,
    @Default(false) bool selectionMode,
    @Default({}) Set<int> selectedIds,
    @Default(false) bool loading,
    String? error,
  }) = _DocumentsState;

  const DocumentsState._();

  bool get hasDocuments => totalDocumentsCount > 0;

  bool get hasVisibleDocuments => documents.isNotEmpty;

  bool get hasNoDocuments => totalDocumentsCount == 0;

  bool get hasNoVisibleDocumentsByFilters =>
      totalDocumentsCount > 0 && documents.isEmpty;
}
