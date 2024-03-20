Param(
    [Parameter(Mandatory=$true)]
    [string]$password,
    [Parameter(Mandatory=$true)]
    [string]$application,
    [Parameter(Mandatory=$false)]
    [string]$path = "~\.secrets.csv",
    [Parameter(Mandatory=$false)]
    [string]$username = ""
)

if (!(Test-Path $path)) {
    New-Item $path -ItemType File
    Out-File $path -InputObject "application,password,username"
}
[securestring]$encapplication = ConvertTo-SecureString $application.ToLower() -Force -AsPlainText
[securestring]$encpass = ConvertTo-SecureString $password -Force -AsPlainText
if($username -eq "") {
    [string]$encuser = ""
    #write-host "No username provided, leaving blank"
}
else {
    #Write-Host "Username provided, saving"
    [securestring]$encuser = ConvertTo-SecureString $username -Force -AsPlainText
    [string]$encuser = $encuser | ConvertFrom-SecureString
}
[string]$encapplication = $encapplication | ConvertFrom-SecureString
[string]$encpass = $encpass | ConvertFrom-SecureString
$NewLine = "{0},{1},{2}" -f $encapplication, $encpass,$encuser
$NewLine | Out-File $path -Append
#get-content $path | Out-Host