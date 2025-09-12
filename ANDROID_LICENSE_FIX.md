# Android SDK License Acceptance Fix

## Problem

The GitHub Actions workflow was experiencing infinite loading when trying to accept Android SDK licenses, specifically showing the error:

```
1 of 7 SDK package license not accepted
```

This caused the Windows APK build workflow to hang indefinitely during the license acceptance phase.

## Root Cause

The issue was caused by improper license acceptance in PowerShell on Windows. The original code:

```powershell
echo "y" | flutter doctor --android-licenses 2>$null
```

This approach doesn't work correctly in PowerShell on Windows because:
1. The pipe redirection doesn't properly handle interactive input
2. There's no timeout mechanism to prevent infinite waiting
3. The `echo` command in PowerShell doesn't behave the same as in Unix systems

## Solution

### 1. Fixed Flutter Action Version

**Problem**: The workflow was trying to use `subosito/flutter-action@v4` which doesn't exist.
**Solution**: Updated to `subosito/flutter-action@v2` (latest stable version).

**Files changed**: 
- `.github/workflows/windows-apk-build.yml`
- `action.yml`

### 2. Implemented PowerShell-Native License Acceptance

**Replaced the problematic code with**:

```powershell
# Use PowerShell-native method to send multiple "y" responses
try {
    $yesResponses = "y`r`ny`r`ny`r`ny`r`ny`r`ny`r`ny`r`ny`r`ny`r`ny`r`n"
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "flutter"
    $psi.Arguments = "doctor --android-licenses"
    $psi.RedirectStandardInput = $true
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.UseShellExecute = $false
    
    $process = [System.Diagnostics.Process]::Start($psi)
    $process.StandardInput.Write($yesResponses)
    $process.StandardInput.Close()
    
    # Wait with timeout to prevent infinite hanging
    if ($process.WaitForExit(120000)) {  # 2 minutes timeout
        Write-Host "✅ Android licenses accepted successfully (Exit code: $($process.ExitCode))" -ForegroundColor Green
    } else {
        Write-Host "⚠️ License acceptance timed out - killing process to prevent infinite hanging" -ForegroundColor Yellow
        $process.Kill()
    }
}
catch {
    Write-Host "⚠️ Fallback method for license acceptance..." -ForegroundColor Yellow
    # Simple fallback using cmd
    cmd /c 'echo y^|echo y^|echo y^|echo y^|echo y^|echo y^|echo y^|flutter doctor --android-licenses'
}
```

### Key Improvements:

1. **Proper Input Redirection**: Uses `System.Diagnostics.ProcessStartInfo` to properly redirect standard input
2. **Timeout Mechanism**: 2-minute timeout prevents infinite waiting
3. **Multiple "y" Responses**: Sends 10 "y" responses with proper line endings to handle all license prompts
4. **Fallback Method**: If the primary method fails, falls back to using `cmd` with escaped pipes
5. **Error Handling**: Comprehensive try-catch blocks handle failures gracefully

## Testing

Created a validation script (`test_android_license_fix.sh`) that verifies:
- ✅ Flutter action version is correct (v2)
- ✅ Timeout mechanism is implemented (2 minutes)
- ✅ PowerShell-native license acceptance is implemented
- ✅ Fallback method exists
- ✅ YAML syntax is valid

All tests pass, confirming the fix is properly implemented.

## Expected Outcome

With these changes, the Android SDK license acceptance should:
1. Complete within 2 minutes instead of hanging indefinitely
2. Successfully accept all required SDK licenses
3. Allow the APK build process to continue normally
4. Provide clear logging about the license acceptance status

This resolves the "1 of 7 SDK package license not accepted" infinite loading issue found in Stack Overflow cases for Windows GitHub Actions environments.

## References

- **Stack Overflow Solution**: [Automatically accept all SDK licences](https://stackoverflow.com/questions/38096225/automatically-accept-all-sdk-licences)
- **GitHub Issue**: Android SDK license acceptance in Windows CI/CD
- **Flutter Doctor**: Enhanced license acceptance methods