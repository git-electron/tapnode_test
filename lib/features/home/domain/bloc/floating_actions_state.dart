part of 'floating_actions_bloc.dart';

@freezed
abstract class FloatingActionsState with _$FloatingActionsState {
  const factory FloatingActionsState({
    @Default(false) bool isAddDocumentsPopupOpen,
    @Default(false) bool isSearchOpen,
  }) = _FloatingActionsState;
}
