#!/usr/bin/env python3
"""Compose the README banner."""

from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

HERE = Path(__file__).resolve().parent
OUT = HERE / "banner.png"
LOGO = HERE / "kp-logo.png"

W, H = 2400, 680
PURPLE = (68, 44, 139)
PURPLE_SOFT = (102, 90, 167)
GOLD = (220, 174, 39)
INK = (26, 20, 40)
WHITE = (255, 255, 255)

HELV = "/System/Library/Fonts/HelveticaNeue.ttc"
ARIAL = "/System/Library/Fonts/Supplemental/Arial.ttf"
ARIAL_BOLD = "/System/Library/Fonts/Supplemental/Arial Bold.ttf"


def font(path: str, size: int, index: int = 0) -> ImageFont.FreeTypeFont:
    try:
        return ImageFont.truetype(path, size, index=index)
    except OSError:
        return ImageFont.truetype(ARIAL, size)


def tracked(draw: ImageDraw.ImageDraw, text: str, xy, fnt, fill, tracking: float = 3.2) -> None:
    x, y = xy
    for ch in text:
        draw.text((x, y), ch, font=fnt, fill=fill)
        x += fnt.getlength(ch) + tracking


def crop_logo(path: Path) -> Image.Image:
    im = Image.open(path).convert("RGBA")
    bbox = im.getbbox()
    if bbox:
        im = im.crop(bbox)
    return im


def build() -> Path:
    img = Image.new("RGB", (W, H), WHITE)
    d = ImageDraw.Draw(img)
    d.rectangle([0, 0, 10, H], fill=GOLD)

    kicker = font(HELV, 22, index=10)
    title = font(HELV, 52, index=7)
    subtitle = font(HELV, 36, index=7)
    prepared = font(ARIAL_BOLD, 16)
    meta = font(HELV, 20, index=0)

    x = 96
    tracked(d, "SAN FRANCISCO STATE UNIVERSITY", (x, 64), kicker, GOLD, tracking=6)

    d.text((x, 118), "Understanding Marketplace Performance", font=title, fill=PURPLE)
    d.text((x, 182), "Across Geographies", font=title, fill=PURPLE)
    d.text((x, 258), "Socioeconomic Trends and Future Considerations", font=subtitle, fill=PURPLE_SOFT)
    d.rectangle([x, 324, x + 168, 328], fill=GOLD)

    d.text((x, 368), "PREPARED FOR", font=prepared, fill=GOLD)
    logo = crop_logo(LOGO)
    logo_w = 480
    logo_h = int(logo_w * logo.height / logo.width)
    logo = logo.resize((logo_w, logo_h), Image.Resampling.LANCZOS)
    logo_y = 400
    img.paste(logo, (x, logo_y), logo)

    d.text(
        (x, logo_y + logo_h + 28),
        "Lam Family College of Business   ·   MS Business Analytics   ·   BUS 895",
        font=meta,
        fill=INK,
    )

    img.save(OUT, "PNG")
    return OUT


if __name__ == "__main__":
    print(f"Wrote {build()}")
