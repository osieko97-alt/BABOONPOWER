# convert_docs.ps1
# Scans the workspace for PDFs, Word and PowerPoint files and generates HTML pages
# Usage: powershell -ExecutionPolicy Bypass -File .\convert_docs.ps1

$src = "c:\xampp\htdocs\liblary"
$out = Join-Path $src "generated"
$assets = Join-Path $out "assets"

if (-not (Test-Path $out)) { New-Item -ItemType Directory -Path $out | Out-Null }
if (-not (Test-Path $assets)) { New-Item -ItemType Directory -Path $assets | Out-Null }

# file patterns to process
$patterns = @('*.pdf','*.doc','*.docx','*.ppt','*.pptx')

# helper: slugify a filename for HTML output
function Slugify($s) {
    $slug = [System.Text.RegularExpressions.Regex]::Replace($s, '[^\w\- ]', '')
    $slug = $slug -replace '\s+', ' '
    $slug = $slug.Trim() -replace ' ', '-'
    return $slug.ToLower()
}

# find files
$files = Get-ChildItem -Path $src -Recurse -File | Where-Object { $patterns -contains ("*" + $_.Extension.TrimStart('.')) } -ErrorAction SilentlyContinue
if (-not $files) { $files = @() }

$indexItems = @()

foreach ($f in $files) {
    Write-Output "Processing: $($f.FullName)"
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
    $title = $baseName -replace '[-_]+', ' '
    $slug = Slugify($baseName)
    if ([string]::IsNullOrWhiteSpace($slug)) { $slug = [System.Guid]::NewGuid().ToString() }
    $htmlName = "$slug.html"
    $outHtml = Join-Path $out $htmlName

    # copy original into assets
    $destAsset = Join-Path $assets $f.Name
    Copy-Item -Path $f.FullName -Destination $destAsset -Force

    $relAsset = "assets/$($f.Name)"

    # basic content generation fallback: embed PDFs, otherwise provide link and note
    $bodyContent = ""
    switch ($f.Extension.ToLower()) {
        '.pdf' { $bodyContent = "<iframe src=\"$relAsset\" style=\"width:100%;height:900px;border:0\"></iframe>" }
        '.pptx' { $bodyContent = "<p>Preview of PowerPoint not available in this offline page. <a href=\"$relAsset\">Download/open the PPTX</a>.</p>" }
        '.ppt' { $bodyContent = "<p>Preview of PowerPoint not available in this offline page. <a href=\"$relAsset\">Download/open the PPT</a>.</p>" }
        '.docx' { $bodyContent = "<p>Word document. <a href=\"$relAsset\">Download/open the DOCX</a>.</p>" }
        '.doc' { $bodyContent = "<p>Word document. <a href=\"$relAsset\">Download/open the DOC</a>.</p>" }
        default { $bodyContent = "<p><a href=\"$relAsset\">Download file</a></p>" }
    }

    $html = @"
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>$title</title>
  <link rel="stylesheet" href="../portal_styles.css" />
  <style>
    body { font-family: Arial,Helvetica,sans-serif; margin: 24px; max-width: 1000px; }
    header h1 { margin: 0 0 12px 0; font-size: 26px }
    .meta { color: #666; margin-bottom: 12px }
    iframe { box-shadow: 0 0 6px rgba(0,0,0,0.08); }
  </style>
</head>
<body>
  <header>
    <h1>$title</h1>
    <div class="meta">Original file: <a href="$relAsset">$($f.Name)</a> &middot; Size: $([Math]::Round($f.Length/1KB,2)) KB</div>
  </header>
  <main>
    $bodyContent
  </main>
  <footer style="margin-top:32px;color:#777;font-size:14px">Generated from a local document. File path: $($f.FullName)</footer>
</body>
</html>
"@

    # write HTML file
    $html | Out-File -FilePath $outHtml -Encoding utf8

    # add to index list
    $indexItems += @{ title = $title; html = $htmlName; filename = $f.Name }
}

# create index.html
$indexHtml = Join-Path $out 'index.html'
$itemsHtml = ""
foreach ($it in $indexItems) {
    $itemsHtml += "<li><a href=\"$($it.html)\">$($it.title)</a> — <small>$($it.filename)</small></li>`n"
}
$indexContent = """
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Library - Generated Pages</title>
  <link rel="stylesheet" href="../portal_styles.css" />
  <style>body{font-family:Arial,Helvetica,sans-serif;margin:20px} h1{font-size:28px} ul{line-height:1.6}</style>
</head>
<body>
  <h1>Generated Pages</h1>
  <p>Number of documents processed: $($indexItems.Count)</p>
  <ul>
  $itemsHtml
  </ul>
</body>
</html>
"""
$indexContent | Out-File -FilePath $indexHtml -Encoding utf8

Write-Output "Done. Generated $($indexItems.Count) pages in: $out"
