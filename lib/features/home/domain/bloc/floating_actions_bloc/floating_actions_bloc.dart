import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'floating_actions_bloc.freezed.dart';
part 'floating_actions_event.dart';
part 'floating_actions_state.dart';

@injectable
class FloatingActionsBloc
    extends Bloc<FloatingActionsEvent, FloatingActionsState> {
  FloatingActionsBloc() : super(const FloatingActionsState()) {
    on<_OpenAddDocumentsPopup>(_onOpenAddDocumentsPopup);
    on<_OpenAddDocumentsPopupFromAppBar>(_onOpenAddDocumentsPopupFromAppBar);
    on<_CloseAddDocumentsPopup>(_onCloseAddDocumentsPopup);
    on<_DismissForAppBarMenu>(_onDismissForAppBarMenu);
    on<_OpenSearch>(_onOpenSearch);
    on<_CloseSearch>(_onCloseSearch);
    on<_SearchTextChanged>(_onSearchTextChanged);
    on<_ClearSearchAndClose>(_onClearSearchAndClose);
  }

  void _onOpenAddDocumentsPopup(
    _OpenAddDocumentsPopup event,
    Emitter<FloatingActionsState> emit,
  ) {
    emit(
      state.copyWith(
        isAddDocumentsPopupOpen: true,
        isSearchOpen: false,
        shouldRestoreSearchAfterPopup: false,
        shouldFocusSearchOnOpen: false,
      ),
    );
  }

  void _onOpenAddDocumentsPopupFromAppBar(
    _OpenAddDocumentsPopupFromAppBar event,
    Emitter<FloatingActionsState> emit,
  ) {
    emit(
      state.copyWith(
        isAddDocumentsPopupOpen: true,
        isSearchOpen: false,
        shouldRestoreSearchAfterPopup: state.searchText.isNotEmpty,
        shouldFocusSearchOnOpen: false,
      ),
    );
  }

  void _onCloseAddDocumentsPopup(
    _CloseAddDocumentsPopup event,
    Emitter<FloatingActionsState> emit,
  ) {
    emit(
      state.copyWith(
        isAddDocumentsPopupOpen: false,
        isSearchOpen: state.shouldRestoreSearchAfterPopup,
        shouldRestoreSearchAfterPopup: false,
        shouldFocusSearchOnOpen: false,
      ),
    );
  }

  void _onDismissForAppBarMenu(
    _DismissForAppBarMenu event,
    Emitter<FloatingActionsState> emit,
  ) {
    emit(
      state.copyWith(
        isAddDocumentsPopupOpen: false,
        isSearchOpen: state.searchText.isNotEmpty,
        shouldRestoreSearchAfterPopup: false,
        shouldFocusSearchOnOpen: false,
      ),
    );
  }

  void _onOpenSearch(
    _OpenSearch event,
    Emitter<FloatingActionsState> emit,
  ) {
    emit(
      state.copyWith(
        isAddDocumentsPopupOpen: false,
        isSearchOpen: true,
        shouldRestoreSearchAfterPopup: false,
        shouldFocusSearchOnOpen: true,
      ),
    );
  }

  void _onCloseSearch(
    _CloseSearch event,
    Emitter<FloatingActionsState> emit,
  ) {
    emit(
      state.copyWith(
        isSearchOpen: false,
        shouldRestoreSearchAfterPopup: false,
        shouldFocusSearchOnOpen: false,
      ),
    );
  }

  void _onSearchTextChanged(
    _SearchTextChanged event,
    Emitter<FloatingActionsState> emit,
  ) {
    emit(state.copyWith(searchText: event.text));
  }

  void _onClearSearchAndClose(
    _ClearSearchAndClose event,
    Emitter<FloatingActionsState> emit,
  ) {
    emit(
      state.copyWith(
        isSearchOpen: false,
        searchText: '',
        shouldRestoreSearchAfterPopup: false,
        shouldFocusSearchOnOpen: false,
      ),
    );
  }
}
