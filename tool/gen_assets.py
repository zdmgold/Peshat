#!/usr/bin/env python3
"""Generate all asset derivatives from assets/icon/icon.{png,svg}."""
import os
import shutil
import cairosvg
from PIL import Image

ICON_PNG = "assets/icon/icon.png"
ICON_SVG = "assets/icon/icon.svg"
CREAM = (237, 234, 226)

def banner(msg):
    print(f"[gen] {msg}")

def ensure(path):
    os.makedirs(os.path.dirname(path) or ".", exist_ok=True)

def svg_to_png(size, out):
    ensure(out)
    cairosvg.svg2png(url=ICON_SVG, write_to=out,
                     output_width=size, output_height=size)
    banner(f"{out} ({size}x{size})")

def png_resize(src, size, out):
    ensure(out)
    img = Image.open(src).convert("RGB")
    img.resize((size, size), Image.LANCZOS).save(out, "PNG", optimize=True)
    banner(f"{out} ({size}x{size})")

# --- 1. splash logo ---
ensure("assets/splash/logo.png")
shutil.copy(ICON_PNG, "assets/splash/logo.png")
banner("assets/splash/logo.png (copy of 1024)")

# --- 2. website assets ---
ensure("website/assets/logo.svg")
shutil.copy(ICON_SVG, "website/assets/logo.svg")
banner("website/assets/logo.svg")
shutil.copy(ICON_SVG, "website/assets/favicon.svg")
banner("website/assets/favicon.svg")

svg_to_png(180, "website/assets/apple-touch-icon.png")
svg_to_png(192, "website/assets/pwa-192.png")
svg_to_png(512, "website/assets/pwa-512.png")

# OG image 1200x630
og_path = "website/assets/og-image.png"
og = Image.new("RGB", (1200, 630), CREAM)
icon = Image.open(ICON_PNG).convert("RGBA")
ic_w = 480
icon = icon.resize((ic_w, ic_w), Image.LANCZOS)
og.paste(icon, ((1200 - ic_w) // 2, (630 - ic_w) // 2), icon)
og.save(og_path, "PNG", optimize=True)
banner(f"{og_path} (1200x630)")

# --- 3. store submission assets ---
ensure("store_submission/icon_play_store.png")
png_resize(ICON_PNG, 512, "store_submission/icon_play_store.png")

fg_path = "store_submission/feature_graphic.png"
fg = Image.new("RGB", (1024, 500), CREAM)
fg_icon = Image.open(ICON_PNG).convert("RGBA").resize((400, 400), Image.LANCZOS)
fg.paste(fg_icon, ((1024 - 400) // 2, (500 - 400) // 2), fg_icon)
fg.save(fg_path, "PNG", optimize=True)
banner(f"{fg_path} (1024x500)")

print("\nAll asset derivatives generated successfully.")
