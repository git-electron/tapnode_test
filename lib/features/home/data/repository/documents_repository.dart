import 'dart:io';

import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/model/document_model.dart';
import '../database/home_database.dart';

abstract interface class DocumentsRepository {
  Stream<List<DocumentModel>> watchDocuments();

  Future<DocumentModel> addDocument(DocumentModel document);

  Future<void> deleteDocument(int id);

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

    return query.watch().asyncMap(_mapRowsToModels);
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

  @override
  Future<void> deleteDocument(int id) async {
    _logger.i('Documents repository: deleting document id=$id');
    final document = await _documentById(id);
    if (document == null) {
      _logger.w('Documents repository: document id=$id not found');
      return;
    }

    await _deleteDocumentFiles(document);
    await (_database.delete(
      _database.documents,
    )..where((row) => row.id.equals(id))).go();
    _logger.i('Documents repository: deleted document id=$id');
  }

  // TODO: remove
  @override
  Future<void> deleteAllDocuments() async {
    final documents = await _database.select(_database.documents).get();
    for (final document in await _mapRowsToModels(documents)) {
      await _deleteDocumentFiles(document);
    }
    await _deleteManagedDirectoriesContent();

    await _database.delete(_database.documents).go();
  }

  Future<DocumentModel?> _documentById(int id) async {
    final query = _database.select(_database.documents)
      ..where((row) => row.id.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) return null;

    return _mapRowToModel(row, await _appDocumentsDirectory());
  }

  Future<void> _deleteDocumentFiles(DocumentModel document) async {
    final managedDirectories = await _managedDocumentDirectories();
    final paths = {
      document.filePath,
      ...document.pagePaths,
      ...document.previewImagePaths,
    };

    for (final path in paths) {
      if (!_isManagedPath(path, managedDirectories)) continue;
      await _deleteFile(path);
    }
  }

  Future<void> _deleteManagedDirectoriesContent() async {
    final managedDirectories = await _managedDocumentDirectories();

    for (final path in managedDirectories) {
      final directory = Directory(path);
      if (!directory.existsSync()) continue;

      await for (final entity in directory.list()) {
        if (entity is File) await _deleteFile(entity.path);
      }
    }
  }

  Future<List<String>> _managedDocumentDirectories() async {
    final documentsDirectory = await _appDocumentsDirectory();

    return [
      '${documentsDirectory.path}/documents',
      '${documentsDirectory.path}/document_previews',
    ];
  }

  bool _isManagedPath(String path, List<String> managedDirectories) {
    final normalizedPath = path.replaceAll(r'\', '/');

    return managedDirectories.any((directory) {
      final normalizedDirectory = directory.replaceAll(r'\', '/');

      return normalizedPath == normalizedDirectory ||
          normalizedPath.startsWith('$normalizedDirectory/');
    });
  }

  Future<void> _deleteFile(String path) async {
    final file = File(path);
    if (!file.existsSync()) return;

    try {
      await file.delete();
      _logger.i('Documents repository: deleted local file: $path');
    } on Object catch (error, stackTrace) {
      _logger.w(
        'Documents repository: failed to delete local file: $path',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<List<DocumentModel>> _mapRowsToModels(List<Document> rows) async {
    final documentsDirectory = await _appDocumentsDirectory();

    return rows
        .map((row) => _mapRowToModel(row, documentsDirectory))
        .toList(growable: false);
  }

  Future<Directory> _appDocumentsDirectory() {
    return getApplicationDocumentsDirectory();
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
