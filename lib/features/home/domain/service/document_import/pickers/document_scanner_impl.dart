import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:injectable/injectable.dart';

import '../document_import_service.dart';

@LazySingleton(as: DocumentScanner)
class DocumentScannerImpl implements DocumentScanner {
  const DocumentScannerImpl();

  @override
  Future<String?> scanPdfPath() async {
    final paths = await CunningDocumentScanner.getPictures(
      scannerSource: ScannerSource.camera,
      asPdf: true,
    );
    if (paths == null || paths.isEmpty) return null;

    return paths.first;
  }
}
