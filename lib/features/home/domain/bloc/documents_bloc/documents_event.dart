part of 'documents_bloc.dart';

@freezed
sealed class DocumentsEvent with _$DocumentsEvent {
  const factory DocumentsEvent.started() = _Started;

  const factory DocumentsEvent.documentsChanged(
    List<DocumentModel> documents,
  ) = _DocumentsChanged;

  const factory DocumentsEvent.searchChanged(String query) = _SearchChanged;

  const factory DocumentsEvent.filterChanged(DocumentsFilter filter) =
      _FilterChanged;

  const factory DocumentsEvent.selectionStarted() = _SelectionStarted;

  const factory DocumentsEvent.selectionCancelled() = _SelectionCancelled;

  const factory DocumentsEvent.documentSelectionToggled(int id) =
      _DocumentSelectionToggled;

  const factory DocumentsEvent.selectAll() = _SelectAll;

  const factory DocumentsEvent.deselectAll() = _DeselectAll;

  const factory DocumentsEvent.importFromFilesRequested() =
      _ImportFromFilesRequested;

  const factory DocumentsEvent.importFromGalleryRequested() =
      _ImportFromGalleryRequested;

  const factory DocumentsEvent.importFromScannerRequested() =
      _ImportFromScannerRequested;
}
