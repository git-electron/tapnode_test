import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import 'document_path_resolver_service.dart';

@LazySingleton(as: DocumentPathResolverService)
class DocumentPathResolverServiceImpl implements DocumentPathResolverService {
  const DocumentPathResolverServiceImpl();

  @override
  Future<String> resolveManagedPath(String path) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();

    return _resolveManagedPath(path, documentsDirectory);
  }

  @override
  Future<List<String>> resolveManagedPaths(List<String> paths) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();

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
