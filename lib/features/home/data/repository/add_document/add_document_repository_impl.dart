import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../../domain/model/document_model.dart';
import '../../database/home_database.dart';
import 'add_document_repository.dart';

@LazySingleton(as: AddDocumentRepository)
class AddDocumentRepositoryImpl implements AddDocumentRepository {
  const AddDocumentRepositoryImpl(
    this._database,
    this._logger,
  );

  final HomeDatabase _database;
  final Logger _logger;

  @override
  Future<DocumentModel> call(DocumentModel document) async {
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
}
