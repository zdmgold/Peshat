import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';

class DocumentScannerService {
  Future<List<String>> scan() async {
    try {
      final dynamic result = await FlutterDocScanner().getScannedDocumentAsImages();
      if (result is Map && result['images'] is List) {
        return (result['images'] as List).map((e) => e.toString()).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
