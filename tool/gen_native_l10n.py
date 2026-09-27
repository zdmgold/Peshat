#!/usr/bin/env python3
"""Generate native localization files from ARB sources.

Reads lib/l10n/app_*.arb and writes:
  android/app/src/main/res/values-<qualifier>/strings.xml
  ios/Runner/<qualifier>.lproj/InfoPlist.strings

English is skipped: Android's default values/strings.xml and iOS's
inline Info.plist values are the English fallback.
"""
import json
import os
import sys
from html import escape as xml_escape

ARB_DIR = "lib/l10n"
ANDROID_BASE = "android/app/src/main/res"
IOS_BASE = "ios/Runner"

# ARB code -> Android locale qualifier
ANDROID_QUALIFIERS = {
    "zh": "zh-rCN",   # Simplified Chinese
    "pt": "pt-rBR",   # Brazilian Portuguese
}

# ARB code -> iOS lproj directory name
IOS_QUALIFIERS = {
    "zh": "zh-Hans",  # Simplified Chinese
    "pt": "pt-BR",    # Brazilian Portuguese
}

def android_qualifier(code):
    return ANDROID_QUALIFIERS.get(code, code)

def ios_qualifier(code):
    return IOS_QUALIFIERS.get(code, code)

def load_arb(path):
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)

def write_android_strings(locale, app_name):
    qualifier = android_qualifier(locale)
    out_dir = os.path.join(ANDROID_BASE, f"values-{qualifier}")
    os.makedirs(out_dir, exist_ok=True)
    out_path = os.path.join(out_dir, "strings.xml")
    content = (
        '<?xml version="1.0" encoding="utf-8"?>\n'
        '<resources>\n'
        f'    <string name="app_name">{xml_escape(app_name)}</string>\n'
        '</resources>\n'
    )
    with open(out_path, "w", encoding="utf-8") as f:
        f.write(content)

def ios_escape(s):
    return s.replace("\\", "\\\\").replace('"', '\\"')

def write_ios_strings(locale, app_name, camera, tracking):
    qualifier = ios_qualifier(locale)
    out_dir = os.path.join(IOS_BASE, f"{qualifier}.lproj")
    os.makedirs(out_dir, exist_ok=True)
    out_path = os.path.join(out_dir, "InfoPlist.strings")
    lines = [
        f'"CFBundleDisplayName" = "{ios_escape(app_name)}";',
        f'"NSCameraUsageDescription" = "{ios_escape(camera)}";',
        f'"NSUserTrackingUsageDescription" = "{ios_escape(tracking)}";',
    ]
    with open(out_path, "w", encoding="utf-8") as f:
        f.write("\n".join(lines) + "\n")

def main():
    arb_files = sorted(
        f for f in os.listdir(ARB_DIR)
        if f.startswith("app_") and f.endswith(".arb")
    )
    written = 0
    for arb_file in arb_files:
        locale = arb_file[len("app_"):-len(".arb")]
        if locale == "en":
            continue
        data = load_arb(os.path.join(ARB_DIR, arb_file))
        app_name = data.get("appName", "Peshat")
        camera = data.get("cameraUsageDescription", "")
        tracking = data.get("trackingUsageDescription", "")
        if not camera or not tracking:
            print(f"WARN: {arb_file} missing usage strings", file=sys.stderr)
            continue
        write_android_strings(locale, app_name)
        write_ios_strings(locale, app_name, camera, tracking)
        written += 1
    print(f"wrote {written} Android strings.xml files")
    print(f"wrote {written} iOS InfoPlist.strings files")

if __name__ == "__main__":
    main()
