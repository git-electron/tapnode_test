import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../../model/document_model.dart';
import 'document_files_cleaner_service.dart';

@LazySingleton(as: DocumentFilesCleanerService)
class DocumentFilesCleanerServiceImpl implements DocumentFilesCleanerService {
  const DocumentFilesCleanerServiceImpl(this._logger);

  final Logger _logger;

  @override
  Future<void> deleteManagedFiles(DocumentModel document) async {
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

  Future<List<String>> _managedDocumentDirectories() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();

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
      _logger.i('Documents files cleaner: deleted local file: $path');
    } on Object catch (error, stackTrace) {
      _logger.w(
        'Documents files cleaner: failed to delete local file: $path',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
