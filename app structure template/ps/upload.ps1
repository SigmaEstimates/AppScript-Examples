param(
    [string]$uploadType = "beta" # Default upload type is beta
)

$config = Get-Content "config.json" | ConvertFrom-Json
$webclient = New-Object System.Net.WebClient 
$webclient.Credentials = New-Object System.Net.NetworkCredential($config.ftphost, $config.ftppasswd)  
$filename = $config.productKey+".sigmapackage"
switch ($uploadType) {
    "beta" {
       $webclient.UploadFile($config.ftppath_beta+"/"+$filename, "package\" + $filename) 
	   Write-Host ($config.httppath_beta+"/"+$filename)
    }
    "release" {
        $webclient.UploadFile($config.ftppath_release+"/"+$filename, "package\" + $filename) 
    }
    default {
        throw "Invalid upload type. Use 'beta' or 'release'."
    }
}

