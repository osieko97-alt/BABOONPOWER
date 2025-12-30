// Kenyan Educational AI Dataset Portal Script
let datasetStructure = {};

// Load dataset structure
async function loadDatasetStructure() {
    try {
        const response = await fetch('dataset_structure.json');
        datasetStructure = await response.json();
        initializePortal();
    } catch (error) {
        console.error('Error loading dataset structure:', error);
    }
}

// Initialize portal with dataset information
function initializePortal() {
    // Update dashboard stats
    document.getElementById('total-files').textContent = datasetStructure.metadata.total_files;
    document.getElementById('total-subjects').textContent = datasetStructure.subjects.length;
    document.getElementById('education-levels').textContent = Object.keys(datasetStructure.metadata.education_levels).length;

    // Update education level counts
    document.getElementById('primary-count').textContent = datasetStructure.metadata.education_levels.Primary;
    document.getElementById('secondary-count').textContent = datasetStructure.metadata.education_levels.Secondary;

    // Load subjects
    loadSubjects();
}

// Load subjects into the subjects grid
function loadSubjects() {
    const subjectsGrid = document.getElementById('subjects-grid');
    subjectsGrid.innerHTML = '';

    datasetStructure.subjects.forEach(subject => {
        const subjectCard = document.createElement('div');
        subjectCard.className = 'subject-card';

        subjectCard.innerHTML = `
            <h3>${subject.name}</h3>
            <p>Levels: ${subject.levels.join(', ')}</p>
            <p>File Types: ${subject.file_types.join(', ')}</p>
            <p>Topics: ${subject.topics.length}</p>
            <button onclick="viewSubjectDetails('${subject.name}')">View Details</button>
        `;

        subjectsGrid.appendChild(subjectCard);
    });
}

// View subject details
function viewSubjectDetails(subjectName) {
    const subject = datasetStructure.subjects.find(s => s.name === subjectName);
    if (!subject) return;

    alert(`Subject: ${subject.name}\n\nLevels: ${subject.levels.join(', ')}\n\nFile Types: ${subject.file_types.join(', ')}\n\nTopics:\n- ${subject.topics.join('\n- ')}`);
}

// Show section and hide others
function showSection(sectionId) {
    // Hide all sections
    document.querySelectorAll('.section').forEach(section => {
        section.classList.remove('active');
    });

    // Remove active class from nav links
    document.querySelectorAll('nav a').forEach(link => {
        link.classList.remove('active');
    });

    // Show selected section
    const selectedSection = document.getElementById(sectionId);
    if (selectedSection) {
        selectedSection.classList.add('active');
    }

    // Add active class to clicked nav link
    const activeLink = Array.from(document.querySelectorAll('nav a')).find(link =>
        link.getAttribute('onclick')?.includes(sectionId)
    );
    if (activeLink) {
        activeLink.classList.add('active');
    }
}

// Search dataset
function searchDataset() {
    const searchTerm = document.getElementById('search-input').value.toLowerCase();
    const searchResults = document.getElementById('search-results');

    if (!searchTerm) {
        searchResults.innerHTML = '<p>Please enter a search term.</p>';
        return;
    }

    // Search through subjects, topics, and levels
    const results = [];

    datasetStructure.subjects.forEach(subject => {
        // Check if subject name matches
        if (subject.name.toLowerCase().includes(searchTerm)) {
            results.push({
                type: 'subject',
                name: subject.name,
                details: `Levels: ${subject.levels.join(', ')} | Topics: ${subject.topics.length}`
            });
        }

        // Check if any topic matches
        subject.topics.forEach(topic => {
            if (topic.toLowerCase().includes(searchTerm)) {
                results.push({
                    type: 'topic',
                    name: topic,
                    subject: subject.name,
                    details: `Subject: ${subject.name} | Levels: ${subject.levels.join(', ')}`
                });
            }
        });

        // Check if any level matches
        subject.levels.forEach(level => {
            if (level.toLowerCase().includes(searchTerm)) {
                results.push({
                    type: 'level',
                    name: level,
                    subject: subject.name,
                    details: `Subject: ${subject.name} | Topics: ${subject.topics.length}`
                });
            }
        });
    });

    // Display results
    if (results.length === 0) {
        searchResults.innerHTML = '<p>No results found.</p>';
    } else {
        searchResults.innerHTML = `
            <h3>Search Results (${results.length})</h3>
            <div class="results-list">
                ${results.map(result => `
                    <div class="result-item">
                        <h4>${result.name} <span class="result-type">${result.type}</span></h4>
                        <p>${result.details}</p>
                        ${result.subject ? `<p>Subject: ${result.subject}</p>` : ''}
                    </div>
                `).join('')}
            </div>
        `;
    }
}

// Handle upload form submission
document.getElementById('upload-form')?.addEventListener('submit', function(e) {
    e.preventDefault();

    const subject = document.getElementById('file-subject').value;
    const level = document.getElementById('education-level').value;
    const topic = document.getElementById('file-topic').value;
    const fileInput = document.getElementById('file-upload');

    if (!subject || !level || !topic || !fileInput.files[0]) {
        alert('Please fill in all fields and select a file.');
        return;
    }

    const file = fileInput.files[0];
    const fileType = file.name.split('.').pop().toLowerCase();

    // Validate file type
    const allowedTypes = ['pdf', 'docx', 'pptx'];
    if (!allowedTypes.includes(fileType)) {
        alert('Only PDF, DOCX, and PPTX files are allowed.');
        return;
    }

    // Simulate upload (in a real implementation, this would be an API call)
    alert(`File upload simulation:\n\nSubject: ${subject}\nLevel: ${level}\nTopic: ${topic}\nFile: ${file.name}\nSize: ${(file.size / 1024).toFixed(2)} KB\n\nThis would be uploaded to the dataset.`);
});

// Initialize the portal when the page loads
window.addEventListener('DOMContentLoaded', loadDatasetStructure);