# Simple SVG to PNG Converter
# Converts all SVG files in current folder to PNG with max dimensions 800x600

# Configuration - change these values as needed
$InputFolder = "."
$OutputFolder = "..\Filter"
$MaxWidth = 480
$MaxHeight = 420

# Check if ImageMagick is installed
try {
    $magick = Get-Command magick -ErrorAction Stop
    Write-Host "ImageMagick found: $($magick.Source)" -ForegroundColor Green
} catch {
    Write-Host "ImageMagick is required but not found." -ForegroundColor Red
    Write-Host "Please install ImageMagick from: https://imagemagick.org/script/download.php#windows" -ForegroundColor Yellow
    Write-Host "Or install via chocolatey: choco install imagemagick" -ForegroundColor Yellow
    pause
    exit 1
}

# Create output folder if it doesn't exist
if (!(Test-Path $OutputFolder)) {
    New-Item -ItemType Directory -Path $OutputFolder -Force | Out-Null
    Write-Host "Created output directory: $OutputFolder" -ForegroundColor Yellow
}

# Get all SVG files
$svgFiles = Get-ChildItem -Path $InputFolder -Filter "*.svg" -File

if ($svgFiles.Count -eq 0) {
    Write-Host "No SVG files found in: $InputFolder" -ForegroundColor Yellow
    pause
    exit 0
}

Write-Host "Found $($svgFiles.Count) SVG file(s) to convert..." -ForegroundColor Green

# Convert each SVG file
foreach ($svgFile in $svgFiles) {
    $inputPath = $svgFile.FullName
    $outputName = [System.IO.Path]::GetFileNameWithoutExtension($svgFile.Name) + ".png"
    $outputPath = Join-Path $OutputFolder $outputName
    
    Write-Host "Converting: $($svgFile.Name) -> $outputName" -ForegroundColor Cyan
    
    # Use ImageMagick to convert
    & magick -background none -density "${MaxWidth}"  $inputPath -resize "${MaxWidth}x${MaxHeight}" -alpha "on" $outputPath
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Success: $outputName" -ForegroundColor Green
    } else {
        Write-Host "Failed: $($svgFile.Name)" -ForegroundColor Red
    }
}

Write-Host "`nAll conversions completed!" -ForegroundColor Green
Write-Host "Output folder: $OutputFolder" -ForegroundColor Yellow
pause