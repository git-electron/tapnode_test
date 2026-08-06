import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../database/home_database.dart';
import 'toggle_document_signed_repository.dart';

@LazySingleton(as: ToggleDocumentSignedRepository)
class ToggleDocumentSignedRepositoryImpl
    implements ToggleDocumentSignedRepository {
  const ToggleDocumentSignedRepositoryImpl(
    this._database,
    this._logger,
  );

  final HomeDatabase _database;
  final Logger _logger;

  @override
  Future<void> call(int id) async {
    _logger.i('Documents repository: toggling signed state id=$id');
    final document = await _documentById(id);
    if (document == null) {
      _logger.w('Documents repository: document id=$id not found');
      return;
    }

    await (_database.update(
      _database.documents,
    )..where((row) => row.id.equals(id))).write(
      DocumentsCompanion(
        isSigned: Value(!document.isSigned),
      ),
    );
    _logger.i(
      'Documents repository: toggled signed state id=$id, '
      'isSigned=${!document.isSigned}',
    );
  }

  Future<Document?> _documentById(int id) {
    final query = _database.select(_database.documents)
      ..where((row) => row.id.equals(id));

    return query.getSingleOrNull();
  }
}
