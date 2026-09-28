/// Every failure mode the scan→translate pipeline can surface.
/// The UI maps each code to an ARB key (batch 2). Dart strings never
/// appear in the UI; only these codes travel between layers.
enum AppErrorCode {
  /// OCR ran successfully but the image contained no readable text.
  noTextDetected,

  /// The image file could not be opened or is corrupted.
  imageUnreadable,

  /// ML Kit could not download the translation model for one of the
  /// languages involved (network failure, storage full, MDM block).
  modelDownloadFailed,

  /// The requested language is not one ML Kit can translate.
  unsupportedLanguage,

  /// TextRecognizer threw during processing.
  ocrFailed,

  /// OnDeviceTranslator threw during translation.
  translationFailed,

  /// A pipeline step exceeded its timeout budget.
  timeout,

  /// Anything not covered above; treated as a bug class.
  unknown,
}
