import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../model/document_model.dart';
import '../../service/documents/documents_service.dart';
import '../../service/documents_filter/documents_filter_service.dart';
import '../../service/documents_selection/documents_selection_service.dart';
import '../../use_case/import_document_use_case.dart';

part 'documents_event.dart';
part 'documents_state.dart';
part 'documents_bloc.freezed.dart';

@injectable
class DocumentsBloc extends Bloc<DocumentsEvent, DocumentsState> {
  DocumentsBloc({
    required DocumentsService documentsService,
    required ImportDocumentUseCase importDocumentUseCase,
    required DocumentsFilterService filterService,
    required DocumentsSelectionService selectionService,
    required Logger logger,
  }) : _documentsService = documentsService,
       _importDocumentUseCase = importDocumentUseCase,
       _filterService = filterService,
       _selectionService = selectionService,
       _logger = logger,
       super(const DocumentsState()) {
    on<_Started>(_onStarted);
    on<_DocumentsChanged>(_onDocumentsChanged);
    on<_SearchChanged>(_onSearchChanged);
    on<_FilterChanged>(_onFilterChanged);
    on<_SelectionStarted>(_onSelectionStarted);
    on<_SelectionCancelled>(_onSelectionCancelled);
    on<_DocumentSelectionToggled>(_onDocumentSelectionToggled);
    on<_SelectAll>(_onSelectAll);
    on<_DeselectAll>(_onDeselectAll);
    on<_DocumentSignedToggled>(_onDocumentSignedToggled);
    on<_DeleteRequested>(_onDeleteRequested);
    on<_SelectedDeleteRequested>(_onSelectedDeleteRequested);
    on<_ImportRequested>(_onImportRequested);
  }

  final DocumentsService _documentsService;
  final ImportDocumentUseCase _importDocumentUseCase;
  final DocumentsFilterService _filterService;
  final DocumentsSelectionService _selectionService;
  final Logger _logger;

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

    _subscription = _documentsService.watch().listen(
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
    final selectedIds = _selectionService.sanitize(
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
        selectedIds: _selectionService.toggle(state.selectedIds, event.id),
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
        selectedIds: _selectionService.selectAll(state.documents),
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
      await _documentsService.toggleSigned(event.id);
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
      await _documentsService.delete(event.id);
      final selectedIds = _selectionService.remove(state.selectedIds, event.id);
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
      for (final id in ids) {
        await _documentsService.delete(id);
      }

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
    return _filterService.apply(
      documents: _allDocuments,
      filter: filter ?? state.filter,
      searchQuery: searchQuery ?? state.searchQuery,
    );
  }
}
