import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/scan_result.dart';
import '../services/local_storage.dart';

class HistoryProvider extends ValueNotifier<List<ScanResult>> {
  final LocalStorage _storage;

  HistoryProvider(SharedPreferences prefs)
      : _storage = LocalStorage(prefs),
        super(const []) {
    _load();
  }

  Future<void> _load() async => value = await _storage.getRecent();

  Future<void> add(ScanResult r) async {
    await _storage.saveRecent(r);
    value = [r, ...value];
  }

  Future<void> delete(String id) async {
    final next = value.where((r) => r.id != id).toList();
    value = next;
    await _writeAll(next);
  }

  Future<void> clear() async {
    await _storage.clear();
    value = const [];
  }

  Future<void> _writeAll(List<ScanResult> items) async {
    // LocalStorage only exposes saveRecent; rewrite from empty
    await _storage.clear();
    for (final r in items.reversed) {
      await _storage.saveRecent(r);
    }
  }
}
