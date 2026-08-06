import 'package:file_picker/file_picker.dart';
import 'package:injectable/injectable.dart';

import '../document_import_service.dart';

@LazySingleton(as: PdfFilePicker)
class PdfFilePickerImpl implements PdfFilePicker {
  const PdfFilePickerImpl();

  @override
  Future<String?> pickPdfPath() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf'],
    );

    return result?.files.single.path;
  }
}
