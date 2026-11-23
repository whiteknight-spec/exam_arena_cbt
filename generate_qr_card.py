import qrcode
from PIL import Image, ImageDraw, ImageFont
import os

# Configuration
IP = "10.54.12.134"
PORT = "8089"
APK_URL = f"http://{IP}:{PORT}/ExamArenaCBT.apk"
WEB_URL = f"http://{IP}:{PORT}/exam_arena_ui_preview.html"

BRAIN_DIR = "/Users/air/.gemini/antigravity/brain/afdd817e-7c2d-4bd2-864b-918238a211d2"
DESKTOP_DIR = "/Users/air/Desktop"
WORKSPACE_DIR = "/Users/air/.gemini/antigravity/scratch/exam_arena_cbt"

# Generate QR codes
def make_qr(data, box_size=10, border=3):
    qr = qrcode.QRCode(
        version=None,
        error_correction=qrcode.constants.ERROR_CORRECT_M,
        box_size=box_size,
        border=border,
    )
    qr.add_data(data)
    qr.make(fit=True)
    return qr.make_image(fill_color="#0F172A", back_color="#FFFFFF").convert("RGBA")

apk_qr = make_qr(APK_URL, box_size=12, border=2)
web_qr = make_qr(WEB_URL, box_size=12, border=2)

apk_qr.save(os.path.join(BRAIN_DIR, "exam_arena_apk_qr.png"))
apk_qr.save(os.path.join(WORKSPACE_DIR, "exam_arena_apk_qr.png"))
apk_qr.save(os.path.join(DESKTOP_DIR, "ExamArena_Android_APK_QR.png"))

web_qr.save(os.path.join(BRAIN_DIR, "exam_arena_ios_web_qr.png"))
web_qr.save(os.path.join(WORKSPACE_DIR, "exam_arena_ios_web_qr.png"))
web_qr.save(os.path.join(DESKTOP_DIR, "ExamArena_iPhone_Web_QR.png"))

# Create a Composite High-Resolution Presentation Card (1200 x 780)
WIDTH = 1200
HEIGHT = 780
card = Image.new("RGBA", (WIDTH, HEIGHT), "#0B0F19")
draw = ImageDraw.Draw(card)

# Load fonts (fallback to default if ttf not found)
try:
    font_title = ImageFont.truetype("/System/Library/Fonts/SFPro-Bold.ttf", 34)
    font_sub = ImageFont.truetype("/System/Library/Fonts/SFPro-Regular.ttf", 17)
    font_section = ImageFont.truetype("/System/Library/Fonts/SFPro-Bold.ttf", 22)
    font_detail = ImageFont.truetype("/System/Library/Fonts/SFPro-Medium.ttf", 15)
    font_code = ImageFont.truetype("/System/Library/Fonts/SFMono-Bold.ttf", 15)
    font_foot = ImageFont.truetype("/System/Library/Fonts/SFPro-Regular.ttf", 14)
except Exception:
    try:
        font_title = ImageFont.truetype("/System/Library/Fonts/HelveticaNeue.ttc", 34)
        font_sub = ImageFont.truetype("/System/Library/Fonts/HelveticaNeue.ttc", 17)
        font_section = ImageFont.truetype("/System/Library/Fonts/HelveticaNeue.ttc", 22)
        font_detail = ImageFont.truetype("/System/Library/Fonts/HelveticaNeue.ttc", 15)
        font_code = ImageFont.truetype("/System/Library/Fonts/Courier.dfont", 15)
        font_foot = ImageFont.truetype("/System/Library/Fonts/HelveticaNeue.ttc", 14)
    except Exception:
        font_title = font_sub = font_section = font_detail = font_code = font_foot = ImageFont.load_default()

# Header background bar
draw.rectangle([0, 0, WIDTH, 120], fill="#0F172A")
draw.line([0, 120, WIDTH, 120], fill="#1E293B", width=2)

# Header Title
draw.text((60, 30), "🎯 EXAM ARENA CBT — MOBILE INSTALL & PREVIEW", fill="#F8FAFC", font=font_title)
draw.text((60, 75), "Scan with your Smartphone Camera • Mobile-First Responsive Experience", fill="#94A3B8", font=font_sub)

# Status Badge on Header Right
draw.rounded_rectangle([WIDTH - 300, 38, WIDTH - 50, 82], radius=10, fill="#1E293B", outline="#10B981", width=2)
draw.text((WIDTH - 280, 50), "● SERVER ONLINE : 8089", fill="#10B981", font=font_code)

