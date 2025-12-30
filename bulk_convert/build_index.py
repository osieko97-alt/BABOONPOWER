import os
import json
from pathlib import Path

pages_dir = Path('c:\\xampp\\htdocs\\liblary\\generated\\pages')
assets_dir = Path('c:\\xampp\\htdocs\\liblary\\generated\\assets')

docs = []
type_counts = {'PDF': 0, 'DOCX': 0, 'PPTX': 0, 'DOC': 0}

# Collect all HTML pages
for html_file in sorted(pages_dir.glob('*.html')):
    title = html_file.stem.rsplit('_', 1)[0]  # Remove hash suffix
    
    # Find corresponding asset
    asset_path = None
    for asset in assets_dir.glob('*'):
        if title.lower() in asset.name.lower() or asset.name.replace('_', ' ').lower() in title.lower():
            asset_path = asset
            break
    
    if not asset_path:
        # Try to find any asset with similar name
        asset_path = list(assets_dir.glob(f'{title[:30]}*'))
        asset_path = asset_path[0] if asset_path else None
    
    file_type = Path(asset_path).suffix.upper()[1:] if asset_path else 'HTML'
    type_counts[file_type] = type_counts.get(file_type, 0) + 1
    
    page_rel = f'pages/{html_file.name}'
    asset_rel = f'assets/{asset_path.name}' if asset_path else ''
    
    docs.append({
        'title': title,
        'page': page_rel,
        'asset': asset_rel,
        'type': file_type
    })

# Build HTML index
html_content = '''<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>📚 Document Library</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background: #f5f5f5;
        }
        header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            text-align: center;
        }
        header h1 {
            margin: 0;
            font-size: 2.5rem;
        }
        header p {
            margin: 10px 0 0 0;
            font-size: 1.1rem;
            opacity: 0.9;
        }
        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .stat-card .number {
            font-size: 2rem;
            font-weight: bold;
            color: #667eea;
        }
        .stat-card .label {
            color: #666;
            font-size: 0.9rem;
            margin-top: 5px;
        }
        .search-box {
            margin-bottom: 30px;
        }
        .search-box input {
            width: 100%;
            max-width: 500px;
            padding: 12px;
            font-size: 1rem;
            border: 2px solid #ddd;
            border-radius: 4px;
            display: block;
        }
        .documents {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
        }
        .doc-card {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .doc-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        .doc-card-title {
            padding: 15px;
            background: #f9f9f9;
            border-bottom: 2px solid #667eea;
            font-weight: 600;
            color: #333;
            word-break: break-word;
            min-height: 50px;
            display: flex;
            align-items: center;
        }
        .doc-card-body {
            padding: 15px;
        }
        .doc-type {
            display: inline-block;
            background: #667eea;
            color: white;
            padding: 4px 8px;
            border-radius: 3px;
            font-size: 0.8rem;
            font-weight: 600;
            margin-right: 10px;
        }
        .doc-links {
            margin-top: 10px;
            display: flex;
            gap: 10px;
        }
        .doc-links a {
            flex: 1;
            padding: 8px;
            text-align: center;
            border-radius: 4px;
            text-decoration: none;
            font-size: 0.9rem;
            transition: background 0.2s;
        }
        .doc-links a.view {
            background: #667eea;
            color: white;
        }
        .doc-links a.view:hover {
            background: #5568d3;
        }
        .doc-links a.download {
            background: #f0f0f0;
            color: #333;
        }
        .doc-links a.download:hover {
            background: #e0e0e0;
        }
        .hidden {
            display: none;
        }
    </style>
</head>
<body>
    <header>
        <h1>📚 Document Library</h1>
        <p>Your converted documents are ready to browse</p>
    </header>

    <div class="stats">
        <div class="stat-card">
            <div class="number">''' + str(len(docs)) + '''</div>
            <div class="label">Total Documents</div>
        </div>
''' + '\n'.join(f'        <div class="stat-card"><div class="number">{count}</div><div class="label">{ftype}s</div></div>' for ftype, count in type_counts.items() if count > 0) + '''
    </div>

    <div class="search-box">
        <input type="text" id="search" placeholder="🔍 Search documents..." onkeyup="filterDocuments()">
    </div>

    <div class="documents" id="documents">
'''

for doc in docs:
    html_content += f'''        <div class="doc-card" data-title="{doc['title'].lower()}">
            <div class="doc-card-title">{doc['title']}</div>
            <div class="doc-card-body">
                <span class="doc-type">{doc['type']}</span>
                <div class="doc-links">
                    <a class="view" href="{doc['page']}">📖 View</a>
                    <a class="download" href="{doc['asset']}" download>📥 Original</a>
                </div>
            </div>
        </div>
'''

html_content += '''    </div>

    <script>
        function filterDocuments() {
            const search = document.getElementById('search').value.toLowerCase();
            const cards = document.querySelectorAll('.doc-card');
            cards.forEach(card => {
                const title = card.getAttribute('data-title');
                card.classList.toggle('hidden', !title.includes(search));
            });
        }
    </script>
</body>
</html>
'''

# Write index
index_path = Path('c:\\xampp\\htdocs\\liblary\\generated\\index.html')
index_path.write_text(html_content, encoding='utf-8')

print(f"✓ Generated index.html with {len(docs)} documents")
print(f"  PDF: {type_counts.get('PDF', 0)}, DOCX: {type_counts.get('DOCX', 0)}, PPTX: {type_counts.get('PPTX', 0)}")
