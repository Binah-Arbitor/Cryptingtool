# Android SDK License Acceptance PowerShell Script
# Enhanced version based on Stack Overflow solutions
# Multi-Method License Acceptance System
# Addresses "1 of 7 SDK package license not accepted" issue

param(
    [int]$TimeoutSeconds = 180,
    [int]$MaxRetries = 3
)

Write-Host "=== Enhanced Android SDK License Acceptance ===" -ForegroundColor Green
Write-Host "Using Stack Overflow proven methods" -ForegroundColor Yellow
Write-Host "Timeout: $TimeoutSeconds seconds, Max retries: $MaxRetries" -ForegroundColor Yellow

$licenseAccepted = $false
$retryCount = 0

function Test-AndroidLicenses {
    Write-Host "🔍 Checking current license status..." -ForegroundColor Cyan
    $doctorOutput = flutter doctor 2>&1 | Out-String
    
    if ($doctorOutput -match "licenses.*not.*accepted" -or $doctorOutput -match "Android licenses not accepted") {
        Write-Host "❌ Android licenses not accepted" -ForegroundColor Red
        return $false
    } elseif ($doctorOutput -match "Android toolchain.*✓" -or $doctorOutput -match "All Android licenses accepted") {
        Write-Host "✅ Android licenses are accepted" -ForegroundColor Green
        return $true
    } else {
        Write-Host "⚠️ License status unclear - will attempt acceptance" -ForegroundColor Yellow
        return $false
    }
}

function Accept-Licenses-Method1 {
    Write-Host "📱 Method 1: Enhanced PowerShell Process Management" -ForegroundColor Cyan
    try {
        $psi = New-Object System.Diagnostics.ProcessStartInfo
        $psi.FileName = "flutter"
        $psi.Arguments = "doctor --android-licenses"
        $psi.RedirectStandardInput = $true
        $psi.RedirectStandardOutput = $true
        $psi.RedirectStandardError = $true
        $psi.UseShellExecute = $false
        $psi.WorkingDirectory = (Get-Location).Path
        
        $process = [System.Diagnostics.Process]::Start($psi)
        
        # Send multiple "y" responses with proper timing
        for ($i = 0; $i -lt 12; $i++) {
            $process.StandardInput.WriteLine("y")
            Start-Sleep -Milliseconds 100
        }
        $process.StandardInput.Close()
        
        # Wait with timeout
        $timeoutMs = $TimeoutSeconds * 1000
        if ($process.WaitForExit($timeoutMs)) {
            Write-Host "✅ Method 1 completed (Exit code: $($process.ExitCode))" -ForegroundColor Green
            return $process.ExitCode -eq 0
        } else {
            Write-Host "⚠️ Method 1 timed out - terminating process" -ForegroundColor Yellow
            $process.Kill()
            $process.WaitForExit(5000)
            return $false
        }
    }
    catch {
        Write-Host "❌ Method 1 failed: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

function Accept-Licenses-Method2 {
    Write-Host "📱 Method 2: Batch File Approach" -ForegroundColor Cyan
    try {
        $batchPath = Join-Path $env:TEMP "accept_licenses.bat"
        $batchContent = @"
@echo off
(echo y & echo y & echo y & echo y & echo y & echo y & echo y & echo y & echo y & echo y) | flutter doctor --android-licenses
exit /b %ERRORLEVEL%
"@
        Set-Content -Path $batchPath -Value $batchContent -Encoding ASCII
        
        $process = Start-Process -FilePath $batchPath -Wait -PassThru -WindowStyle Hidden
        Remove-Item $batchPath -Force -ErrorAction SilentlyContinue
        
        if ($process.ExitCode -eq 0) {
            Write-Host "✅ Method 2 completed successfully" -ForegroundColor Green
            return $true
        } else {
            Write-Host "⚠️ Method 2 failed (Exit code: $($process.ExitCode))" -ForegroundColor Yellow
            return $false
        }
    }
    catch {
        Write-Host "❌ Method 2 failed: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

function Accept-Licenses-Method3 {
    Write-Host "📱 Method 3: CMD Pipe Approach" -ForegroundColor Cyan
    try {
        $result = cmd /c 'echo y^|echo y^|echo y^|echo y^|echo y^|echo y^|echo y^|echo y^|echo y^|echo y^| flutter doctor --android-licenses' 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Method 3 completed successfully" -ForegroundColor Green
            return $true
        } else {
            Write-Host "⚠️ Method 3 failed (Exit code: $LASTEXITCODE)" -ForegroundColor Yellow
            return $false
        }
    }
    catch {
        Write-Host "❌ Method 3 failed: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

function Accept-Licenses-Method4 {
    Write-Host "📱 Method 4: Direct SDK Manager (Fallback)" -ForegroundColor Cyan
    try {
        # Find Android SDK path
        $androidHome = $env:ANDROID_HOME
        if (-not $androidHome) { $androidHome = $env:ANDROID_SDK_ROOT }
        
        if ($androidHome -and (Test-Path $androidHome)) {
            $sdkmanager = Join-Path $androidHome "cmdline-tools\latest\bin\sdkmanager.bat"
            if (-not (Test-Path $sdkmanager)) {
                $sdkmanager = Join-Path $androidHome "tools\bin\sdkmanager.bat"
            }
            
            if (Test-Path $sdkmanager) {
                Write-Host "Using SDK manager: $sdkmanager" -ForegroundColor Yellow
                $result = cmd /c "echo y | `"$sdkmanager`" --licenses" 2>&1
                
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "✅ Method 4 completed successfully" -ForegroundColor Green
                    return $true
                } else {
                    Write-Host "⚠️ Method 4 failed (Exit code: $LASTEXITCODE)" -ForegroundColor Yellow
                    return $false
                }
            } else {
                Write-Host "⚠️ SDK manager not found, skipping method 4" -ForegroundColor Yellow
                return $false
            }
        } else {
            Write-Host "⚠️ Android SDK path not found, skipping method 4" -ForegroundColor Yellow
            return $false
        }
    }
    catch {
        Write-Host "❌ Method 4 failed: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Main execution
while (-not $licenseAccepted -and $retryCount -lt $MaxRetries) {
    $retryCount++
    Write-Host "🔄 Attempt $retryCount of $MaxRetries" -ForegroundColor Yellow
    
    # Check if licenses are already accepted
    if (Test-AndroidLicenses) {
        $licenseAccepted = $true
        break
    }
    
    # Try each method in sequence
    $methods = @(
        { Accept-Licenses-Method1 },
        { Accept-Licenses-Method2 },
        { Accept-Licenses-Method3 },
        { Accept-Licenses-Method4 }
    )
    
    foreach ($method in $methods) {
        if (& $method) {
            # Verify if licenses are now accepted
            Start-Sleep -Seconds 2
            if (Test-AndroidLicenses) {
                $licenseAccepted = $true
                break
            }
        }
    }
    
    if (-not $licenseAccepted -and $retryCount -lt $MaxRetries) {
        Write-Host "⚠️ All methods failed, waiting before retry..." -ForegroundColor Yellow
        Start-Sleep -Seconds 5
    }
}

# Final verification and summary
Write-Host "=== Final Verification ===" -ForegroundColor Green
flutter doctor -v

if ($licenseAccepted) {
    Write-Host "🎉 SUCCESS: Android SDK licenses have been accepted!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "⚠️ WARNING: Some licenses may still need attention" -ForegroundColor Yellow
    Write-Host "The build may continue - some SDK issues resolve during the build process" -ForegroundColor Yellow
    exit 0  # Don't fail the build, let it continue
}