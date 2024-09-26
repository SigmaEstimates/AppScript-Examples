call build.bat
powershell -ExecutionPolicy Bypass -File ps\upload.ps1 -uploadType "release"
pause