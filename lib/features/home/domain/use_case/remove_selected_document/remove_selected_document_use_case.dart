abstract interface class RemoveSelectedDocumentUseCase {
  Set<int> call({
    required Set<int> selectedIds,
    required int id,
  });
}
