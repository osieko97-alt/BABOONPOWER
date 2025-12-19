# BABOONPOWER

## Bulk Document Converter

### What this does

- Scans a source folder recursively for `.pdf`, `.docx`, and `.pptx` files.
- Extracts text and basic metadata (title, size, path).
- Writes one HTML page per document into a `generated/` directory, and copies originals into `generated/assets/`.
- Produces `generated/index.html` linking to all pages.

### Requirements

- Python 3.8+
- Install dependencies from `requirements.txt`:

```powershell
# activate your venv first, if used
python -m pip install -r requirements.txt
```

### Quick usage

Run from the workspace root (where your documents live) or point `--src` to the folder:

```powershell
python bulk_convert.py --src . --out generated
```

### Uploading Files from Local Machine

To process documents from your local machine in this remote workspace:

1. In VS Code, open the File Explorer (View > Explorer or Ctrl+Shift+E).
2. Right-click in the workspace folder (e.g., BABOONPOWER) and select "Upload..." to choose files/folders from your local machine.
3. Alternatively, drag and drop files or folders directly from your local file explorer into the VS Code workspace.
4. Place your PDF, DOCX, PPTX (and optionally .doc) files in the desired source folder (default is the workspace root `.`).
5. Run the conversion script as described above.

For large transfers or automation:

- **Use Git:** Commit and push files from your local repository to this remote repo (see below).
- Use command-line tools like `scp` if SSH access is configured between your local machine and the remote environment.

### Using Git to Transfer Files from Local Machine

To use Git for version-controlled file transfers from your local machine to this remote workspace:

1. **Clone the repository locally** (on your machine):
   ```bash
   git clone https://github.com/osieko97-alt/BABOONPOWER.git
   cd BABOONPOWER
   ```

2. **Add your document files** (PDF, DOCX, PPTX, etc.) to the local repo. For example, place them in a `documents/` folder or the root.

3. **Commit the files**:
   ```bash
   git add .
   git commit -m "Add document files for conversion"
   ```

4. **Push to the remote repository**:
   ```bash
   git push origin main
   ```

5. The files will now be available in the remote workspace. You can then run the conversion scripts on them.

This method allows for version control, history tracking, and easy synchronization of changes between your local machine and the remote workspace.

**Git Flow Setup:** This repository has a basic Git Flow structure initialized with `main` and `develop` branches. For full Git Flow workflow (features, releases, hotfixes), install `git-flow` locally and run `git flow init` in your local clone. The `develop` branch is set as the development branch.

### Notes & limitations

- The script uses `PyPDF2`, `python-docx` and `python-pptx` which perform basic text extraction. Complex PDFs (images, scanned pages) will not yield text; consider OCR (Tesseract) for those.
- Legacy `.doc` files are not handled. For `.doc` conversion, install LibreOffice and run it headless to convert `.doc` -> `.docx` first.
- The script does not attempt to preserve rich styling; it exports text only. You can extend it to render headings, lists, or images if needed.

### Additional tools

- For OCR and .doc support use the enhanced script `convert_docs_full.py` with the full requirements file `requirements.txt`.

Install system requirements for OCR:

**Linux (Ubuntu/Debian):**

```bash
sudo apt update
sudo apt install -y tesseract-ocr poppler-utils libreoffice
```

**Windows:**

```powershell
# install python deps
python -m pip install -r requirements.txt
# Install Tesseract: https://github.com/tesseract-ocr/tesseract/releases
# Install Poppler (for pdf2image) and add `bin` folder to PATH
# Install LibreOffice (if you want .doc -> .docx conversion)
```

**Note:** In this dev container environment, system packages cannot be installed due to lack of sudo access. The scripts will work for basic PDF/DOCX/PPTX text extraction without OCR and .doc conversion features.

Run example (with OCR and doc conversion attempts):

```powershell
python convert_docs_full.py --src . --out generated --ocr --convert-doc
```

### Support

If you want, I can:

- Add OCR (Tesseract) to process scanned PDFs.
- Add `.doc` support via LibreOffice headless conversion.
- Run the script here (if you allow executing commands) or walk you through running it locally.
