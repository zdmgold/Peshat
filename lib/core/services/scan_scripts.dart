import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// Value of the source-language choice meaning "work it out for me".
const String sourceAuto = 'auto';

/// Languages whose writing the camera has no reader for. Photos of these can't
/// be read, so people type or paste the text instead.
const Set<String> cameraTypeOnly = {
  'be', 'bg', 'mk', 'ru', 'uk', // Cyrillic
  'el', // Greek
  'ar', 'fa', 'ur', // Arabic script
  'he', // Hebrew
  'th', // Thai
  'gu', 'kn', 'ta', 'te', // other Indic
  'ka', // Georgian
};

/// The text reader to run for a source language, or null when the camera has
/// no reader for it. [sourceAuto] returns null too; callers treat it separately.
TextRecognitionScript? scanScriptFor(String code) {
  if (code == sourceAuto || cameraTypeOnly.contains(code)) return null;
  switch (code) {
    case 'zh':
      return TextRecognitionScript.chinese;
    case 'ja':
      return TextRecognitionScript.japanese;
    case 'ko':
      return TextRecognitionScript.korean;
    case 'hi':
    case 'mr':
    case 'bn': // the Devanagari reader reads Bengali too
      return TextRecognitionScript.devanagiri;
    default:
      return TextRecognitionScript.latin;
  }
}

/// True when a photo in this source language can be read by the camera.
bool cameraCanRead(String code) =>
    code == sourceAuto || !cameraTypeOnly.contains(code);

/// Languages written in the same script that language detection can mix up on a
/// short phrase (Macedonian read as Bulgarian, Marathi as Hindi).
const List<Set<String>> confusableLanguages = [
  {'ru', 'uk', 'bg', 'be', 'mk'}, // Cyrillic
  {'ar', 'fa', 'ur'}, // Arabic script
  {'hi', 'mr'}, // Devanagari
  {'zh', 'ja'}, // Han
  {'id', 'ms'}, // Malay / Indonesian (Malay read as Indonesian on the emulator)
  {'hr', 'sl'}, // Slovenian read as Croatian on the emulator
];

/// True when [a] and [b] are different languages that share a script group.
bool confusableWith(String a, String b) {
  if (a == b) return false;
  return confusableLanguages.any((g) => g.contains(a) && g.contains(b));
}
