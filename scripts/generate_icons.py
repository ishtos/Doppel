"""Generate app icon and splash assets for Doppel."""
from PIL import Image, ImageDraw, ImageFont
import math
import os

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_DIR = os.path.dirname(SCRIPT_DIR)

PRIMARY = (26, 35, 126)       # #1A237E - deep indigo
PRIMARY_LIGHT = (48, 63, 159) # #303F9F
SECONDARY = (255, 143, 0)     # #FF8F00 - amber
WHITE = (255, 255, 255)

def draw_rounded_rect(draw, xy, radius, fill):
    x0, y0, x1, y1 = xy
    draw.rectangle([x0 + radius, y0, x1 - radius, y1], fill=fill)
    draw.rectangle([x0, y0 + radius, x1, y1 - radius], fill=fill)
    draw.pieslice([x0, y0, x0 + 2 * radius, y0 + 2 * radius], 180, 270, fill=fill)
    draw.pieslice([x1 - 2 * radius, y0, x1, y0 + 2 * radius], 270, 360, fill=fill)
    draw.pieslice([x0, y1 - 2 * radius, x0 + 2 * radius, y1], 90, 180, fill=fill)
    draw.pieslice([x1 - 2 * radius, y1 - 2 * radius, x1, y1], 0, 90, fill=fill)


def create_gradient(size, color_top, color_bottom):
    img = Image.new('RGBA', (size, size))
    for y in range(size):
        ratio = y / size
        r = int(color_top[0] + (color_bottom[0] - color_top[0]) * ratio)
        g = int(color_top[1] + (color_bottom[1] - color_top[1]) * ratio)
        b = int(color_top[2] + (color_bottom[2] - color_top[2]) * ratio)
        for x in range(size):
            img.putpixel((x, y), (r, g, b, 255))
    return img


def draw_sound_waves(draw, cx, cy, base_radius, num_arcs, color, width):
    for i in range(num_arcs):
        r = base_radius + i * (width * 2.5)
        alpha = max(60, 220 - i * 50)
        arc_color = (*color, alpha)
        bbox = [cx - r, cy - r, cx + r, cy + r]
        draw.arc(bbox, -40, 40, fill=arc_color, width=width)


def draw_d_letter(draw, cx, cy, size, color):
    stroke = int(size * 0.13)
    half_h = int(size * 0.38)
    left_x = cx - int(size * 0.2)
    draw.line(
        [(left_x, cy - half_h), (left_x, cy + half_h)],
        fill=color, width=stroke,
    )
    arc_w = int(size * 0.38)
    bbox = [left_x - stroke // 2, cy - half_h, left_x + arc_w * 2, cy + half_h]
    draw.arc(bbox, -90, 90, fill=color, width=stroke)


def generate_app_icon(size=1024):
    img = create_gradient(size, PRIMARY_LIGHT, PRIMARY)
    draw = ImageDraw.Draw(img, 'RGBA')

    letter_size = int(size * 0.55)
    cx = int(size * 0.42)
    cy = int(size * 0.5)
    draw_d_letter(draw, cx, cy, letter_size, WHITE)

    wave_cx = cx + int(letter_size * 0.22)
    wave_cy = cy
    wave_base = int(size * 0.22)
    draw_sound_waves(draw, wave_cx, wave_cy, wave_base, 3, SECONDARY, int(size * 0.028))

    return img.convert('RGB')


def generate_adaptive_foreground(size=1024):
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img, 'RGBA')

    padding = int(size * 0.2)
    inner = size - 2 * padding
    letter_size = int(inner * 0.55)
    cx = int(size * 0.42)
    cy = int(size * 0.5)
    draw_d_letter(draw, cx, cy, letter_size, WHITE)

    wave_cx = cx + int(letter_size * 0.22)
    wave_cy = cy
    wave_base = int(inner * 0.22)
    draw_sound_waves(draw, wave_cx, wave_cy, wave_base, 3, SECONDARY, int(inner * 0.028))

    return img


def generate_splash_logo(size=512):
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img, 'RGBA')

    letter_size = int(size * 0.6)
    cx = int(size * 0.42)
    cy = int(size * 0.5)
    draw_d_letter(draw, cx, cy, letter_size, PRIMARY)

    wave_cx = cx + int(letter_size * 0.22)
    wave_cy = cy
    wave_base = int(size * 0.22)
    draw_sound_waves(draw, wave_cx, wave_cy, wave_base, 3, SECONDARY, int(size * 0.025))

    return img


if __name__ == '__main__':
    icon_dir = os.path.join(PROJECT_DIR, 'assets', 'icon')
    splash_dir = os.path.join(PROJECT_DIR, 'assets', 'splash')
    os.makedirs(icon_dir, exist_ok=True)
    os.makedirs(splash_dir, exist_ok=True)

    print('Generating app icon (1024x1024)...')
    icon = generate_app_icon(1024)
    icon.save(os.path.join(icon_dir, 'app_icon.png'))

    print('Generating adaptive icon foreground (1024x1024)...')
    fg = generate_adaptive_foreground(1024)
    fg.save(os.path.join(icon_dir, 'app_icon_foreground.png'))

    print('Generating splash logo (512x512)...')
    splash = generate_splash_logo(512)
    splash.save(os.path.join(splash_dir, 'splash_logo.png'))

    print('Generating dark splash logo (512x512)...')
    dark_splash = Image.new('RGBA', (512, 512), (0, 0, 0, 0))
    dark_draw = ImageDraw.Draw(dark_splash, 'RGBA')
    draw_d_letter(dark_draw, int(512 * 0.42), int(512 * 0.5), int(512 * 0.6), WHITE)
    draw_sound_waves(dark_draw, int(512 * 0.42) + int(int(512 * 0.6) * 0.22), int(512 * 0.5), int(512 * 0.22), 3, SECONDARY, int(512 * 0.025))
    dark_splash.save(os.path.join(splash_dir, 'splash_logo_dark.png'))

    print('Done! Assets generated:')
    for d in [icon_dir, splash_dir]:
        for f in os.listdir(d):
            print(f'  {os.path.relpath(os.path.join(d, f), PROJECT_DIR)}')
