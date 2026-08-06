import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/model/document_model.dart';
import '../../../domain/service/service.dart';
import '../../database/home_database.dart';
import 'watch_documents_repository.dart';

@LazySingleton(as: WatchDocumentsRepository)
class WatchDocumentsRepositoryImpl implements WatchDocumentsRepository {
  const WatchDocumentsRepositoryImpl(
    this._database,
    this._pathResolver,
  );

  final HomeDatabase _database;
  final DocumentPathResolverService _pathResolver;

  @override
  Stream<List<DocumentModel>> call() {
    final query = _database.select(_database.documents)
      ..orderBy([
        (table) => OrderingTerm.desc(table.createdAt),
      ]);

    return query.watch().asyncMap(_mapRowsToModels);
  }

  Future<List<DocumentModel>> _mapRowsToModels(List<Document> rows) async {
    final documents = <DocumentModel>[];
    for (final row in rows) {
      documents.add(await _mapRowToModel(row));
    }

    return documents;
  }

  Future<DocumentModel> _mapRowToModel(Document row) async {
    return DocumentModel(
      id: row.id,
      title: row.title,
      filePath: await _pathResolver.resolveManagedPath(row.filePath),
      createdAt: row.createdAt,
      type: row.type,
      isSigned: row.isSigned,
      source: row.source,
      pagePaths: await _pathResolver.resolveManagedPaths(row.pagePaths),
      previewImagePaths: await _pathResolver.resolveManagedPaths(
        row.previewImagePaths,
      ),
    );
  }
}
