abstract interface class ToggleDocumentSelectionUseCase {
  Set<int> call({
    required Set<int> selectedIds,
    required int id,
  });
}
