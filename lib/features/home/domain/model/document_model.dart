import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'document_model.freezed.dart';

enum DocumentImportSource {
  file,
  gallery,
  scanner,
}

enum DocumentsFilter {
  all,
  signed,
  unsigned,
}

@freezed
abstract class DocumentModel extends Equatable with _$DocumentModel {
  const DocumentModel._();

  const factory DocumentModel({
    required int id,
    required String title,
    required String filePath,
    required DateTime createdAt,
    @Default('PDF') String type,
    @Default(false) bool isSigned,
    @Default(DocumentImportSource.file) DocumentImportSource source,
    @Default([]) List<String> pagePaths,
    @Default([]) List<String> previewImagePaths,
  }) = _DocumentModel;

  String? get firstPreviewImagePath {
    if (previewImagePaths.isEmpty) return null;

    return previewImagePaths.first;
  }

  String? get lastPreviewImagePath {
    if (previewImagePaths.length < 2) return null;

    return previewImagePaths.last;
  }

  bool get hasSinglePreviewImage => previewImagePaths.length == 1;

  bool get hasDoublePreviewImages => previewImagePaths.length >= 2;

  @override
  List<Object?> get props => [
    id,
    title,
    filePath,
    createdAt,
    type,
    isSigned,
    source,
    pagePaths,
    previewImagePaths,
  ];
}

@freezed
abstract class DocumentImportDraft extends Equatable
    with _$DocumentImportDraft {
  const DocumentImportDraft._();

  const factory DocumentImportDraft({
    required String title,
    required String filePath,
    required DocumentImportSource source,
    @Default('PDF') String type,
    @Default([]) List<String> pagePaths,
    @Default([]) List<String> previewImagePaths,
  }) = _DocumentImportDraft;

  DocumentModel toDocumentModel({DateTime? createdAt}) {
    return DocumentModel(
      id: 0,
      title: title,
      filePath: filePath,
      createdAt: createdAt ?? DateTime.now(),
      type: type,
      source: source,
      pagePaths: pagePaths,
      previewImagePaths: previewImagePaths,
    );
  }

  @override
  List<Object?> get props => [
    title,
    filePath,
    source,
    type,
    pagePaths,
    previewImagePaths,
  ];
}
