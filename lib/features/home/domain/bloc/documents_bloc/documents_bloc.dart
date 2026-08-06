import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../../data/repository/documents_repository.dart';
import '../../model/document_model.dart';
import '../../service/document_import_service.dart';

part 'documents_event.dart';
part 'documents_state.dart';
part 'documents_bloc.freezed.dart';

@injectable
class DocumentsBloc extends Bloc<DocumentsEvent, DocumentsState> {
  DocumentsBloc({
    required DocumentsRepository repository,
    required DocumentImportService importService,
    required Logger logger,
  }) : _repository = repository,
       _importService = importService,
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
    on<_DeleteRequested>(_onDeleteRequested);
    // TODO: remove
    on<_DeleteAllRequested>(_onDeleteAllRequested);
    on<_ImportFromFilesRequested>(_onImportFromFilesRequested);
    on<_ImportFromGalleryRequested>(_onImportFromGalleryRequested);
    on<_ImportFromScannerRequested>(_onImportFromScannerRequested);
  }

  final DocumentsRepository _repository;
  final DocumentImportService _importService;
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

    _subscription = _repository.watchDocuments().listen(
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
    final selectedIds = _sanitizeSelectedIds(state.selectedIds);

    emit(
      state.copyWith(
        documents: _applyFilters(),
        totalDocumentsCount: _allDocuments.length,
        selectedIds: selectedIds,
        selectionMode: selectedIds.isNotEmpty,
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
        documents: _applyFilters(searchQuery: event.query),
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
        documents: _applyFilters(filter: event.filter),
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
    final selectedIds = {...state.selectedIds};
    if (!selectedIds.add(event.id)) {
      selectedIds.remove(event.id);
    }

    emit(
      state.copyWith(
        selectedIds: selectedIds,
        selectionMode: selectedIds.isNotEmpty,
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
        selectedIds: {
          for (final document in state.documents) document.id,
        },
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

  Future<void> _onDeleteRequested(
    _DeleteRequested event,
    Emitter<DocumentsState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));

    try {
      await _repository.deleteDocument(event.id);
      final selectedIds = {...state.selectedIds}..remove(event.id);
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

  // TODO: remove
  Future<void> _onDeleteAllRequested(
    _DeleteAllRequested event,
    Emitter<DocumentsState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));

    try {
      await _repository.deleteAllDocuments();
      emit(
        state.copyWith(
          loading: false,
          selectionMode: false,
          selectedIds: const {},
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          loading: false,
          error: error.toString(),
        ),
      );
    }
  }

  Future<void> _onImportFromFilesRequested(
    _ImportFromFilesRequested event,
    Emitter<DocumentsState> emit,
  ) async {
    await _importDocument(emit, _importService.pickFromFiles);
  }

  Future<void> _onImportFromGalleryRequested(
    _ImportFromGalleryRequested event,
    Emitter<DocumentsState> emit,
  ) async {
    await _importDocument(emit, _importService.pickFromGallery);
  }

  Future<void> _onImportFromScannerRequested(
    _ImportFromScannerRequested event,
    Emitter<DocumentsState> emit,
  ) async {
    await _importDocument(
      emit,
      _importService.scanWithCunningDocumentScanner,
    );
  }

  Future<void> _importDocument(
    Emitter<DocumentsState> emit,
    Future<DocumentImportDraft?> Function() importDocument,
  ) async {
    _logger.i('Documents bloc: import started');
    emit(state.copyWith(loading: true, error: null));

    try {
      final draft = await importDocument();
      if (draft == null) {
        _logger.i('Documents bloc: import cancelled');
        emit(state.copyWith(loading: false));
        return;
      }

      _logger.i(
        'Documents bloc: import draft ready '
        'title=${draft.title}, filePath=${draft.filePath}, '
        'previews=${draft.previewImagePaths.length}',
      );
      await _repository.addDocument(draft.toDocumentModel());
      _logger.i('Documents bloc: import completed');
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

  List<DocumentModel> _applyFilters({
    DocumentsFilter? filter,
    String? searchQuery,
  }) {
    final effectiveFilter = filter ?? state.filter;
    final effectiveSearchQuery = (searchQuery ?? state.searchQuery)
        .trim()
        .toLowerCase();

    return _allDocuments
        .where((document) {
          final matchesFilter = switch (effectiveFilter) {
            DocumentsFilter.all => true,
            DocumentsFilter.signed => document.isSigned,
            DocumentsFilter.unsigned => !document.isSigned,
          };
          final matchesSearch =
              effectiveSearchQuery.isEmpty ||
              document.title.toLowerCase().contains(effectiveSearchQuery);

          return matchesFilter && matchesSearch;
        })
        .toList(growable: false);
  }

  Set<int> _sanitizeSelectedIds(Set<int> selectedIds) {
    final documentIds = _allDocuments.map((document) => document.id).toSet();

    return selectedIds.where(documentIds.contains).toSet();
  }
}
