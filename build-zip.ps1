# Packages the Mist Streaming Roku app into a distributable zip.
# run it from the project root!!!

$projectRoot = "C:\Users\Rukasu\mist-streaming"
$outputZip = Join-Path $projectRoot "Mist Streaming.zip"

$includeItems = @(
    "manifest",
    "components",
    "source",
    "images",
    "fonts"
)

# Remove old zip justin case
if (Test-Path $outputZip) {
    Remove-Item $outputZip -Force
}

$pathsToZip = $includeItems |
    ForEach-Object { Join-Path $projectRoot $_ } |
    Where-Object { Test-Path $_ }

if ($pathsToZip.Count -eq 0) {
    Write-Host "No valid folders/files found to package. Check `$projectRoot and `$includeItems." -ForegroundColor Red
    exit 1
}

Compress-Archive -Path $pathsToZip -DestinationPath $outputZip -Force

Write-Host "Package created: $outputZip" -ForegroundColor Green
