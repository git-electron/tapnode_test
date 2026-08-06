import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

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
  }) : _database = database,
       _logger = logger,
       _filesCleaner = filesCleaner;

  final HomeDatabase _database;
  final Logger _logger;
  final DocumentFilesCleanerService _filesCleaner;

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

    return _mapRowToModel(row, await getApplicationDocumentsDirectory());
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
