<<<<<<< HEAD
# Educational Materials Portal

A comprehensive web-based system for organizing, accessing, and managing educational materials for various class levels and subjects in the Kenyan curriculum.

## 📋 Features

### Main Portal (`index.html`)
- **Dashboard**: Overview of material statistics and quick access buttons
- **All Materials**: Grid/list view of all educational resources
- **By Class**: Browse materials organized by class level (PP1, PP2, Grade 1-8, Form 1-4)
- **By Subject**: Browse materials organized by subject area
- **Advanced Search**: Search and filter materials by multiple criteria

### CV System (`online_cv_system.html`)
- **Spreadsheet View**: Excel-like interface showing materials by subject (rows) and class (columns)
- **Interactive Filtering**: Filter by class, subject, or search terms
- **File Interactions**: Preview, download, and share materials directly from the interface

## 🎓 Supported Curriculum

### Class Levels
- Pre-Primary: PP1, PP2
- Primary: Grade 1-8
- Secondary: Form 1-4

### Subject Areas
- 📚 English & Language Activities
- 🔢 Mathematics
- ✝️ CRE & Religious Education
- 🗣️ Kiswahili
- 🌍 Environmental Activities
- 🍎 Hygiene and Nutrition
- 🎨 Creative Activities
- 🔬 Science Subjects (Chemistry, Physics, Biology)
- 💻 Technology & Computer Studies

## 🚀 Quick Start

### Prerequisites
- Windows 11 (or compatible OS)
- XAMPP installed (Apache + MySQL + PHP)
- Modern web browser

### Installation
1. **Install XAMPP**:
   - Download from https://www.apachefriends.org/download.html
   - Install with Apache, MySQL, and PHP components
   - Default installation path: `C:\xampp`

2. **Setup Portal**:
   - Copy all portal files to `C:\xampp\htdocs\`
   - Copy educational materials (PDFs, PPTs) to `C:\xampp\htdocs\`

3. **Start Services**:
   - Launch XAMPP Control Panel
   - Start Apache and MySQL services

4. **Access Portal**:
   - Open browser and navigate to `http://localhost/`
   - Click on `index.html` to access the main portal

### Alternative Launch
Use the provided `launch_portal.bat` script for automated setup and launch.

## 📁 Project Structure

```
liblary/
├── index.html                 # Main portal page
├── online_cv_system.html      # CV system spreadsheet view
├── portal_styles.css          # Main portal styling
├── cv_styles.css             # CV system styling
├── portal_script.js          # Main portal JavaScript
├── cv_script.js              # CV system JavaScript
├── README.md                 # This file
├── xampp_setup_guide.md      # Detailed XAMPP setup instructions
├── launch_portal.bat         # Automated launcher script
├── push_to_github.bat        # Git deployment script
└── [educational_materials]/  # PDF and PPT files
```

## 🔧 Technical Details

### Technologies Used
- **Frontend**: HTML5, CSS3, JavaScript (ES6+)
- **Styling**: Modern CSS with gradients, animations, and responsive design
- **Architecture**: Client-side only (no backend required)
- **Compatibility**: Works offline once loaded

### Key Components
- **Material Database**: JSON-based catalog of all educational resources
- **Dynamic Filtering**: Real-time search and filter functionality
- **Responsive Design**: Mobile-friendly interface
- **File Handling**: Direct download and preview capabilities

## 📊 Material Statistics

- **Total Materials**: 60+ educational resources
- **Class Coverage**: 14 class levels
- **Subject Areas**: 9 main subject categories
- **File Types**: PDF documents, PowerPoint presentations

## 🎯 Usage Guide

### Main Portal Navigation
1. **Dashboard**: Get overview and quick access to key features
2. **All Materials**: Browse complete collection with grid/list toggle
3. **By Class**: Select specific class level to view relevant materials
4. **By Subject**: Choose subject area to explore related content
5. **Search**: Use advanced search with multiple filter options

### CV System Features
1. **Spreadsheet View**: See all materials in organized table format
2. **Class Filtering**: Focus on specific class levels
3. **Subject Filtering**: Isolate particular subject areas
4. **Search**: Find materials by title or content
5. **File Actions**: Click any material for preview/download/share options

## 🔒 Security & Privacy

- **Local Deployment**: Runs entirely on local machine
- **No Data Collection**: No user data sent to external servers
- **File Access**: Direct local file system access only
- **Safe Sharing**: Educational materials only

## 🤝 Contributing

### Adding New Materials
1. Add PDF/PPT files to the project directory
2. Update `materialsDatabase` array in `portal_script.js`
3. Add corresponding entries in `online_cv_system.html` table
4. Test file access and functionality

### Code Improvements
- Follow existing code style and structure
- Test on multiple browsers
- Ensure responsive design works on mobile devices
- Update documentation as needed

## 📞 Support

### Troubleshooting
- **Apache Not Starting**: Check port 80 availability, run as administrator
- **Files Not Loading**: Verify file paths and permissions
- **Styling Issues**: Clear browser cache, check CSS file loading

### Getting Help
1. Check `xampp_setup_guide.md` for detailed setup instructions
2. Verify XAMPP services are running
3. Test with different browsers
4. Check browser developer console for JavaScript errors

## 📝 License

This project is created for educational purposes. All educational materials included are for teaching and learning use.

## 🙏 Acknowledgments

- Educational materials sourced from Teacher.co.ke and other educational resources
- Built with modern web technologies for optimal user experience
- Designed for Kenyan education system curriculum

---

**Ready to explore?** Launch the portal and start discovering educational materials organized just for you!
=======
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

### Pulling a Specific Folder from Local Machine

If you have a specific folder like `C:\xampp\htdocs\liblary` on your Windows machine that you want to pull into the workspace:

1. Download the `pull_library.ps1` script from this repository (or copy its contents).
2. Edit the script: Update `$localRepoPath` to the path of your local clone of this repository.
3. Run the PowerShell script on your local machine. It will copy the folder, commit, and push to the remote repo.
4. The folder will then be available in the remote workspace under `liblary/`.

**Note:** Ensure you have Git configured on your local machine and have cloned this repository.

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
>>>>>>> 74b858454adff0a07fe98cd290b861fe398d9329
