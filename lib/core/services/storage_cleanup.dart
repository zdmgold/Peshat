import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const int kExportsCapBytes = 50 * 1024 * 1024;
const int kScanPhotosCapBytes = 50 * 1024 * 1024;
const Duration _kMinAge = Duration(days: 1);
const String _kPrefScanPaths = 'scan_photo_paths';
const int _kMaxTrackedScanPaths = 300;

class StoredFile {
  final String path;
  final int size;
  final int modifiedMs;
  const StoredFile(this.path, this.size, this.modifiedMs);
}

/// Pure rule: nothing is deleted while the total is within [capBytes]. Over
/// the cap, the oldest files go first until the total fits, and a file
/// younger than a day is never deleted, even if that leaves it over the cap.
@visibleForTesting
List<String> filesToSweep(
  List<StoredFile> files, {
  required int capBytes,
  required int nowMs,
}) {
  var total = files.fold<int>(0, (a, f) => a + f.size);
  if (total <= capBytes) return const [];
  final sorted = [...files]..sort((a, b) => a.modifiedMs.compareTo(b.modifiedMs));
  final out = <String>[];
  for (final f in sorted) {
    if (total <= capBytes) break;
    if (nowMs - f.modifiedMs < _kMinAge.inMilliseconds) continue;
    out.add(f.path);
    total -= f.size;
  }
  return out;
}

/// Keeps the app's own temporary files (exports, scanner photos, cached PDF
/// fonts) within bounds, and lets people clear them from Settings.
class StorageCleanup {
  StorageCleanup._();

  static Future<Directory> exportsDir() async {
    final tmp = await getTemporaryDirectory();
    final dir = Directory('${tmp.path}/peshat_exports');
    await dir.create(recursive: true);
    return dir;
  }

  static Future<Directory> _fontsDir() async {
    final dir = await getApplicationSupportDirectory();
    return Directory('${dir.path}/pdf_fonts');
  }

  static Future<List<StoredFile>> _listDir(Directory d) async {
    final out = <StoredFile>[];
    if (!await d.exists()) return out;
    await for (final e in d.list(recursive: true, followLinks: false)) {
      if (e is File) {
        final s = await e.stat();
        out.add(StoredFile(e.path, s.size, s.modified.millisecondsSinceEpoch));
      }
    }
    return out;
  }

  /// Remembers where the scanner saved photos (only these paths are ever
  /// touched, and only when they sit under the app's cache folder).
  static Future<void> rememberScanPaths(List<String> paths) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final all = <String>{...(prefs.getStringList(_kPrefScanPaths) ?? []), ...paths}
          .toList();
      final keep = all.length > _kMaxTrackedScanPaths
          ? all.sublist(all.length - _kMaxTrackedScanPaths)
          : all;
      await prefs.setStringList(_kPrefScanPaths, keep);
    } catch (_) {}
  }

  static Future<List<StoredFile>> _trackedScanFiles() async {
    final prefs = await SharedPreferences.getInstance();
    final cache = (await getTemporaryDirectory()).path;
    final out = <StoredFile>[];
    for (final p in prefs.getStringList(_kPrefScanPaths) ?? const <String>[]) {
      if (!p.startsWith('$cache/')) continue;
      final f = File(p);
      if (await f.exists()) {
        final s = await f.stat();
        out.add(StoredFile(p, s.size, s.modified.millisecondsSinceEpoch));
      }
    }
    return out;
  }

  static Future<void> _delete(Iterable<String> paths) async {
    for (final p in paths) {
      try {
        await File(p).delete();
      } catch (_) {}
    }
  }

  /// Runs at app start (not awaited).
  static Future<void> sweepAtStartup() async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      await _delete(filesToSweep(await _listDir(await exportsDir()),
          capBytes: kExportsCapBytes, nowMs: now));
      await _delete(filesToSweep(await _trackedScanFiles(),
          capBytes: kScanPhotosCapBytes, nowMs: now));
    } catch (_) {}
  }

  /// Bytes used by exports, cached PDF fonts and tracked scanner photos.
  static Future<int> usedBytes() async {
    try {
      final all = [
        ...await _listDir(await exportsDir()),
        ...await _listDir(await _fontsDir()),
        ...await _trackedScanFiles(),
      ];
      return all.fold<int>(0, (a, f) => a + f.size);
    } catch (_) {
      return 0;
    }
  }

  /// Deletes everything counted by [usedBytes], whatever its age.
  static Future<void> clearAll() async {
    try {
      await _delete([
        ...(await _listDir(await exportsDir())).map((f) => f.path),
        ...(await _listDir(await _fontsDir())).map((f) => f.path),
        ...(await _trackedScanFiles()).map((f) => f.path),
      ]);
    } catch (_) {}
  }

  /// "0.4 MB" style label.
  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
