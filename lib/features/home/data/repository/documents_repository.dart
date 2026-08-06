import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../domain/model/document_model.dart';
import '../database/home_database.dart';

abstract interface class DocumentsRepository {
  Stream<List<DocumentModel>> watchDocuments();

  Future<DocumentModel> addDocument(DocumentModel document);

  // TODO: remove
  Future<void> deleteAllDocuments();
}

@LazySingleton(as: DocumentsRepository)
class DriftDocumentsRepository implements DocumentsRepository {
  const DriftDocumentsRepository(
    this._database,
    this._logger,
  );

  final HomeDatabase _database;
  final Logger _logger;

  @override
  Stream<List<DocumentModel>> watchDocuments() {
    final query = _database.select(_database.documents)
      ..orderBy([
        (table) => OrderingTerm.desc(table.createdAt),
      ]);

    return query.watch().map(
      (rows) => rows.map(_mapRowToModel).toList(growable: false),
    );
  }

  @override
  Future<DocumentModel> addDocument(DocumentModel document) async {
    _logger.i(
      'Documents repository: inserting document '
      'title=${document.title}, filePath=${document.filePath}, '
      'previews=${document.previewImagePaths.length}',
    );
    final id = await _database
        .into(_database.documents)
        .insert(
          DocumentsCompanion.insert(
            title: document.title,
            filePath: document.filePath,
            createdAt: document.createdAt,
            type: Value(document.type),
            isSigned: Value(document.isSigned),
            source: document.source,
            pagePaths: Value(document.pagePaths),
            previewImagePaths: Value(document.previewImagePaths),
          ),
        );

    _logger.i('Documents repository: inserted document id=$id');
    return document.copyWith(id: id);
  }

  // TODO: remove
  @override
  Future<void> deleteAllDocuments() async {
    await _database.delete(_database.documents).go();
  }

  DocumentModel _mapRowToModel(Document row) {
    return DocumentModel(
      id: row.id,
      title: row.title,
      filePath: row.filePath,
      createdAt: row.createdAt,
      type: row.type,
      isSigned: row.isSigned,
      source: row.source,
      pagePaths: row.pagePaths,
      previewImagePaths: row.previewImagePaths,
    );
  }
}
