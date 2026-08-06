import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../model/document_model.dart';
import '../../use_case/use_case.dart';

part 'documents_event.dart';
part 'documents_state.dart';
part 'documents_bloc.freezed.dart';

@injectable
class DocumentsBloc extends Bloc<DocumentsEvent, DocumentsState> {
  DocumentsBloc({
    required Logger logger,
    required WatchDocumentsUseCase watchDocumentsUseCase,
    required ImportDocumentUseCase importDocumentUseCase,
    required DeleteDocumentUseCase deleteDocumentUseCase,
    required SelectAllDocumentsUseCase selectAllDocumentsUseCase,
    required ApplyDocumentsFilterUseCase applyDocumentsFilterUseCase,
    required ToggleDocumentSignedUseCase toggleDocumentSignedUseCase,
    required RemoveSelectedDocumentUseCase removeSelectedDocumentUseCase,
    required ToggleDocumentSelectionUseCase toggleDocumentSelectionUseCase,
    required DeleteSelectedDocumentsUseCase deleteSelectedDocumentsUseCase,
    required SanitizeSelectedDocumentsUseCase sanitizeSelectedDocumentsUseCase,
  }) : _logger = logger,
       _watchDocumentsUseCase = watchDocumentsUseCase,
       _importDocumentUseCase = importDocumentUseCase,
       _deleteDocumentUseCase = deleteDocumentUseCase,
       _selectAllDocumentsUseCase = selectAllDocumentsUseCase,
       _applyDocumentsFilterUseCase = applyDocumentsFilterUseCase,
       _toggleDocumentSignedUseCase = toggleDocumentSignedUseCase,
       _removeSelectedDocumentUseCase = removeSelectedDocumentUseCase,
       _toggleDocumentSelectionUseCase = toggleDocumentSelectionUseCase,
       _deleteSelectedDocumentsUseCase = deleteSelectedDocumentsUseCase,
       _sanitizeSelectedDocumentsUseCase = sanitizeSelectedDocumentsUseCase,
       super(const DocumentsState()) {
    on<_Started>(_onStarted);
    on<_SelectAll>(_onSelectAll);
    on<_DeselectAll>(_onDeselectAll);
    on<_SearchChanged>(_onSearchChanged);
    on<_FilterChanged>(_onFilterChanged);
    on<_DeleteRequested>(_onDeleteRequested);
    on<_ImportRequested>(_onImportRequested);
    on<_DocumentsChanged>(_onDocumentsChanged);
    on<_SelectionStarted>(_onSelectionStarted);
    on<_SelectionCancelled>(_onSelectionCancelled);
    on<_DocumentSignedToggled>(_onDocumentSignedToggled);
    on<_SelectedDeleteRequested>(_onSelectedDeleteRequested);
    on<_DocumentSelectionToggled>(_onDocumentSelectionToggled);
  }

  final Logger _logger;
  final WatchDocumentsUseCase _watchDocumentsUseCase;
  final ImportDocumentUseCase _importDocumentUseCase;
  final DeleteDocumentUseCase _deleteDocumentUseCase;
  final SelectAllDocumentsUseCase _selectAllDocumentsUseCase;
  final ApplyDocumentsFilterUseCase _applyDocumentsFilterUseCase;
  final ToggleDocumentSignedUseCase _toggleDocumentSignedUseCase;
  final RemoveSelectedDocumentUseCase _removeSelectedDocumentUseCase;
  final ToggleDocumentSelectionUseCase _toggleDocumentSelectionUseCase;
  final DeleteSelectedDocumentsUseCase _deleteSelectedDocumentsUseCase;
  final SanitizeSelectedDocumentsUseCase _sanitizeSelectedDocumentsUseCase;

  StreamSubscription<List<DocumentModel>>? _subscription;
  List<DocumentModel> _allDocuments = const [];

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  Future<void> _onStarted(
    _Started event,
    Emitter<DocumentsState> emit,
  ) async {
    await _subscription?.cancel();

    _subscription = _watchDocumentsUseCase().listen(
      (documents) {
        add(DocumentsEvent.documentsChanged(documents));
      },
    );
  }

  void _onDocumentsChanged(
    _DocumentsChanged event,
    Emitter<DocumentsState> emit,
  ) {
    _allDocuments = event.documents;
    final selectedIds = _sanitizeSelectedDocumentsUseCase(
      selectedIds: state.selectedIds,
      documents: _allDocuments,
    );

    emit(
      state.copyWith(
        documents: _visibleDocuments(),
        totalDocumentsCount: _allDocuments.length,
        selectedIds: selectedIds,
      ),
    );
  }

