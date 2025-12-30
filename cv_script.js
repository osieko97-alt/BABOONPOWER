// Educational Materials CV System JavaScript

document.addEventListener('DOMContentLoaded', function() {
    // Initialize the system
    initializeSystem();
    addClickHandlers();
});

// Initialize system
function initializeSystem() {
    console.log('Educational Materials CV System initialized');
    
    // Add empty cell indicators
    const classCells = document.querySelectorAll('.class-cell');
    classCells.forEach(cell => {
        if (cell.children.length === 0) {
            cell.classList.add('empty-cell');
        }
    });
    
    // Add animation to material items
    const materialItems = document.querySelectorAll('.material-item');
    materialItems.forEach((item, index) => {
        item.style.animationDelay = `${index * 0.1}s`;
        item.classList.add('fade-in');
    });
}

// Add click handlers to all material items
function addClickHandlers() {
    const materialItems = document.querySelectorAll('.material-item');
    materialItems.forEach(item => {
        item.addEventListener('click', function() {
            const fileName = this.getAttribute('data-file');
            const title = this.textContent.trim();
            openModal(fileName, title);
        });
    });
}

// Filter by Class functionality
function filterByClass() {
    const classHeaders = document.querySelectorAll('.class-header');
    const subjectRows = document.querySelectorAll('.subject-row');
    
    // Simple alert for now - could be enhanced with dropdown
    const selectedClass = prompt("Enter class to filter by (PP1, PP2, Grade 1-8, Form 1-4):");
    
    if (selectedClass) {
        // Remove previous filters
        subjectRows.forEach(row => {
            row.classList.remove('hidden', 'filtered');
        });
        
        // Hide rows that don't have materials for the selected class
        subjectRows.forEach(row => {
            const classCell = row.querySelector(`[data-class="${selectedClass}"]`);
            const hasMaterials = classCell && classCell.children.length > 0;
            
            if (!hasMaterials) {
                row.style.opacity = '0.3';
                row.style.filter = 'grayscale(100%)';
            } else {
                row.style.opacity = '1';
                row.style.filter = 'none';
                row.classList.add('filtered');
            }
        });
        
        setTimeout(() => {
            subjectRows.forEach(row => {
                if (!row.classList.contains('filtered')) {
                    row.style.display = 'none';
                }
            });
        }, 500);
    }
}

// Filter by Subject functionality
function filterBySubject() {
    const subjectRows = document.querySelectorAll('.subject-row');
    const subjects = ['english', 'mathematics', 'cre', 'kiswahili', 'environmental', 'hygiene', 'creative', 'science', 'technology'];
    
    const selectedSubject = prompt(`Enter subject to filter by:\n- english\n- mathematics\n- cre\n- kiswahili\n- environmental\n- hygiene\n- creative\n- science\n- technology`);
    
    if (selectedSubject && subjects.includes(selectedSubject.toLowerCase())) {
        // Hide all rows first
        subjectRows.forEach(row => {
            row.classList.add('hidden');
            row.style.display = 'none';
        });
        
        // Show only the selected subject row
        const targetRow = document.querySelector(`[data-subject="${selectedSubject.toLowerCase()}"]`);
        if (targetRow) {
            targetRow.classList.remove('hidden');
            targetRow.style.display = '';
            targetRow.classList.add('filtered');
            
            // Scroll to the row
            targetRow.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
    }
}

// Show all functionality
function showAll() {
    const subjectRows = document.querySelectorAll('.subject-row');
    
    subjectRows.forEach(row => {
        row.classList.remove('hidden', 'filtered');
        row.style.display = '';
        row.style.opacity = '1';
        row.style.filter = 'none';
    });
    
    // Reset search
    document.getElementById('searchBox').value = '';
}

// Search functionality
function searchMaterials() {
    const searchTerm = document.getElementById('searchBox').value.toLowerCase();
    const materialItems = document.querySelectorAll('.material-item');
    
    if (searchTerm === '') {
        // Reset to show all
        materialItems.forEach(item => {
            item.style.opacity = '1';
            item.style.transform = 'scale(1)';
        });
        return;
    }
    
    // Search through material items
    materialItems.forEach(item => {
        const title = item.textContent.toLowerCase();
        const matches = title.includes(searchTerm);
        
        if (matches) {
            item.style.opacity = '1';
            item.style.transform = 'scale(1.05)';
            item.style.background = 'linear-gradient(135deg, #ff6b6b 0%, #ee5a52 100%)';
            item.style.boxShadow = '0 4px 15px rgba(255, 107, 107, 0.4)';
        } else {
            item.style.opacity = '0.3';
            item.style.transform = 'scale(0.95)';
            item.style.background = 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)';
            item.style.boxShadow = '0 2px 8px rgba(0,0,0,0.1)';
        }
    });
}

// Open modal with file information
function openModal(fileName, title) {
    const modal = document.getElementById('fileModal');
    const modalBody = document.getElementById('modalBody');
    
    // Create modal content
    modalBody.innerHTML = `
        <h3>${title}</h3>
        <p><strong>File:</strong> ${fileName}</p>
        <div class="file-actions">
            <button onclick="downloadFile('${fileName}')" style="background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%); color: white; border: none; padding: 10px 20px; margin: 10px 5px; border-radius: 5px; cursor: pointer;">
                📥 Download File
            </button>
            <button onclick="previewFile('${fileName}')" style="background: linear-gradient(135deg, #2196F3 0%, #1976D2 100%); color: white; border: none; padding: 10px 20px; margin: 10px 5px; border-radius: 5px; cursor: pointer;">
                👁️ Preview
            </button>
            <button onclick="shareFile('${fileName}')" style="background: linear-gradient(135deg, #FF9800 0%, #F57C00 100%); color: white; border: none; padding: 10px 20px; margin: 10px 5px; border-radius: 5px; cursor: pointer;">
                📤 Share
            </button>
        </div>
        <div id="filePreview" style="margin-top: 20px; padding: 20px; background: white; border-radius: 10px; border: 2px dashed #ddd;">
            <p style="text-align: center; color: #666;">Click "Preview" to view file content</p>
        </div>
    `;
    
    modal.style.display = 'block';
    
    // Add animation
    setTimeout(() => {
        modal.style.opacity = '1';
    }, 10);
}

