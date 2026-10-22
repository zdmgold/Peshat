#!/usr/bin/env bash
# Runs inside the emulator-runner action. Collects screenshots + logs.
mkdir -p emu-out/shots
( prev=""
  while true; do
    f="emu-out/shots/$(date +%H%M%S).png"
    adb exec-out screencap -p > "$f" 2>/dev/null
    h=$(md5sum "$f" | cut -d' ' -f1)
    if [ "$h" = "$prev" ]; then rm -f "$f"; fi
    prev="$h"
    sleep 3
  done ) &
SHOTS=$!
adb logcat -c
[ -n "$FONT_SCALE" ] && adb shell settings put system font_scale "$FONT_SCALE"
[ "$NIGHT" = yes ] && adb shell cmd uimode night yes
sleep 3
( adb logcat -v time > emu-out/logcat.txt 2>&1 & )
has() { case ",${PROBES:-ocr,typed}," in *",$1,"*) return 0;; esac; return 1; }
has ocr && timeout 2700 flutter test integration_test/ocr_probe_test.dart -d emulator-5554 2>&1 | tee emu-out/ocr.log
has latin && timeout 2700 flutter test integration_test/latin_probe_test.dart -d emulator-5554 2>&1 | tee emu-out/latin.log
has photo && timeout 3300 flutter test integration_test/photo_probe_test.dart -d emulator-5554 2>&1 | tee emu-out/photo.log
has pdf && timeout 900 flutter test integration_test/pdf_probe_test.dart -d emulator-5554 2>&1 | tee emu-out/pdf.log
has translate && timeout 4200 flutter test integration_test/translate_probe_test.dart -d emulator-5554 2>&1 | tee emu-out/translate.log
has matrix && timeout 1500 flutter test integration_test/reader_matrix_test.dart -d emulator-5554 2>&1 | tee emu-out/matrix.log
has langid && timeout 600 flutter test integration_test/langid_probe_test.dart -d emulator-5554 2>&1 | tee emu-out/langid.log
has typed && timeout 2100 flutter test integration_test/typed_probe_test.dart -d emulator-5554 2>&1 | tee emu-out/typed.log
has user && timeout 5400 flutter test integration_test/user_samples_test.dart -d emulator-5554 2>&1 | tee emu-out/user.log
has mixed && timeout 5400 flutter test integration_test/mixed_probe_test.dart -d emulator-5554 2>&1 | tee emu-out/mixed.log
has flow && timeout 900 flutter test integration_test/app_flow_test.dart -d emulator-5554 -v 2>&1 | tee emu-out/test.log
echo "${PIPESTATUS[0]}" > emu-out/status.txt
kill "$SHOTS" 2>/dev/null
adb logcat -d -v time > emu-out/logcat.txt 2>&1
adb shell dumpsys activity top 2>&1 | head -60 > emu-out/top-activity.txt
exit 0
