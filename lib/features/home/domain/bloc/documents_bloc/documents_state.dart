part of 'documents_bloc.dart';

@freezed
sealed class DocumentsState with _$DocumentsState {
  const factory DocumentsState({
    @Default([]) List<DocumentModel> documents,
    @Default(DocumentsFilter.all) DocumentsFilter filter,
    @Default('') String searchQuery,
    @Default(false) bool selectionMode,
    @Default({}) Set<int> selectedIds,
    @Default(false) bool loading,
    String? error,
  }) = _DocumentsState;
}
