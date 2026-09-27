import 'package:flutter/foundation.dart';

@immutable
class Language {
  final String code;
  final String nativeName;
  final String englishName;
  final bool isRtl;

  const Language({required this.code, required this.nativeName, required this.englishName, this.isRtl = false});
}

const List<Language> supportedLanguages = <Language>[
  Language(code: 'en', nativeName: 'English', englishName: 'English', isRtl: false),
  Language(code: 'zh', nativeName: '中文', englishName: 'Mandarin Chinese', isRtl: false),
  Language(code: 'es', nativeName: 'Español', englishName: 'Spanish', isRtl: false),
  Language(code: 'ar', nativeName: 'العربية', englishName: 'Arabic', isRtl: true),
  Language(code: 'fr', nativeName: 'Français', englishName: 'French', isRtl: false),
  Language(code: 'pt', nativeName: 'Português', englishName: 'Portuguese', isRtl: false),
  Language(code: 'ru', nativeName: 'Русский', englishName: 'Russian', isRtl: false),
  Language(code: 'hi', nativeName: 'हिन्दी', englishName: 'Hindi', isRtl: false),
  Language(code: 'bn', nativeName: 'বাংলা', englishName: 'Bengali', isRtl: false),
  Language(code: 'ja', nativeName: '日本語', englishName: 'Japanese', isRtl: false),
  Language(code: 'de', nativeName: 'Deutsch', englishName: 'German', isRtl: false),
  Language(code: 'ur', nativeName: 'اردو', englishName: 'Urdu', isRtl: true),
  Language(code: 'id', nativeName: 'Bahasa Indonesia', englishName: 'Indonesian', isRtl: false),
  Language(code: 'vi', nativeName: 'Tiếng Việt', englishName: 'Vietnamese', isRtl: false),
  Language(code: 'tr', nativeName: 'Türkçe', englishName: 'Turkish', isRtl: false),
  Language(code: 'fa', nativeName: 'فارسی', englishName: 'Persian', isRtl: true),
  Language(code: 'it', nativeName: 'Italiano', englishName: 'Italian', isRtl: false),
  Language(code: 'th', nativeName: 'ไทย', englishName: 'Thai', isRtl: false),
  Language(code: 'ko', nativeName: '한국어', englishName: 'Korean', isRtl: false),
  Language(code: 'pl', nativeName: 'Polski', englishName: 'Polish', isRtl: false),
  Language(code: 'uk', nativeName: 'Українська', englishName: 'Ukrainian', isRtl: false),
  Language(code: 'nl', nativeName: 'Nederlands', englishName: 'Dutch', isRtl: false),
  Language(code: 'fil', nativeName: 'Filipino', englishName: 'Filipino', isRtl: false),
  Language(code: 'my', nativeName: 'မြန်မာ', englishName: 'Burmese', isRtl: false),
  Language(code: 'he', nativeName: 'עברית', englishName: 'Hebrew', isRtl: true),
  Language(code: 'am', nativeName: 'አማርኛ', englishName: 'Amharic', isRtl: false),
  Language(code: 'el', nativeName: 'Ελληνικά', englishName: 'Greek', isRtl: false),
  Language(code: 'ro', nativeName: 'Română', englishName: 'Romanian', isRtl: false),
  Language(code: 'sv', nativeName: 'Svenska', englishName: 'Swedish', isRtl: false),
  Language(code: 'cs', nativeName: 'Čeština', englishName: 'Czech', isRtl: false),
  Language(code: 'hu', nativeName: 'Magyar', englishName: 'Hungarian', isRtl: false),
  Language(code: 'pa', nativeName: 'ਪੰਜਾਬੀ', englishName: 'Punjabi', isRtl: false),
  Language(code: 'ne', nativeName: 'नेपाली', englishName: 'Nepali', isRtl: false),
  Language(code: 'si', nativeName: 'සිංහල', englishName: 'Sinhala', isRtl: false),
  Language(code: 'km', nativeName: 'ខ្មែរ', englishName: 'Khmer', isRtl: false),
  Language(code: 'lo', nativeName: 'ລາວ', englishName: 'Lao', isRtl: false),
];