  void _onSearchChanged(
    _SearchChanged event,
    Emitter<DocumentsState> emit,
  ) {
    emit(
      state.copyWith(
        searchQuery: event.query,
        documents: _visibleDocuments(searchQuery: event.query),
      ),
    );
  }

  void _onFilterChanged(
    _FilterChanged event,
    Emitter<DocumentsState> emit,
  ) {
    emit(
      state.copyWith(
        filter: event.filter,
        documents: _visibleDocuments(filter: event.filter),
      ),
    );
  }

  void _onSelectionStarted(
    _SelectionStarted event,
    Emitter<DocumentsState> emit,
  ) {
    emit(state.copyWith(selectionMode: true));
  }

  void _onSelectionCancelled(
    _SelectionCancelled event,
    Emitter<DocumentsState> emit,
  ) {
    emit(
      state.copyWith(
        selectionMode: false,
        selectedIds: const {},
      ),
    );
  }

  void _onDocumentSelectionToggled(
    _DocumentSelectionToggled event,
    Emitter<DocumentsState> emit,
  ) {
    emit(
      state.copyWith(
        selectedIds: _toggleDocumentSelectionUseCase(
          selectedIds: state.selectedIds,
          id: event.id,
        ),
      ),
    );
  }

  void _onSelectAll(
    _SelectAll event,
    Emitter<DocumentsState> emit,
  ) {
    emit(
      state.copyWith(
        selectionMode: true,
        selectedIds: _selectAllDocumentsUseCase(state.documents),
      ),
    );
  }

  void _onDeselectAll(
    _DeselectAll event,
    Emitter<DocumentsState> emit,
  ) {
    emit(
      state.copyWith(
        selectionMode: false,
        selectedIds: const {},
      ),
    );
  }

  Future<void> _onDocumentSignedToggled(
    _DocumentSignedToggled event,
    Emitter<DocumentsState> emit,
  ) async {
    try {
      await _toggleDocumentSignedUseCase(event.id);
    } on Object catch (error, stackTrace) {
      _logger.e(
        'Documents bloc: toggle signed failed',
        error: error,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(error: error.toString()));
    }
  }

  Future<void> _onDeleteRequested(
    _DeleteRequested event,
    Emitter<DocumentsState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));

    try {
      await _deleteDocumentUseCase(event.id);
      final selectedIds = _removeSelectedDocumentUseCase(
        selectedIds: state.selectedIds,
        id: event.id,
      );
      emit(
        state.copyWith(
          loading: false,
          selectedIds: selectedIds,
          selectionMode: selectedIds.isNotEmpty,
        ),
      );
    } on Object catch (error, stackTrace) {
      _logger.e(
        'Documents bloc: delete failed',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(
          loading: false,
          error: error.toString(),
        ),
      );
    }
  }

  Future<void> _onSelectedDeleteRequested(
    _SelectedDeleteRequested event,
    Emitter<DocumentsState> emit,
  ) async {
    final ids = state.selectedIds.toList(growable: false);
    if (ids.isEmpty) return;

    emit(state.copyWith(loading: true, error: null));

    try {
      await _deleteSelectedDocumentsUseCase(ids);

      emit(
        state.copyWith(
          loading: false,
          selectionMode: false,
          selectedIds: const {},
        ),
      );
    } on Object catch (error, stackTrace) {
      _logger.e(
        'Documents bloc: delete selected failed',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(
          loading: false,
          error: error.toString(),
        ),
      );
    }
  }

  Future<void> _onImportRequested(
    _ImportRequested event,
    Emitter<DocumentsState> emit,
  ) async {
    _logger.i('Documents bloc: import started');
    emit(state.copyWith(loading: true, error: null));

    try {
      await _importDocumentUseCase(event.source);
      emit(state.copyWith(loading: false));
    } on Object catch (error, stackTrace) {
      _logger.e(
        'Documents bloc: import failed',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(
          loading: false,
          error: error.toString(),
        ),
      );
    }
  }

  List<DocumentModel> _visibleDocuments({
    DocumentsFilter? filter,
    String? searchQuery,
  }) {
    return _applyDocumentsFilterUseCase(
      documents: _allDocuments,
      filter: filter ?? state.filter,
      searchQuery: searchQuery ?? state.searchQuery,
    );
  }
}
