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