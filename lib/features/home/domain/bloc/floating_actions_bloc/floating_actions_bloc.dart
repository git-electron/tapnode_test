import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'floating_actions_bloc.freezed.dart';
part 'floating_actions_event.dart';
part 'floating_actions_state.dart';

class FloatingActionsBloc
    extends Bloc<FloatingActionsEvent, FloatingActionsState> {
  FloatingActionsBloc() : super(const FloatingActionsState()) {
    on<FloatingActionsEvent>((event, emit) {
      switch (event) {
        case _OpenAddDocumentsPopup():
          emit(
            state.copyWith(
              isAddDocumentsPopupOpen: true,
              isSearchOpen: false,
              shouldRestoreSearchAfterPopup: false,
              shouldFocusSearchOnOpen: false,
            ),
          );
        case _OpenAddDocumentsPopupFromAppBar():
          emit(
            state.copyWith(
              isAddDocumentsPopupOpen: true,
              isSearchOpen: false,
              shouldRestoreSearchAfterPopup: state.searchText.isNotEmpty,
              shouldFocusSearchOnOpen: false,
            ),
          );
        case _CloseAddDocumentsPopup():
          emit(
            state.copyWith(
              isAddDocumentsPopupOpen: false,
              isSearchOpen: state.shouldRestoreSearchAfterPopup,
              shouldRestoreSearchAfterPopup: false,
              shouldFocusSearchOnOpen: false,
            ),
          );
        case _DismissForAppBarMenu():
          emit(
            state.copyWith(
              isAddDocumentsPopupOpen: false,
              isSearchOpen: state.searchText.isNotEmpty,
              shouldRestoreSearchAfterPopup: false,
              shouldFocusSearchOnOpen: false,
            ),
          );
        case _OpenSearch():
          emit(
            state.copyWith(
              isAddDocumentsPopupOpen: false,
              isSearchOpen: true,
              shouldRestoreSearchAfterPopup: false,
              shouldFocusSearchOnOpen: true,
            ),
          );
        case _CloseSearch():
          emit(
            state.copyWith(
              isSearchOpen: false,
              shouldRestoreSearchAfterPopup: false,
              shouldFocusSearchOnOpen: false,
            ),
          );
        case _SearchTextChanged(:final text):
          emit(state.copyWith(searchText: text));
        case _ClearSearchAndClose():
          emit(
            state.copyWith(
              isSearchOpen: false,
              searchText: '',
              shouldRestoreSearchAfterPopup: false,
              shouldFocusSearchOnOpen: false,
            ),
          );
      }
    });
  }
}
