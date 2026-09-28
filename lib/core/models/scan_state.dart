import 'package:flutter/foundation.dart';
import 'app_error_code.dart';

@immutable
sealed class ScanState {
  const ScanState();
  const factory ScanState.idle() = ScanIdle;
  const factory ScanState.recognizing() = ScanRecognizing;
  const factory ScanState.preparingModel(String t) = ScanPreparingModel;
  const factory ScanState.translating(String src, String lang) = ScanTranslating;
  const factory ScanState.done({
    required String sourceText,
    required String translatedText,
    required String sourceLanguage,
    required String targetLanguage,
  }) = ScanDone;
  const factory ScanState.error(
    AppErrorCode code, {
    String? sourceText,
    String? detail,
  }) = ScanError;
}

class ScanIdle extends ScanState { const ScanIdle(); }
class ScanRecognizing extends ScanState { const ScanRecognizing(); }

class ScanPreparingModel extends ScanState {
  final String targetLanguage;
  const ScanPreparingModel(this.targetLanguage);
}

class ScanTranslating extends ScanState {
  final String sourceText;
  final String sourceLanguage;
  const ScanTranslating(this.sourceText, this.sourceLanguage);
}

class ScanDone extends ScanState {
  final String sourceText;
  final String translatedText;
  final String sourceLanguage;
  final String targetLanguage;
  const ScanDone({
    required this.sourceText,
    required this.translatedText,
    required this.sourceLanguage,
    required this.targetLanguage,
  });
}

class ScanError extends ScanState {
  final AppErrorCode code;
  final String? sourceText;
  final String? detail;
  const ScanError(this.code, {this.sourceText, this.detail});
}
