import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../document_import_service.dart';

@LazySingleton(as: ImagePdfFactory)
class ImagePdfFactoryImpl implements ImagePdfFactory {
  const ImagePdfFactoryImpl(this._logger);

  final Logger _logger;

  @override
  Future<void> createPdfFromImage({
    required String imagePath,
    required String pdfPath,
  }) async {
    _logger.i('Document import: creating PDF from image: $pdfPath');
    final imageBytes = await File(imagePath).readAsBytes();
    final pdf = pw.Document();
    final image = pw.MemoryImage(imageBytes);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (context) {
          return pw.Center(
            child: pw.Image(
              image,
            ),
          );
        },
      ),
    );

    final pdfFile = File(pdfPath);
    await pdfFile.writeAsBytes(await pdf.save(), flush: true);
    _logger.i(
      'Document import: created gallery PDF exists=${pdfFile.existsSync()}, '
      'size=${pdfFile.lengthSync()} bytes',
    );
  }
}
