import os
from pathlib import Path

src = Path('c:\\xampp\\htdocs\\liblary')
out = Path('c:\\xampp\\htdocs\\liblary\\generated')
out.mkdir(parents=True, exist_ok=True)
(out / 'pages').mkdir(exist_ok=True)
(out / 'assets').mkdir(exist_ok=True)

supported = ['.pdf', '.docx', '.pptx', '.doc']
count = 0
files = []

for root, dirs, filenames in os.walk(src):
    if 'generated' in root or 'bulk_convert' in root or '.venv' in root:
        continue
    for f in filenames:
        if Path(f).suffix.lower() in supported:
            count += 1
            files.append(f)
            if count <= 30:
                print(f"[{count}] {f}")

print(f"\nTotal files found: {count}")
print(f"Sample files: {files[:5]}")

# Write basic index
index_html = f"<html><body><h1>Found {count} documents</h1></body></html>"
(out / 'index.html').write_text(index_html)
print(f"Index written to {out / 'index.html'}")
