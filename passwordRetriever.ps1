param(
    [Parameter(Mandatory=$true)]
    [string]$application,
    [Parameter(Mandatory=$false)]
    [string]$path = "~\.secrets.csv",
    [Parameter(Mandatory=$false)]
    [string]$username = ""
)
$csv = Import-Csv $path
if ($username -ne ""){
    #Write-Host("Username provided, searching for username")
    #$encpassword = $csv | Where-Object { $_.application -eq $encapplication -and $_.username -eq $encuser }
    foreach ($row in $csv){
        $rowapplication = ConvertTo-SecureString $row.application
        $rowapplication = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($rowapplication))
        if ($row.username){    
            $rowusername = ConvertTo-SecureString $row.username
            $rowusername = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($rowusername))
            if ($rowapplication -eq $application -and $rowusername -eq $username){
                $encpassword = $row.password
                $password = ConvertTo-SecureString $encpassword
                $password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
                break
            }
    }
    }
    
} 
else{
    #Write-Host("No username provided, searching for password")
    #$encpassword = $csv | Where-Object { $_.application -eq $encapplication } | Select-Object -ExpandProperty password
    foreach ($row in $csv){
        $rowapplication = ConvertTo-SecureString $row.application
        $rowapplication = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($rowapplication))
        #Write-Host($rowapplication)
        if ($rowapplication -eq $application){
            #Write-Host("Found password")
            $password = ConvertTo-SecureString $row.password
            $password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
            #Write-Host $password
            break
        }
    }
}
if ($password){
    #Write-Host("Password found, returning")
    return $password
}
else{
    #Write-Host("Password not found, exiting")
    exit
}