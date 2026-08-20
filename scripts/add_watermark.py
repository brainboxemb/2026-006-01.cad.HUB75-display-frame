#!/usr/bin/env python3
"""
Add a subtle watermark to a PNG image.

Usage:
    python add_watermark.py INPUT.png OUTPUT.png "© 2026 brainboxemb"

Environment variables:
    WATERMARK_POINT_SIZE   Font size in pixels (default: 30)
    WATERMARK_MARGIN_X     Right margin in pixels (default: 28)
    WATERMARK_MARGIN_Y     Bottom margin in pixels (default: 22)
    WATERMARK_PADDING_X    Horizontal text padding (default: 12)
    WATERMARK_PADDING_Y    Vertical text padding (default: 7)
    WATERMARK_FONT         Optional path to a .ttf/.otf font
"""

from __future__ import annotations

import os
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


DEFAULT_FONT_CANDIDATES = (
    "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
    "/usr/share/fonts/truetype/liberation2/LiberationSans-Regular.ttf",
)


def env_int(name: str, default: int) -> int:
    value = os.environ.get(name)
    if value is None or value == "":
        return default
    try:
        return int(value)
    except ValueError as exc:
        raise SystemExit(f"{name} must be an integer, got: {value!r}") from exc


def load_font(point_size: int) -> ImageFont.ImageFont:
    configured_font = os.environ.get("WATERMARK_FONT", "").strip()

    candidates = []
    if configured_font:
        candidates.append(configured_font)
    candidates.extend(DEFAULT_FONT_CANDIDATES)

    for candidate in candidates:
        path = Path(candidate)
        if path.is_file():
            return ImageFont.truetype(str(path), point_size)

    # Last-resort fallback. This is less attractive, but keeps rendering robust.
    return ImageFont.load_default()


def add_watermark(input_path: Path, output_path: Path, text: str) -> None:
    point_size = env_int("WATERMARK_POINT_SIZE", 30)
    margin_x = env_int("WATERMARK_MARGIN_X", 28)
    margin_y = env_int("WATERMARK_MARGIN_Y", 22)
    padding_x = env_int("WATERMARK_PADDING_X", 12)
    padding_y = env_int("WATERMARK_PADDING_Y", 7)

    image = Image.open(input_path).convert("RGBA")
    overlay = Image.new("RGBA", image.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)

    font = load_font(point_size)

    # Anchor-free calculation keeps compatibility across Pillow versions.
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]

    box_width = text_width + (padding_x * 2)
    box_height = text_height + (padding_y * 2)

    left = max(0, image.width - margin_x - box_width)
    top = max(0, image.height - margin_y - box_height)
    right = image.width - margin_x
    bottom = image.height - margin_y

    # Light translucent background with dark text.
    draw.rounded_rectangle(
        (left, top, right, bottom),
        radius=max(4, padding_y),
        fill=(255, 255, 255, 150),
    )

    text_x = left + padding_x - bbox[0]
    text_y = top + padding_y - bbox[1]

    draw.text(
        (text_x, text_y),
        text,
        font=font,
        fill=(30, 30, 30, 190),
    )

    result = Image.alpha_composite(image, overlay)

    output_path.parent.mkdir(parents=True, exist_ok=True)
    result.save(output_path, format="PNG", optimize=True)


def main() -> int:
    if len(sys.argv) != 4:
        print(
            "Usage: add_watermark.py INPUT.png OUTPUT.png WATERMARK_TEXT",
            file=sys.stderr,
        )
        return 2

    input_path = Path(sys.argv[1])
    output_path = Path(sys.argv[2])
    text = sys.argv[3]

    if not input_path.is_file():
        print(f"ERROR: Input image does not exist: {input_path}", file=sys.stderr)
        return 1

    if not text.strip():
        print("Watermark text is empty; copying image unchanged.")
        output_path.write_bytes(input_path.read_bytes())
        return 0

    add_watermark(input_path, output_path, text)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
