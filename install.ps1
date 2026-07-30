<#
.SYNOPSIS
    Daolu (道路) Installation Script for Windows
.DESCRIPTION
    Installs daolu (Chinese-localized opencode) from GitHub releases
#>

$ErrorActionPreference = "Stop"

$Repo = "taobaoww2010-alt/daolu"
$DaoluDir = "$env:USERPROFILE\.local\bin"
$DaoluBin = "$DaoluDir\daolu.exe"

Write-Host "=========================================" -ForegroundColor Green
Write-Host "  Daolu (道路) Installation Script" -ForegroundColor Green
Write-Host "  Chinese-localized opencode" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""

# Detect platform
switch ($env:PROCESSOR_ARCHITECTURE) {
    "AMD64" { $Platform = "windows-x64" }
    "ARM64" { $Platform = "windows-arm64" }
    default {
        Write-Host "Error: Unsupported architecture ($env:PROCESSOR_ARCHITECTURE)" -ForegroundColor Red
        Write-Host "Supported: windows-arm64, windows-x64"
        exit 1
    }
}

Write-Host "Detected platform: $Platform" -ForegroundColor Yellow

# Get download URL from latest release
Write-Host "Downloading daolu..." -ForegroundColor Yellow
$ApiUrl = "https://api.github.com/repos/$Repo/releases/latest"

try {
    $Release = Invoke-RestMethod -Uri $ApiUrl -Headers @{ "Accept" = "application/json" }
    $AssetUrl = $Release.assets | Where-Object { $_.name -like "daolu-$Platform*" } | Select-Object -First 1

    if (-not $AssetUrl) {
        Write-Host "Error: No pre-built binary found for $Platform" -ForegroundColor Red
        Write-Host "Check: https://github.com/$Repo/releases"
        exit 1
    }

    Write-Host "Download URL: $($AssetUrl.browser_download_url)" -ForegroundColor Yellow

    # Create directory
    New-Item -ItemType Directory -Force -Path $DaoluDir | Out-Null

    # Download binary as daolu.exe
    Invoke-WebRequest -Uri $AssetUrl.browser_download_url -OutFile $DaoluBin

    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Green
    if (Test-Path $DaoluBin) {
        Write-Host "  Installation successful!" -ForegroundColor Green
        Write-Host "  Binary: $DaoluBin" -ForegroundColor Green

        # Check if in PATH
        $UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
        if ($UserPath -notlike "*$DaoluDir*") {
            Write-Host ""
            Write-Host "  Add to your PATH:" -ForegroundColor Yellow
            Write-Host "    [Environment]::SetEnvironmentVariable('Path'," -ForegroundColor Yellow
            Write-Host "      [Environment]::GetEnvironmentVariable('Path', 'User') + ';$DaoluDir'," -ForegroundColor Yellow
            Write-Host "      'User')" -ForegroundColor Yellow
        }

        Write-Host ""
        Write-Host "  Usage: daolu" -ForegroundColor Green
        Write-Host "=========================================" -ForegroundColor Green
    } else {
        Write-Host "  Installation failed" -ForegroundColor Red
        Write-Host "=========================================" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "Error: Failed to download daolu" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}
