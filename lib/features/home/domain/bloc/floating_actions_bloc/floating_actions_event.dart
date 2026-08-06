part of 'floating_actions_bloc.dart';

@freezed
sealed class FloatingActionsEvent with _$FloatingActionsEvent {
  const factory FloatingActionsEvent.openAddDocumentsPopup() =
      _OpenAddDocumentsPopup;

  const factory FloatingActionsEvent.openAddDocumentsPopupFromAppBar({
    required bool shouldRestoreSearchAfterPopup,
  }) = _OpenAddDocumentsPopupFromAppBar;

  const factory FloatingActionsEvent.closeAddDocumentsPopup() =
      _CloseAddDocumentsPopup;

  const factory FloatingActionsEvent.dismissForAppBarMenu({
    required bool shouldKeepSearchOpen,
  }) = _DismissForAppBarMenu;

  const factory FloatingActionsEvent.openSearch() = _OpenSearch;

  const factory FloatingActionsEvent.closeSearch() = _CloseSearch;
}