// Close modal
function closeModal() {
    const modal = document.getElementById('fileModal');
    modal.style.opacity = '0';
    setTimeout(() => {
        modal.style.display = 'none';
    }, 300);
}

// Download file function
function downloadFile(fileName) {
    // Create a temporary link to trigger download
    const link = document.createElement('a');
    link.href = fileName;
    link.download = fileName;
    link.style.display = 'none';
    
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    
    showNotification('Download started!', 'success');
}

// Preview file function
function previewFile(fileName) {
    const previewDiv = document.getElementById('filePreview');
    
    // Determine file type and show appropriate preview
    if (fileName.endsWith('.pdf')) {
        previewDiv.innerHTML = `
            <div style="text-align: center;">
                <h4>PDF Preview</h4>
                <p>File: ${fileName}</p>
                <iframe src="${fileName}" width="100%" height="400px" style="border: 1px solid #ddd; border-radius: 5px;">
                    <p>Your browser does not support PDF preview. <a href="${fileName}" target="_blank">Download the PDF</a></p>
                </iframe>
            </div>
        `;
    } else if (fileName.endsWith('.pptx')) {
        previewDiv.innerHTML = `
            <div style="text-align: center;">
                <h4>PowerPoint Presentation</h4>
                <p>File: ${fileName}</p>
                <div style="padding: 40px; background: #f8f9fa; border-radius: 10px;">
                    <p>📊 PowerPoint Presentation</p>
                    <p style="color: #666;">Click download to view the presentation</p>
                </div>
            </div>
        `;
    } else if (fileName.endsWith('.docx')) {
        previewDiv.innerHTML = `
            <div style="text-align: center;">
                <h4>Word Document</h4>
                <p>File: ${fileName}</p>
                <div style="padding: 40px; background: #f8f9fa; border-radius: 10px;">
                    <p>📄 Word Document</p>
                    <p style="color: #666;">Click download to view the document</p>
                </div>
            </div>
        `;
    } else {
        previewDiv.innerHTML = `
            <div style="text-align: center;">
                <h4>File Preview</h4>
                <p>File: ${fileName}</p>
                <div style="padding: 40px; background: #f8f9fa; border-radius: 10px;">
                    <p>📁 File Type: ${fileName.split('.').pop().toUpperCase()}</p>
                    <p style="color: #666;">Click download to view the file</p>
                </div>
            </div>
        `;
    }
}

// Share file function
function shareFile(fileName) {
    if (navigator.share) {
        navigator.share({
            title: 'Educational Material',
            text: `Check out this educational material: ${fileName}`,
            url: window.location.href
        });
    } else {
        // Fallback for browsers that don't support Web Share API
        const shareData = {
            title: 'Educational Material',
            text: `Check out this educational material: ${fileName}`,
            url: window.location.href
        };
        
        if (navigator.clipboard) {
            navigator.clipboard.writeText(`${shareData.title}\n${shareData.text}\n${shareData.url}`);
            showNotification('Share link copied to clipboard!', 'success');
        } else {
            showNotification('Sharing not supported on this browser', 'error');
        }
    }
}

// Show notification
function showNotification(message, type = 'info') {
    // Create notification element
    const notification = document.createElement('div');
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        padding: 15px 25px;
        background: ${type === 'success' ? '#4CAF50' : type === 'error' ? '#f44336' : '#2196F3'};
        color: white;
        border-radius: 5px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.3);
        z-index: 1001;
        animation: slideIn 0.3s ease-out;
    `;
    notification.textContent = message;
    
    // Add animation styles
    const style = document.createElement('style');
    style.textContent = `
        @keyframes slideIn {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
    `;
    document.head.appendChild(style);
    
    document.body.appendChild(notification);
    
    // Remove notification after 3 seconds
    setTimeout(() => {
        notification.style.animation = 'slideIn 0.3s ease-out reverse';
        setTimeout(() => {
            document.body.removeChild(notification);
        }, 300);
    }, 3000);
}

// Close modal when clicking outside
window.onclick = function(event) {
    const modal = document.getElementById('fileModal');
    if (event.target === modal) {
        closeModal();
    }
}

// Keyboard shortcuts
document.addEventListener('keydown', function(event) {
    // Escape key to close modal
    if (event.key === 'Escape') {
        closeModal();
    }
    
    // Ctrl+F to focus search
    if (event.ctrlKey && event.key === 'f') {
        event.preventDefault();
        document.getElementById('searchBox').focus();
    }
});

// Export functions for global access
window.filterByClass = filterByClass;
window.filterBySubject = filterBySubject;
window.showAll = showAll;
window.searchMaterials = searchMaterials;
window.openModal = openModal;
window.closeModal = closeModal;
window.downloadFile = downloadFile;
window.previewFile = previewFile;
window.shareFile = shareFile;