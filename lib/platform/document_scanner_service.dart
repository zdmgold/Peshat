import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';

class DocumentScannerService {
  Future<List<String>> scan() async {
    try {
      final result = await FlutterDocScanner().getScannedDocumentAsImages(
        page: 1,
        quality: 1.0,
      );
      if (result == null || result.images.isEmpty) return const [];
      return result.images.map(_normalizePath).toList();
    } catch (_) {
      return const [];
    }
  }

  /// flutter_doc_scanner returns Android content paths prefixed with
  /// `file:` or `file://`. Both break InputImage.fromFilePath, which
  /// would treat the leading `file:` as a path segment and produce
  /// `/file:/data/...`. Strip the scheme; return a plain filesystem
  /// path starting with `/`.
  String _normalizePath(String raw) {
    var p = raw.trim();
    if (p.startsWith('file://')) p = p.substring(7);
    if (p.startsWith('file:')) p = p.substring(5);
    return p;
  }
}
