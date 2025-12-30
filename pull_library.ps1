# PowerShell script to pull the library folder from local machine and push to GitHub repo
# Run this script on your local Windows machine after cloning the BABOONPOWER repo

# Define paths
$localRepoPath = "C:\path\to\your\local\BABOONPOWER"  # Change this to your actual local repo path
$sourceFolder = "C:\xampp\htdocs\liblary"
$destFolder = "$localRepoPath\liblary"

# Check if source folder exists
if (!(Test-Path $sourceFolder)) {
    Write-Host "Source folder $sourceFolder does not exist. Please check the path."
    exit 1
}

# Check if local repo exists
if (!(Test-Path $localRepoPath)) {
    Write-Host "Local repo path $localRepoPath does not exist. Please clone the repo first."
    exit 1
}

# Copy the folder
Write-Host "Copying $sourceFolder to $destFolder..."
Copy-Item -Path $sourceFolder -Destination $destFolder -Recurse -Force

# Change to repo directory
Set-Location $localRepoPath

# Git add, commit, push
Write-Host "Adding files to Git..."
git add .

Write-Host "Committing changes..."
git commit -m "Add library folder from local machine"

Write-Host "Pushing to remote..."
git push origin main

Write-Host "Done! The folder has been pulled and pushed to the remote workspace."