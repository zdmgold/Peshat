import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../models/scan_state.dart';
import '../services/text_recognizer_service.dart';
import '../services/translator_service.dart';

class ScanProvider extends ValueNotifier<ScanState> {
  ScanProvider() : super(const ScanState.idle());

  Future<void> runPipeline(
    XFile image, 
    TextRecognizerService ocr, 
    TranslatorService tx, 
    String target
  ) async {
    value = const ScanState.recognizing();
    final recognized = await ocr.recognize(InputImage.fromFilePath(image.path));
    value = ScanState.translating(recognized.text);
    final translated = await tx.translate(recognized.text, 'auto', target);
    value = ScanState.done(recognized.text, translated);
  }
}
