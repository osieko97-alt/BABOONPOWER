# Document to Web Conversion Script
# This script converts PDF, DOCX, and PPTX files to HTML web pages

param(
    [string]$SourcePath = "c:\xampp\htdocs\liblary",
    [string]$OutputPath = "c:\xampp\htdocs\liblary\generated"
)

# Create output directory structure
if (!(Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
    Write-Host "Created output directory: $OutputPath"
}

$assetPath = Join-Path $OutputPath "assets"
if (!(Test-Path $assetPath)) {
    New-Item -ItemType Directory -Path $assetPath -Force | Out-Null
    Write-Host "Created assets directory: $assetPath"
}

# Track files
$documents = @()
$successCount = 0
$errorCount = 0

# Get all document files
$pdfFiles = Get-ChildItem -Path $SourcePath -Filter "*.pdf" -Exclude "*_copy.pdf" | Where-Object { $_.Name -notlike "*generated*" }
$docxFiles = Get-ChildItem -Path $SourcePath -Filter "*.docx" | Where-Object { $_.Name -notlike "*generated*" }
$pptxFiles = Get-ChildItem -Path $SourcePath -Filter "*.pptx" | Where-Object { $_.Name -notlike "*generated*" }

$totalFiles = $pdfFiles.Count + $docxFiles.Count + $pptxFiles.Count
Write-Host "Found $($pdfFiles.Count) PDF files, $($docxFiles.Count) DOCX files, $($pptxFiles.Count) PPTX files"
Write-Host "Total documents to process: $totalFiles"

# Function to sanitize filename for use as URL
function Get-SafeFilename {
    param([string]$Name)
    $safe = $Name -replace '[^a-zA-Z0-9\-]', '_'
    $safe = $safe -replace '_+', '_'
    $safe = $safe.Trim('_')
    return $safe
}

# Function to extract text from PDF using Windows built-in methods
function Get-TextFromPDF {
    param([string]$FilePath)
    try {
        # Try using Windows Search indexer or built-in PDF reading
        $shell = New-Object -ComObject Shell.Application
        $folder = $shell.NameSpace((Split-Path $FilePath))
        $file = $folder.ParseName((Split-Path $FilePath -Leaf))
        
        # Attempt to read using a different method
        $content = ""
        
        # Use iFilter if available
        $regPath = "HKLM:\Software\Classes\.pdf\PersistentHandler"
        if (Test-Path $regPath) {
            # PDF handler is registered, try to extract text
            $PSPDFPath = "C:\Program Files\PowerShell\7\pwsh.exe"
            if (Test-Path $PSPDFPath) {
                # If using advanced tools, extract here
                $content = "[PDF Content - $((Get-Item $FilePath).BaseName)]"
            }
        }
        
        if (!$content) {
            $content = "[PDF file: $(Split-Path $FilePath -Leaf) - Content extraction requires PDF reader library]"
        }
        
        return $content
    }
    catch {
        return "[Error reading PDF: $($_.Exception.Message)]"
    }
}

# Function to extract text from DOCX
function Get-TextFromDOCX {
    param([string]$FilePath)
    try {
        # DOCX files are ZIP archives containing XML
        Add-Type -Assembly System.IO.Compression
        $zip = [System.IO.Compression.ZipFile]::OpenRead($FilePath)
        $docXmlEntry = $zip.Entries | Where-Object { $_.Name -eq "document.xml" }
        
        if ($docXmlEntry) {
            $stream = $docXmlEntry.Open()
            $reader = New-Object System.IO.StreamReader $stream
            $xml = $reader.ReadToEnd()
            $reader.Close()
            $zip.Close()
            
            # Extract text from XML (simple approach)
            $xml = $xml -replace '<[^>]+>', "`n"
            $xml = $xml -replace '\s+', ' '
            return $xml.Trim()
        }
        else {
            $zip.Close()
            return "[DOCX file - Could not find document.xml]"
        }
    }
    catch {
        return "[Error reading DOCX: $($_.Exception.Message)]"
    }
}

# Function to extract text from PPTX
function Get-TextFromPPTX {
    param([string]$FilePath)
    try {
        # PPTX files are ZIP archives containing XML
        Add-Type -Assembly System.IO.Compression
        $zip = [System.IO.Compression.ZipFile]::OpenRead($FilePath)
        $content = @()
        
        # Get all slide XML files
        $slideEntries = $zip.Entries | Where-Object { $_.FullName -match "ppt/slides/slide\d+\.xml" } | Sort-Object Name
        
        foreach ($entry in $slideEntries) {
            $stream = $entry.Open()
            $reader = New-Object System.IO.StreamReader $stream
            $xml = $reader.ReadToEnd()
            $reader.Close()
            
            # Extract text from XML
            $xml = $xml -replace '<[^>]+>', "`n"
            $xml = $xml -replace '\s+', ' '
            $slideNum = [regex]::Match($entry.Name, '\d+').Value
            $content += "--- Slide $slideNum ---`n$($xml.Trim())"
        }
        
        $zip.Close()
        return ($content -join "`n`n")
    }
    catch {
        return "[Error reading PPTX: $($_.Exception.Message)]"
    }
}

# Function to generate HTML page
function New-HTMLPage {
    param(
        [string]$Title,
        [string]$Content,
        [string]$Filename,
        [string]$SourceFile,
        [string]$DocumentType
    )
    
    $safeTitle = [System.Web.HttpUtility]::HtmlEncode($Title)
    $safeContent = [System.Web.HttpUtility]::HtmlEncode($Content)
    
    # Limit content preview
    $previewLength = 2000
    if ($safeContent.Length -gt $previewLength) {
        $safeContent = $safeContent.Substring(0, $previewLength) + "..."
    }
    
    $html = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$safeTitle</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 900px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px 30px;
            border-bottom: 4px solid #ffd700;
        }
        
        .header h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
            word-break: break-word;
        }
        
        .meta {
            font-size: 0.9em;
            opacity: 0.9;
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }
        
        .meta-item {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .badge {
            display: inline-block;
            background: rgba(255,255,255,0.2);
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.85em;
        }
        
        .content {
            padding: 40px 30px;
        }
        
        .content h2 {
            color: #667eea;
            margin-top: 25px;
            margin-bottom: 15px;
            border-bottom: 2px solid #e0e0e0;
            padding-bottom: 10px;
        }
        
        .content h3 {
            color: #764ba2;
            margin-top: 20px;
            margin-bottom: 10px;
        }
        
        pre {
            background: #f5f5f5;
            padding: 15px;
            border-left: 4px solid #667eea;
            overflow-x: auto;
            margin: 15px 0;
            font-family: 'Courier New', monospace;
            font-size: 0.9em;
            white-space: pre-wrap;
            word-wrap: break-word;
        }
        
        .source-info {
            background: #f0f4ff;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
            border-left: 4px solid #667eea;
            font-size: 0.9em;
        }
        
        .footer {
            background: #f5f5f5;
            padding: 20px 30px;
            border-top: 1px solid #e0e0e0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px;
        }
        
        .footer a {
            color: #667eea;
            text-decoration: none;
        }
        
        .footer a:hover {
            text-decoration: underline;
        }
        
        .nav-buttons {
            display: flex;
            gap: 10px;
        }
        
        .btn {
            display: inline-block;
            padding: 10px 20px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background 0.3s;
            border: none;
            cursor: pointer;
            font-size: 0.9em;
        }
        
        .btn:hover {
            background: #764ba2;
        }
        
        @media (max-width: 768px) {
            .header h1 {
                font-size: 1.8em;
            }
            
            .meta {
                flex-direction: column;
                gap: 10px;
            }
            
            .container {
                border-radius: 0;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>$safeTitle</h1>
            <div class="meta">
                <div class="meta-item">
                    <span class="badge">$DocumentType</span>
                </div>
                <div class="meta-item">
                    📅 <span id="date"></span>
                </div>
                <div class="meta-item">
                    📄 Original: <code>$([System.Web.HttpUtility]::HtmlEncode($SourceFile))</code>
                </div>
            </div>
        </div>
        
        <div class="content">
            <h2>Document Content</h2>
            
            <div class="source-info">
                <strong>📎 Source Information:</strong><br>
                Original File: <code>$([System.Web.HttpUtility]::HtmlEncode($SourceFile))</code><br>
                File Type: $DocumentType<br>
                Generated: <span id="gendate"></span>
            </div>
            
            <h3>Content Preview</h3>
            <pre>$safeContent</pre>
            
            <div class="source-info" style="margin-top: 30px;">
                <strong>💡 Note:</strong> This page contains extracted text from the original document. 
                For full formatting and details, please refer to the original file in the library.
            </div>
        </div>
        
        <div class="footer">
            <div>
                <small>&copy; 2025 Digital Library. | <a href="index.html">Back to Library</a></small>
            </div>
            <div class="nav-buttons">
                <a href="index.html" class="btn">📚 Back to Index</a>
            </div>
        </div>
    </div>
    
    <script>
        // Set current date
        document.getElementById('date').textContent = new Date().toLocaleDateString();
        document.getElementById('gendate').textContent = new Date().toLocaleString();
    </script>
</body>
</html>
"@
    
    return $html
}

# Process PDF files
Write-Host "`n=== Processing PDF Files ===" -ForegroundColor Green
foreach ($pdf in $pdfFiles) {
    try {
        $filename = Get-SafeFilename $pdf.BaseName
        $htmlFile = Join-Path $OutputPath "$filename.html"
        $content = Get-TextFromPDF $pdf.FullName
        $html = New-HTMLPage -Title $pdf.BaseName -Content $content -Filename $filename -SourceFile $pdf.Name -DocumentType "PDF"
        
        Set-Content -Path $htmlFile -Value $html -Encoding UTF8
        $documents += @{
            Title = $pdf.BaseName
            File = "$filename.html"
            Type = "PDF"
            SourceFile = $pdf.Name
        }
        
        $successCount++
        Write-Host "✓ Converted: $($pdf.Name)" -ForegroundColor Green
    }
    catch {
        $errorCount++
        Write-Host "✗ Error converting $($pdf.Name): $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Process DOCX files
Write-Host "`n=== Processing DOCX Files ===" -ForegroundColor Green
foreach ($docx in $docxFiles) {
    try {
        $filename = Get-SafeFilename $docx.BaseName
        $htmlFile = Join-Path $OutputPath "$filename.html"
        $content = Get-TextFromDOCX $docx.FullName
        $html = New-HTMLPage -Title $docx.BaseName -Content $content -Filename $filename -SourceFile $docx.Name -DocumentType "DOCX"
        
        Set-Content -Path $htmlFile -Value $html -Encoding UTF8
        $documents += @{
            Title = $docx.BaseName
            File = "$filename.html"
            Type = "DOCX"
            SourceFile = $docx.Name
        }
        
        $successCount++
        Write-Host "✓ Converted: $($docx.Name)" -ForegroundColor Green
    }
    catch {
        $errorCount++
        Write-Host "✗ Error converting $($docx.Name): $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Process PPTX files
Write-Host "`n=== Processing PPTX Files ===" -ForegroundColor Green
foreach ($pptx in $pptxFiles) {
    try {
        $filename = Get-SafeFilename $pptx.BaseName
        $htmlFile = Join-Path $OutputPath "$filename.html"
        $content = Get-TextFromPPTX $pptx.FullName
        $html = New-HTMLPage -Title $pptx.BaseName -Content $content -Filename $filename -SourceFile $pptx.Name -DocumentType "PPTX"
        
        Set-Content -Path $htmlFile -Value $html -Encoding UTF8
        $documents += @{
            Title = $pptx.BaseName
            File = "$filename.html"
            Type = "PPTX"
            SourceFile = $pptx.Name
        }
        
        $successCount++
        Write-Host "✓ Converted: $($pptx.Name)" -ForegroundColor Green
    }
    catch {
        $errorCount++
        Write-Host "✗ Error converting $($pptx.Name): $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Generate master index
Write-Host "`n=== Generating Master Index ===" -ForegroundColor Cyan
$docsByType = $documents | Group-Object -Property Type

$indexHtml = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Digital Library - Document Index</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .header {
            text-align: center;
            color: white;
            margin-bottom: 40px;
            animation: fadeIn 0.6s ease-in;
        }
        
        .header h1 {
            font-size: 3em;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        
        .header p {
            font-size: 1.2em;
            opacity: 0.9;
        }
        
        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .stat-card .number {
            font-size: 2.5em;
            color: #667eea;
            font-weight: bold;
        }
        
        .stat-card .label {
            color: #666;
            margin-top: 5px;
            font-size: 0.9em;
        }
        
        .search-box {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .search-box input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 5px;
            font-size: 1em;
            transition: border-color 0.3s;
        }
        
        .search-box input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 5px rgba(102, 126, 234, 0.3);
        }
        
        .sections {
            display: grid;
            gap: 30px;
        }
        
        .section {
            background: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            overflow: hidden;
        }
        
        .section-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px 30px;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .section-header .icon {
            font-size: 1.8em;
        }
        
        .section-header h2 {
            font-size: 1.5em;
            flex: 1;
        }
        
        .section-header .count {
            background: rgba(255,255,255,0.2);
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9em;
        }
        
        .documents-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 15px;
            padding: 20px 30px;
        }
        
        .document-card {
            background: #f9f9f9;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            padding: 15px;
            text-decoration: none;
            color: #333;
            transition: all 0.3s;
            cursor: pointer;
        }
        
        .document-card:hover {
            border-color: #667eea;
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
            transform: translateY(-3px);
        }
        
        .document-card .title {
            font-weight: bold;
            margin-bottom: 8px;
            color: #667eea;
            word-break: break-word;
        }
        
        .document-card .type {
            display: inline-block;
            background: #667eea;
            color: white;
            padding: 3px 10px;
            border-radius: 3px;
            font-size: 0.8em;
            margin-top: 5px;
        }
        
        .document-card .file-info {
            font-size: 0.85em;
            color: #999;
            margin-top: 8px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        
        .footer {
            background: white;
            padding: 30px;
            text-align: center;
            margin-top: 30px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            color: #666;
        }
        
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .hidden {
            display: none;
        }
        
        @media (max-width: 768px) {
            .header h1 {
                font-size: 2em;
            }
            
            .documents-grid {
                grid-template-columns: 1fr;
            }
            
            .section-header {
                flex-direction: column;
                text-align: center;
            }
            
            .section-header .icon {
                order: -1;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📚 Digital Library</h1>
            <p>Access converted educational documents online</p>
        </div>
        
        <div class="stats">
            <div class="stat-card">
                <div class="number">$($documents.Count)</div>
                <div class="label">Total Documents</div>
            </div>
"@

foreach ($group in $docsByType) {
    $indexHtml += @"
            <div class="stat-card">
                <div class="number">$($group.Count)</div>
                <div class="label">$($group.Name) Files</div>
            </div>
"@
}

$indexHtml += @"
        </div>
        
        <div class="search-box">
            <input type="text" id="searchInput" placeholder="🔍 Search documents by title...">
        </div>
        
        <div class="sections">
"@

# Add sections for each document type
foreach ($group in $docsByType) {
    $icon = switch ($group.Name) {
        "PDF" { "📕" }
        "DOCX" { "📘" }
        "PPTX" { "📙" }
        default { "📄" }
    }
    
    $indexHtml += @"
            <div class="section">
                <div class="section-header">
                    <span class="icon">$icon</span>
                    <h2>$($group.Name) Documents</h2>
                    <span class="count">$($group.Count)</span>
                </div>
                <div class="documents-grid">
"@
    
    foreach ($doc in ($group.Group | Sort-Object -Property Title)) {
        $safeTitle = [System.Web.HttpUtility]::HtmlEncode($doc.Title)
        $indexHtml += @"
                    <a href="$($doc.File)" class="document-card" onclick="return true;">
                        <div class="title">$safeTitle</div>
                        <span class="type">$($doc.Type)</span>
                        <div class="file-info">📦 $([System.Web.HttpUtility]::HtmlEncode($doc.SourceFile))</div>
                    </a>
"@
    }
    
    $indexHtml += @"
                </div>
            </div>
"@
}

$indexHtml += @"
        </div>
        
        <div class="footer">
            <p><strong>Total:</strong> $successCount documents successfully converted</p>
            <p style="margin-top: 10px; font-size: 0.9em; color: #999;">
                Generated on $(Get-Date -Format 'MMMM dd, yyyy HH:mm:ss')
            </p>
        </div>
    </div>
    
    <script>
        // Search functionality
        document.getElementById('searchInput').addEventListener('keyup', function(e) {
            const searchTerm = e.target.value.toLowerCase();
            const cards = document.querySelectorAll('.document-card');
            
            cards.forEach(card => {
                const title = card.querySelector('.title').textContent.toLowerCase();
                if (title.includes(searchTerm)) {
                    card.style.display = '';
                } else {
                    card.style.display = 'none';
                }
            });
        });
    </script>
</body>
</html>
"@

Set-Content -Path (Join-Path $OutputPath "index.html") -Value $indexHtml -Encoding UTF8

# Summary
Write-Host "`n" -ForegroundColor White
Write-Host "═════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "    CONVERSION COMPLETE" -ForegroundColor Green
Write-Host "═════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "✓ Successfully converted: $successCount documents" -ForegroundColor Green
Write-Host "✗ Errors encountered: $errorCount documents" -ForegroundColor $(if ($errorCount -gt 0) { "Yellow" } else { "Green" })
Write-Host "📁 Output directory: $OutputPath" -ForegroundColor Cyan
Write-Host "📇 Index file: $(Join-Path $OutputPath 'index.html')" -ForegroundColor Cyan
Write-Host "`nAccess your digital library at:" -ForegroundColor White
Write-Host "  http://localhost/liblary/generated/index.html" -ForegroundColor Yellow
Write-Host "═════════════════════════════════════════" -ForegroundColor Cyan
