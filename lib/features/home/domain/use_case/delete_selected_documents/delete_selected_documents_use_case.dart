abstract interface class DeleteSelectedDocumentsUseCase {
  Future<void> call(Iterable<int> ids);
}
