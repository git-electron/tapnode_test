import 'dart:io';

import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import '../../../domain/model/document_model.dart';
import '../../database/home_database.dart';
import 'watch_documents_repository.dart';

@LazySingleton(as: WatchDocumentsRepository)
class WatchDocumentsRepositoryImpl implements WatchDocumentsRepository {
  const WatchDocumentsRepositoryImpl(this._database);

  final HomeDatabase _database;

  @override
  Stream<List<DocumentModel>> call() {
    final query = _database.select(_database.documents)
      ..orderBy([
        (table) => OrderingTerm.desc(table.createdAt),
      ]);

    return query.watch().asyncMap(_mapRowsToModels);
  }

  Future<List<DocumentModel>> _mapRowsToModels(List<Document> rows) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();

    return rows
        .map((row) => _mapRowToModel(row, documentsDirectory))
        .toList(growable: false);
  }

  DocumentModel _mapRowToModel(Document row, Directory documentsDirectory) {
    return DocumentModel(
      id: row.id,
      title: row.title,
      filePath: _resolveManagedPath(row.filePath, documentsDirectory),
      createdAt: row.createdAt,
      type: row.type,
      isSigned: row.isSigned,
      source: row.source,
      pagePaths: _resolveManagedPaths(row.pagePaths, documentsDirectory),
      previewImagePaths: _resolveManagedPaths(
        row.previewImagePaths,
        documentsDirectory,
      ),
    );
  }

  List<String> _resolveManagedPaths(
    List<String> paths,
    Directory documentsDirectory,
  ) {
    return paths
        .map((path) => _resolveManagedPath(path, documentsDirectory))
        .toList(growable: false);
  }

  String _resolveManagedPath(String path, Directory documentsDirectory) {
    final normalizedPath = path.replaceAll(r'\', '/');

    return switch (normalizedPath) {
      final value when value.contains('/Documents/documents/') =>
        '${documentsDirectory.path}/documents/${_fileName(value)}',
      final value when value.contains('/Documents/document_previews/') =>
        '${documentsDirectory.path}/document_previews/${_fileName(value)}',
      _ => path,
    };
  }

  String _fileName(String path) {
    final normalizedPath = path.replaceAll(r'\', '/');

    return normalizedPath.split('/').last;
  }
}
