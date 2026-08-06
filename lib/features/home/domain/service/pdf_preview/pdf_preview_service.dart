abstract interface class PdfPreviewService {
  Future<List<String>> generateForPdf(String pdfPath);
}
