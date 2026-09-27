import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class TextRecognizerService {
  final _recognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<RecognizedText> recognize(InputImage image) async {
    return await _recognizer.processImage(image);
  }

  void dispose() {
    _recognizer.close();
  }
}
