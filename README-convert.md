Convert documents to HTML pages

This workspace contains many PDFs, Word documents and PowerPoint files.

Run the included PowerShell script `convert_docs.ps1` to create HTML pages in `generated/`.

Usage (PowerShell):

powershell -ExecutionPolicy Bypass -File .\convert_docs.ps1

Notes:
- The script tries a safe fallback: it copies original files into `generated/assets/` and creates HTML wrappers.
- If you have `pandoc` or LibreOffice (`soffice`) installed and you'd prefer full-content conversion, we can update the script to call them and extract text/content. Ask me to modify the script to use `pandoc` or `soffice` if available.
- The generated pages link to `../portal_styles.css` for styling; adjust paths or CSS as needed.