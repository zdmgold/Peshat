import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/scan_result.dart';

class LocalStorage {
  static const _recentKey = 'recent_scans';
  static const _maxRecent = 50;

  final SharedPreferences prefs;
  LocalStorage(this.prefs);

  Future<void> saveRecent(ScanResult r) async {
    try {
      final list = prefs.getStringList(_recentKey) ?? [];
      list.insert(0, jsonEncode(r.toJson()));
      await prefs.setStringList(
        _recentKey,
        list.take(_maxRecent).toList(),
      );
    } catch (_) {
      // Persistence failure is surfaced by the caller if needed;
      // in-memory state stays authoritative for the session.
    }
  }

  Future<List<ScanResult>> getRecent() async {
    final list = prefs.getStringList(_recentKey) ?? [];
    final results = <ScanResult>[];
    for (final raw in list) {
      try {
        results.add(ScanResult.fromJson(jsonDecode(raw) as Map<String, dynamic>));
      } catch (_) {
        // Skip corrupt entries rather than failing the whole load.
      }
    }
    return results;
  }

  Future<void> clear() async {
    await prefs.remove(_recentKey);
  }
}
