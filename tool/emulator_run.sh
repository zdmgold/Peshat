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
( adb logcat -v time > emu-out/logcat.txt 2>&1 & )
timeout 900 flutter test integration_test/ocr_probe_test.dart -d emulator-5554 2>&1 | tee emu-out/ocr.log
timeout 2100 flutter test integration_test/typed_probe_test.dart -d emulator-5554 2>&1 | tee emu-out/typed.log
[ "${RUN_FLOW:-0}" = 1 ] && timeout 900 flutter test integration_test/app_flow_test.dart -d emulator-5554 -v 2>&1 | tee emu-out/test.log
echo "${PIPESTATUS[0]}" > emu-out/status.txt
kill "$SHOTS" 2>/dev/null
adb logcat -d -v time > emu-out/logcat.txt 2>&1
adb shell dumpsys activity top 2>&1 | head -60 > emu-out/top-activity.txt
exit 0
