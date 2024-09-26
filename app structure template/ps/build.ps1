$config = Get-Content "config.json" -Encoding UTF8 | ConvertFrom-Json

[xml]$xmlContent = Get-Content "package\install.xml" -Encoding UTF8 
$xmlContent.'sigma.package.manifest'.id = $config.productKey
$xmlContent.'sigma.package.manifest'.name = $config.name
$xmlContent.'sigma.package.manifest'.description = $config.description
$xmlContent.Save("package\install.xml")

$bundleFileName = ".\"+$config.bundleName

Write-Host $bundleFileName

[xml]$xmlContent = Get-Content $bundleFileName -Encoding UTF8 
$xmlContent.'sigma.script.bundle'.name = $config.name
$xmlContent.'sigma.script.bundle'.description = $config.description
$xmlContent.'sigma.script.bundle'.ID = $config.productKey
$xmlContent.Save($bundleFileName)

$id = $config.productKey

# Return to the parent directory
Set-Location -Path ".\package"

# Delete .sigmapackage file if it exists
if (Test-Path -Path "$id.sigmapackage") {
    Remove-Item -Path "$id.sigmapackage"
}

# Compress files into .sigmapackage file using 7-Zip
& "C:\Program Files\7-Zip\7z.exe" a -tzip -r "$id.sigmapackage"

# Return to the parent directory
Set-Location -Path ".."

# Pause (wait for user input before closing)
Read-Host -Prompt "Press Enter to continue"
