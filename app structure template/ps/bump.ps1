param(
    [string]$incrementType = "build" # Default increment type is 'build'
)

$config = Get-Content "config.json" -Encoding UTF8 | ConvertFrom-Json

[xml]$package = Get-Content "package\install.xml" -Encoding UTF8 
$versionNode = Select-Xml -Xml $package -XPath "//version"
$version = [version]$versionNode.Node.InnerText
#$newVersion = [version]::new($version.Major, $version.Minor,$version.Build+1,  0)
switch ($incrementType) {
    "build" {
        $newVersion = [version]::new($version.Major, $version.Minor, $version.Build + 1, 0)
    }
    "minor" {
        $newVersion = [version]::new($version.Major, $version.Minor + 1, 0, 0)
    }
    default {
        throw "Invalid increment type. Use 'build' or 'minor'."
    }
}
$versionNode.Node.InnerText = $newVersion
$package.Save("package\install.xml")

[xml]$package = Get-Content $config.bundleName
$versionNode = Select-Xml -Xml $package -XPath "//version"
$versionNode.Node.InnerText = $newVersion
$package.Save($config.bundleName)
$newVersion