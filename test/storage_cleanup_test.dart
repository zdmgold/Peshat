import 'package:flutter_test/flutter_test.dart';
import 'package:peshat/core/services/storage_cleanup.dart';

void main() {
  const day = 24 * 60 * 60 * 1000;
  const now = 100 * day;
  const mb = 1024 * 1024;

  StoredFile f(String p, int size, int ageDays) =>
      StoredFile(p, size, now - ageDays * day);

  test('nothing is deleted while within the cap', () {
    expect(
        filesToSweep([f('a', 20 * mb, 9), f('b', 30 * mb, 9)],
            capBytes: 50 * mb, nowMs: now),
        isEmpty);
  });

  test('over the cap the oldest files go first until it fits', () {
    final out = filesToSweep(
      [f('new', 30 * mb, 2), f('old', 30 * mb, 9), f('mid', 30 * mb, 5)],
      capBytes: 50 * mb,
      nowMs: now,
    );
    expect(out, ['old', 'mid']);
  });

  test('files younger than a day are never deleted, even over the cap', () {
    final out = filesToSweep(
      [const StoredFile('fresh', 80 * mb, now - day ~/ 2), f('old', 10 * mb, 3)],
      capBytes: 50 * mb,
      nowMs: now,
    );
    expect(out, ['old']);
  });

  test('formatBytes', () {
    expect(StorageCleanup.formatBytes(500), '500 B');
    expect(StorageCleanup.formatBytes(2048), '2 KB');
    expect(StorageCleanup.formatBytes(3 * mb), '3.0 MB');
  });
}
