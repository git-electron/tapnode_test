import '../../model/document_model.dart';

abstract interface class ImportDocumentUseCase {
  Future<bool> call(DocumentImportSource source);
}
