# Bulk Document to HTML Converter

This script scans the workspace for PDF, DOCX, and PPTX files, extracts their content, and generates HTML files for each document. It also creates an index.html linking to all generated pages.

## Dependencies
- python-docx
- PyPDF2
- python-pptx

## Usage
1. Install dependencies:
   pip install python-docx PyPDF2 python-pptx
2. Run the script:
   python bulk_convert.py

## Output
- All generated HTML files and original documents will be placed in the `generated/` folder.
- An `index.html` will be created in `generated/` linking to all converted documents.
