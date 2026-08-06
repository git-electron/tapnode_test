import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

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
  }) : _repository = repository,
       _importService = importService,
       super(const DocumentsState()) {
    on<DocumentsEvent>((event, emit) async {
      switch (event) {
        case _Started():
          await _onStarted();
        case _DocumentsChanged(:final documents):
          _allDocuments = documents;
          final selectedIds = _sanitizeSelectedIds(state.selectedIds);

          emit(
            state.copyWith(
              documents: _applyFilters(),
              selectedIds: selectedIds,
              selectionMode: selectedIds.isNotEmpty,
            ),
          );
        case _SearchChanged(:final query):
          emit(
            state.copyWith(
              searchQuery: query,
              documents: _applyFilters(searchQuery: query),
            ),
          );
        case _FilterChanged(:final filter):
          emit(
            state.copyWith(
              filter: filter,
              documents: _applyFilters(filter: filter),
            ),
          );
        case _SelectionStarted():
          emit(state.copyWith(selectionMode: true));
        case _SelectionCancelled():
          emit(
            state.copyWith(
              selectionMode: false,
              selectedIds: const {},
            ),
          );
        case _DocumentSelectionToggled(:final id):
          final selectedIds = {...state.selectedIds};
          if (!selectedIds.add(id)) {
            selectedIds.remove(id);
          }

          emit(
            state.copyWith(
              selectedIds: selectedIds,
              selectionMode: selectedIds.isNotEmpty,
            ),
          );
        case _SelectAll():
          emit(
            state.copyWith(
              selectionMode: true,
              selectedIds: {
                for (final document in state.documents) document.id,
              },
            ),
          );
        case _DeselectAll():
          emit(
            state.copyWith(
              selectionMode: false,
              selectedIds: const {},
            ),
          );
        case _ImportFromFilesRequested():
          await _importDocument(emit, _importService.pickFromFiles);
        case _ImportFromGalleryRequested():
          await _importDocument(emit, _importService.pickFromGallery);
        case _ImportFromScannerRequested():
          await _importDocument(
            emit,
            _importService.scanWithCunningDocumentScanner,
          );
      }
    });
  }

  final DocumentsRepository _repository;
  final DocumentImportService _importService;

  StreamSubscription<List<DocumentModel>>? _subscription;
  List<DocumentModel> _allDocuments = const [];

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  Future<void> _onStarted() async {
    await _subscription?.cancel();

    _subscription = _repository.watchDocuments().listen(
      (documents) {
        add(DocumentsEvent.documentsChanged(documents));
      },
    );
  }

  Future<void> _importDocument(
    Emitter<DocumentsState> emit,
    Future<DocumentImportDraft?> Function() importDocument,
  ) async {
    emit(state.copyWith(loading: true, error: null));

    try {
      final draft = await importDocument();
      if (draft == null) {
        emit(state.copyWith(loading: false));
        return;
      }

      await _repository.addDocument(draft.toDocumentModel());
      emit(state.copyWith(loading: false));
    } on Object catch (error) {
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
