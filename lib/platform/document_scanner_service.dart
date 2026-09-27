import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';

class DocumentScannerService {
  Future<List<String>> scan() async {
    try {
      final ImageScanResult? result = await FlutterDocScanner()
          .getScannedDocumentAsImages(page: 1, quality: 1.0);
      if (result == null || result.images.isEmpty) return [];
      return result.images;
    } catch (e) {
      return [];
    }
  }
}