# Left Column: Android Card
left_x1, left_y1, left_x2, left_y2 = 60, 150, 570, 700
draw.rounded_rectangle([left_x1, left_y1, left_x2, left_y2], radius=20, fill="#111827", outline="#3B82F6", width=2)

# Android Card Header
draw.rounded_rectangle([left_x1 + 16, left_y1 + 16, left_x2 - 16, left_y1 + 75], radius=12, fill="#1E3A8A")
draw.text((left_x1 + 30, left_y1 + 25), "🤖 ANDROID USERS — RELEASE APK", fill="#93C5FD", font=font_section)
draw.text((left_x1 + 30, left_y1 + 52), "Direct Install (52 MB) • Concept 2 App Icon", fill="#DBEAFE", font=font_detail)

# Paste Android QR (resize to 260x260)
apk_qr_resized = apk_qr.resize((260, 260), Image.Resampling.LANCZOS)
qr_bg_left = Image.new("RGBA", (280, 280), "#FFFFFF")
qr_bg_left.paste(apk_qr_resized, (10, 10))
card.paste(qr_bg_left, (left_x1 + (510 - 280) // 2, left_y1 + 95))

# Android Instructions
draw.text((left_x1 + 30, left_y1 + 395), "1. Open Camera or Google Lens & scan QR", fill="#E2E8F0", font=font_detail)
draw.text((left_x1 + 30, left_y1 + 420), "2. Tap the link to download ExamArenaCBT.apk", fill="#E2E8F0", font=font_detail)
draw.text((left_x1 + 30, left_y1 + 445), "3. Open file & tap 'Install' (Allow unknown source)", fill="#E2E8F0", font=font_detail)

# Android URL pill
draw.rounded_rectangle([left_x1 + 24, left_y1 + 475, left_x2 - 24, left_y1 + 525], radius=8, fill="#1E293B")
draw.text((left_x1 + 35, left_y1 + 490), APK_URL, fill="#60A5FA", font=font_code)


# Right Column: Apple / iOS Card
right_x1, right_y1, right_x2, right_y2 = 630, 150, 1140, 700
draw.rounded_rectangle([right_x1, right_y1, right_x2, right_y2], radius=20, fill="#111827", outline="#A855F7", width=2)

# iOS Card Header
draw.rounded_rectangle([right_x1 + 16, right_y1 + 16, right_x2 - 16, right_y1 + 75], radius=12, fill="#581C87")
draw.text((right_x1 + 30, right_y1 + 25), "🍎 iPHONE / APPLE USERS — WEB APP", fill="#F0ABFC", font=font_section)
draw.text((right_x1 + 30, right_y1 + 52), "Interactive Safari CBT Simulator • No App Store needed", fill="#F5D0FE", font=font_detail)

# Paste iOS QR (resize to 260x260)
web_qr_resized = web_qr.resize((260, 260), Image.Resampling.LANCZOS)
qr_bg_right = Image.new("RGBA", (280, 280), "#FFFFFF")
qr_bg_right.paste(web_qr_resized, (10, 10))
card.paste(qr_bg_right, (right_x1 + (510 - 280) // 2, right_y1 + 95))

# iOS Instructions
draw.text((right_x1 + 30, right_y1 + 395), "1. Open iPhone Camera app & point at QR code", fill="#E2E8F0", font=font_detail)
draw.text((right_x1 + 30, right_y1 + 420), "2. Tap 'Open in Safari' yellow badge", fill="#E2E8F0", font=font_detail)
draw.text((right_x1 + 30, right_y1 + 445), "3. Tap Share ➔ 'Add to Home Screen' for Full App feel", fill="#E2E8F0", font=font_detail)

# iOS URL pill
draw.rounded_rectangle([right_x1 + 24, right_y1 + 475, right_x2 - 24, right_y1 + 525], radius=8, fill="#1E293B")
draw.text((right_x1 + 35, right_y1 + 490), WEB_URL, fill="#C084FC", font=font_code)

# Footer bar
draw.text((60, 725), "📌 Note: Mobile phone and Mac must be connected to the same Wi-Fi network.", fill="#94A3B8", font=font_foot)
draw.text((WIDTH - 480, 725), "💻 Desktop File: /Users/air/Desktop/ExamArenaCBT.apk", fill="#64748B", font=font_foot)

# Save card
composite_path = os.path.join(BRAIN_DIR, "exam_arena_mobile_access_card.png")
card.save(composite_path)
card.save(os.path.join(WORKSPACE_DIR, "exam_arena_mobile_access_card.png"))
card.save(os.path.join(DESKTOP_DIR, "ExamArena_Mobile_QR_Guide.png"))

print("QR generation completed successfully!")
