part of 'floating_actions_bloc.dart';

@freezed
sealed class FloatingActionsEvent with _$FloatingActionsEvent {
  const factory FloatingActionsEvent.openAddDocumentsPopup() =
      _OpenAddDocumentsPopup;

  const factory FloatingActionsEvent.closeAddDocumentsPopup() =
      _CloseAddDocumentsPopup;

  const factory FloatingActionsEvent.openSearch() = _OpenSearch;

  const factory FloatingActionsEvent.closeSearch() = _CloseSearch;

  const factory FloatingActionsEvent.searchTextChanged(String text) =
      _SearchTextChanged;

  const factory FloatingActionsEvent.clearSearchAndClose() =
      _ClearSearchAndClose;
}
