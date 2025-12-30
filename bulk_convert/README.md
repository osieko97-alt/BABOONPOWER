Bulk Document Converter
=======================

What this does
--------------
- Scans a source folder recursively for `.pdf`, `.docx`, and `.pptx` files.
- Extracts text and basic metadata (title, size, path).
- Writes one HTML page per document into a `generated/` directory, and copies originals into `generated/assets/`.
- Produces `generated/index.html` linking to all pages.

Requirements
------------
- Python 3.8+
- Install dependencies from `requirements.txt`:

```powershell
# activate your venv first, if used
python -m pip install -r bulk_convert/requirements.txt
```

Quick usage
-----------
Run from the workspace root (where your documents live) or point `--src` to the folder:

```powershell
python bulk_convert/convert_docs.py --src . --out generated
```

Notes & limitations
-------------------
- The script uses `PyPDF2`, `python-docx` and `python-pptx` which perform basic text extraction. Complex PDFs (images, scanned pages) will not yield text; consider OCR (Tesseract) for those.
- Legacy `.doc` files are not handled. For `.doc` conversion, install LibreOffice and run it headless to convert `.doc` -> `.docx` first.
- The script does not attempt to preserve rich styling; it exports text only. You can extend it to render headings, lists, or images if needed.

Additional tools
----------------
- For OCR and .doc support use the enhanced script `convert_docs_full.py` with the full requirements file `requirements_full.txt`.

Install system requirements for OCR (Windows example):

```powershell
# install python deps
python -m pip install -r bulk_convert/requirements_full.txt
# Install Tesseract: https://github.com/tesseract-ocr/tesseract/releases
# Install Poppler (for pdf2image) and add `bin` folder to PATH
# Install LibreOffice (if you want .doc -> .docx conversion)
```

Run example (with OCR and doc conversion attempts):

```powershell
python bulk_convert/convert_docs_full.py --src . --out generated --ocr --convert-doc
```

Support
-------
If you want, I can:
- Add OCR (Tesseract) to process scanned PDFs.
- Add `.doc` support via LibreOffice headless conversion.
- Run the script here (if you allow executing commands) or walk you through running it locally.
