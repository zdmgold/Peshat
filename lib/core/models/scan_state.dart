import 'package:flutter/foundation.dart';

@immutable
sealed class ScanState {
  const ScanState();
  const factory ScanState.idle() = ScanIdle;
  const factory ScanState.recognizing() = ScanRecognizing;
  const factory ScanState.translating(String sourceText) = ScanTranslating;
  const factory ScanState.done(String sourceText, String translatedText) = ScanDone;
}

class ScanIdle extends ScanState {
  const ScanIdle();
}

class ScanRecognizing extends ScanState {
  const ScanRecognizing();
}

class ScanTranslating extends ScanState {
  final String sourceText;
  const ScanTranslating(this.sourceText);
}

class ScanDone extends ScanState {
  final String sourceText;
  final String translatedText;
  const ScanDone(this.sourceText, this.translatedText);
}
