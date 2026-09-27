import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/scan_result.dart';

class LocalStorage {
  final SharedPreferences prefs;
  LocalStorage(this.prefs);

  Future<void> saveRecent(ScanResult r) async {
    try {
      final list = prefs.getStringList('recent_scans') ?? [];
      list.insert(0, jsonEncode(r.toJson()));
      await prefs.setStringList('recent_scans', list.take(50).toList());
    } catch (_) {
      // In-memory fallback; warning banner surfaced by caller if needed
    }
  }

  Future<List<ScanResult>> getRecent() async {
    final list = prefs.getStringList('recent_scans') ?? [];
    return list.map((e) => ScanResult.fromJson(jsonDecode(e))).toList();
  }
}
