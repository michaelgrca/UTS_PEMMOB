"""Builds the bundled font files and decorative image assets.

Fonts are instanced from the upstream variable fonts (SIL Open Font License,
see assets/fonts/OFL-*.txt) and subset to the glyphs the app actually uses.
Run from the project root:

    python tool/build_assets.py
"""

from __future__ import annotations

import math
import os
from pathlib import Path

from fontTools.subset import Options, Subsetter
from fontTools.ttLib import TTFont
from fontTools.varLib.instancer import instantiateVariableFont
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parent.parent
FONT_DIR = ROOT / "assets" / "fonts"
IMAGE_DIR = ROOT / "assets" / "images"
SOURCE_DIR = Path(os.environ.get("TEMP", "/tmp")) / "tunas_font_sources"

# Latin, punctuation and the handful of symbols used in the UI copy.
UNICODES = (
    list(range(0x0020, 0x007F))
    + list(range(0x00A0, 0x0100))
    + list(range(0x2010, 0x2028))
    + list(range(0x2030, 0x205F))
    + [0x20AC, 0x2122]
)

FRAUNCES_AXES = {"opsz": 64, "SOFT": 0, "WONK": 0}
JAKARTA_AXES: dict[str, float] = {}


def build_font(
    source: str,
    family: str,
    weight: int,
    axes: dict[str, float],
    style: str = "",
) -> None:
    font = TTFont(SOURCE_DIR / source)
    if axes:
        font = instantiateVariableFont(font, axes, inplace=False)
    font["OS/2"].usWeightClass = weight
    font["OS/2"].usWidthClass = 5

    options = Options()
    options.name_IDs = ["*"]
    options.name_languages = ["*"]
    options.layout_features = ["*"]
    options.notdef_outline = True
    options.recalc_bounds = True
    options.drop_tables += ["DSIG"]
    subsetter = Subsetter(options=options)
    subsetter.populate(unicodes=UNICODES)
    subsetter.subset(font)

    suffix = f"-{style.capitalize()}" if style else ""
    target = FONT_DIR / f"{family}-{weight}{suffix}.ttf"
    font.save(target)
    print(f"font  {target.name:<28} {target.stat().st_size / 1024:6.1f} KB")


def contour_texture() -> None:
    """A quiet topographic line texture, tinted at paint time in Flutter."""
    width = height = 1100
    image = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    draw = ImageDraw.Draw(image)

    ink = (28, 74, 56, 255)
    for band in range(26):
        base = band * 46.0
        points = []
        for x in range(-40, width + 41, 5):
            warp = (
                math.sin(x / 190.0 + band * 0.55) * 34
                + math.sin(x / 83.0 - band * 0.2) * 9
                + math.sin(x / 410.0 + 1.4) * 58
            )
            points.append((x, base + warp))
        draw.line(points, fill=ink, width=2)

    # A second, sparser set crossing the first keeps it from looking like a
    # repeating wallpaper.
    for band in range(12):
        base = band * 98.0 + 24
        points = []
        for y in range(-40, height + 41, 5):
            warp = (
                math.sin(y / 230.0 - band * 0.4) * 46
                + math.sin(y / 97.0 + band * 0.8) * 7
            )
            points.append((base + warp, y))
        draw.line(points, fill=(28, 74, 56, 160), width=1)

    mask = Image.new("L", (width, height), 0)
    mask_draw = ImageDraw.Draw(mask)
    mask_draw.ellipse((90, 90, width - 90, height - 90), fill=255)
    mask = mask.filter(__import__("PIL.ImageFilter", fromlist=["GaussianBlur"]).GaussianBlur(120))
    image.putalpha(mask)

    target = IMAGE_DIR / "contour.png"
    image.save(target, optimize=True)
    print(f"image {target.name:<28} {target.stat().st_size / 1024:6.1f} KB")


def main() -> None:
    FONT_DIR.mkdir(parents=True, exist_ok=True)
    IMAGE_DIR.mkdir(parents=True, exist_ok=True)
    for weight in (400, 600, 700):
        build_font("Fraunces.ttf", "Fraunces", weight, {**FRAUNCES_AXES, "wght": weight})
    build_font(
        "Fraunces-Italic.ttf",
        "Fraunces",
        600,
        {**FRAUNCES_AXES, "wght": 600},
        style="italic",
    )
    for weight in (400, 500, 600, 700):
        build_font("PlusJakartaSans.ttf", "PlusJakartaSans", weight, {"wght": weight})
    contour_texture()


if __name__ == "__main__":
    main()
