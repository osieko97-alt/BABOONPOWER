#!/usr/bin/env python3
"""Build index.html from all generated pages"""
import os
from pathlib import Path

pages_dir = Path('c:\\xampp\\htdocs\\liblary\\generated\\pages')
out_dir = Path('c:\\xampp\\htdocs\\liblary\\generated')

# Collect all pages
items = []
for html_file in sorted(pages_dir.glob('*.html')):
    title = html_file.stem
    # Find corresponding asset
    asset_name = title.rsplit('_', 1)[0] if '_' in title else title
    page_rel = f"pages/{html_file.name}"
    items.append({'title': title, 'page': page_rel})

# Build index
css = 'body{font-family:Segoe UI,Arial;margin:30px;background:#f9f9f9}h1{color:#333}p{color:#666}.container{max-width:1200px;margin:0 auto}.search{margin:20px 0}.item{background:white;padding:15px;margin:10px 0;border-radius:6px;border-left:4px solid #0066cc}.item a{color:#0066cc;text-decoration:none;font-weight:600}.item a:hover{text-decoration:underline}.meta{font-size:0.9rem;color:#999;margin-top:8px}'

html = f'''<!DOCTYPE html>
<html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width">
<title>📚 Document Library - {len(items)} Documents</title>
<style>{css}</style></head><body>
<div class="container">
<h1>📚 Document Library</h1>
<p><strong>{len(items)} documents</strong> converted to web pages</p>
<div class="search">
<input type="text" id="search" placeholder="Search documents..." style="width:100%;padding:10px;font-size:1rem;border:1px solid #ddd;border-radius:4px">
</div>
<div id="results">
'''

for i, item in enumerate(items, 1):
    html += f'<div class="item"><a href="{item["page"]}">{item["title"]}</a><div class="meta">[{i}/{len(items)}]</div></div>\n'

html += '''</div>
<script>
const search = document.getElementById('search');
const items = document.querySelectorAll('.item');
search.addEventListener('input', (e) => {
    const query = e.target.value.toLowerCase();
    items.forEach(item => {
        item.style.display = item.textContent.toLowerCase().includes(query) ? 'block' : 'none';
    });
});
</script>
</body></html>'''

(out_dir / 'index.html').write_text(html, encoding='utf-8')
print(f"✓ Index created: {len(items)} documents linked")
print(f"  Location: {out_dir / 'index.html'}")
