import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../../domain/model/document_model.dart';
import '../../../domain/service/service.dart';
import '../../database/home_database.dart';
import 'delete_document_repository.dart';

@LazySingleton(as: DeleteDocumentRepository)
class DeleteDocumentRepositoryImpl implements DeleteDocumentRepository {
  const DeleteDocumentRepositoryImpl({
    required HomeDatabase database,
    required Logger logger,
    required DocumentFilesCleanerService filesCleaner,
    required DocumentPathResolverService pathResolver,
  }) : _database = database,
       _logger = logger,
       _filesCleaner = filesCleaner,
       _pathResolver = pathResolver;

  final HomeDatabase _database;
  final Logger _logger;
  final DocumentFilesCleanerService _filesCleaner;
  final DocumentPathResolverService _pathResolver;

  @override
  Future<void> call(int id) async {
    _logger.i('Documents repository: deleting document id=$id');
    final document = await _documentById(id);
    if (document == null) {
      _logger.w('Documents repository: document id=$id not found');
      return;
    }

    await _filesCleaner.deleteManagedFiles(document);
    await (_database.delete(
      _database.documents,
    )..where((row) => row.id.equals(id))).go();
    _logger.i('Documents repository: deleted document id=$id');
  }

  Future<DocumentModel?> _documentById(int id) async {
    final query = _database.select(_database.documents)
      ..where((row) => row.id.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) return null;

    return _mapRowToModel(row);
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
