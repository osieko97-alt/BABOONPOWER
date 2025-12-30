# XAMPP Setup Guide for Educational Materials Portal

## 📋 Prerequisites
- Windows 11 (current system)
- Administrator access
- Internet connection for downloading XAMPP

## 🚀 Step-by-Step XAMPP Installation

### Step 1: Download XAMPP
1. Go to https://www.apachefriends.org/download.html
2. Download XAMPP for Windows (latest version)
3. Choose the version with PHP 8.0 or higher

### Step 2: Install XAMPP
1. **Run the installer** as Administrator:
   - Right-click on the downloaded file
   - Select "Run as administrator"

2. **Component Selection** (Recommended components):
   - ✅ Apache
   - ✅ MySQL
   - ✅ PHP
   - ✅ phpMyAdmin
   - ✅ Webalizer
   - ✅ Fake Sendmail

3. **Installation Directory**: 
   - Default: `C:\xampp`
   - ✅ Keep default path

4. **Language**: Choose English

5. **Complete Installation**: Click "Next" through all steps

### Step 3: Configure XAMPP
1. **Start XAMPP Control Panel** (as Administrator)
2. **Start Required Services**:
   - Click "Start" next to Apache
   - Click "Start" next to MySQL

3. **Verify Apache is Running**:
   - Apache status should show green "Running"
   - Port 80 should be active

## 🌐 Launching the Educational Materials Portal

### Step 1: Copy Files to XAMPP Directory
1. **Open File Explorer** as Administrator
2. **Navigate to**: `C:\xampp\htdocs\`
3. **Copy all portal files** to this directory:
   - `index.html`
   - `online_cv_system.html`
   - `cv_styles.css`
   - `portal_styles.css`
   - `cv_script.js`
   - `portal_script.js`
   - `README.md`

### Step 2: Copy Educational Materials
1. **Copy all educational PDF/PPT files** to: `C:\xampp\htdocs\`
2. **Maintain file structure** as they are currently organized

### Step 3: Access the Portal
1. **Open Web Browser**
2. **Navigate to**: `http://localhost/` or `http://127.0.0.1/`
3. **Click on**: `index.html`
4. **Portal will open** with full functionality

## 🔧 Troubleshooting Common Issues

### Issue 1: Apache Won't Start
**Solution**:
- Check if IIS is running (stop it)
- Run XAMPP as Administrator
- Check Port 80 availability
- Use alternative port (8080) if needed

### Issue 2: Permission Denied
**Solution**:
- Run XAMPP Control Panel as Administrator
- Check folder permissions on `C:\xampp\htdocs\`
- Grant "Everyone" read/write access if needed

### Issue 3: PHP Errors
**Solution**:
- Verify PHP is properly installed
- Check XAMPP logs for specific errors
- Ensure all required PHP extensions are enabled

### Issue 4: Files Not Loading
**Solution**:
- Verify all files are in `C:\xampp\htdocs\`
- Check file permissions
- Clear browser cache
- Try different browser

## 🌍 Alternative Access Methods

### Method 1: Local Network Access
If you want to access from other devices on your network:
1. Find your PC's IP address (ipconfig in Command Prompt)
2. Access via: `http://YOUR-IP-ADDRESS/`

### Method 2: Custom Port
If Port 80 is busy:
1. Edit `httpd.conf` in XAMPP
2. Change `Listen 80` to `Listen 8080`
3. Access via: `http://localhost:8080/`

## 📱 Testing the Portal

### Features to Test:
1. **Main Portal Navigation**:
   - Dashboard loads correctly
   - Statistics display
   - Quick access buttons work

2. **CV System**:
   - Spreadsheet layout displays
   - Class levels in header row
   - Subjects in first column
   - Material items are clickable

3. **Search and Filter**:
   - Search functionality works
   - Class filtering operates
   - Subject filtering functions

4. **Material Access**:
   - Files can be previewed
   - Downloads work correctly
   - Share functionality operates

## 🔒 Security Notes

### Local Development Only:
- XAMPP is for local development
- Don't expose to internet without proper security
- Use for preview and testing only

### File Permissions:
- Ensure educational materials are readable
- Don't place sensitive files in XAMPP directory

## 📞 Support

### If You Encounter Issues:
1. **Check XAMPP logs**: `C:\xampp\apache\logs\error.log`
2. **Browser developer tools**: Check for JavaScript errors
3. **File permissions**: Verify all files are accessible
4. **Antivirus interference**: Temporarily disable if needed

### Success Indicators:
- ✅ XAMPP Control Panel shows Apache running
- ✅ localhost shows XAMPP welcome page
- ✅ Portal loads without errors
- ✅ All navigation works
- ✅ Materials can be accessed

---

**Ready to Preview**: Once XAMPP is running and files are copied, visit `http://localhost/` to access your Educational Materials Portal!