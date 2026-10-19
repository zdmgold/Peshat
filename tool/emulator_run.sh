#!/usr/bin/env bash
# Runs inside the emulator-runner action. Collects screenshots + logs.
mkdir -p emu-out/shots
( while true; do
    adb exec-out screencap -p > "emu-out/shots/$(date +%H%M%S).png" 2>/dev/null
    sleep 3
  done ) &
SHOTS=$!
adb logcat -c
( adb logcat -v time > emu-out/logcat.txt 2>&1 & )
flutter test integration_test/app_flow_test.dart -d emulator-5554 2>&1 | tee emu-out/test.log
echo "${PIPESTATUS[0]}" > emu-out/status.txt
kill "$SHOTS" 2>/dev/null
# drop consecutive duplicate frames
prev=""
for f in emu-out/shots/*.png; do
  h=$(md5sum "$f" | cut -d' ' -f1)
  if [ "$h" = "$prev" ]; then rm -f "$f"; fi
  prev="$h"
done
exit 0
