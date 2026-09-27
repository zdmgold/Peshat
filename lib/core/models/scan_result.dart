import 'package:flutter/foundation.dart';

@immutable
class ScanResult {
  final String id;
  final String sourceText;
  final String translatedText;
  final String sourceLang;
  final String targetLang;
  final DateTime timestamp;
  final double confidence;

  const ScanResult({
    required this.id,
    required this.sourceText,
    required this.translatedText,
    required this.sourceLang,
    required this.targetLang,
    required this.timestamp,
    required this.confidence,
  });

  ScanResult copyWith({
    String? id,
    String? sourceText,
    String? translatedText,
    String? sourceLang,
    String? targetLang,
    DateTime? timestamp,
    double? confidence,
  }) {
    return ScanResult(
      id: id ?? this.id,
      sourceText: sourceText ?? this.sourceText,
      translatedText: translatedText ?? this.translatedText,
      sourceLang: sourceLang ?? this.sourceLang,
      targetLang: targetLang ?? this.targetLang,
      timestamp: timestamp ?? this.timestamp,
      confidence: confidence ?? this.confidence,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'sourceText': sourceText,
    'translatedText': translatedText,
    'sourceLang': sourceLang,
    'targetLang': targetLang,
    'timestamp': timestamp.toIso8601String(),
    'confidence': confidence,
  };

  factory ScanResult.fromJson(Map<String, dynamic> j) => ScanResult(
    id: j['id'],
    sourceText: j['sourceText'],
    translatedText: j['translatedText'],
    sourceLang: j['sourceLang'],
    targetLang: j['targetLang'],
    timestamp: DateTime.parse(j['timestamp']),
    confidence: j['confidence'],
  );

  @override
  bool operator ==(Object other) => other is ScanResult && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
