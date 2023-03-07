function Start-NetworkDetective {

    [CmdletBinding()]
    [OutputType([String])]
    param(
        [Parameter(Position = 0, mandatory = $true)]
        [String]$FileName,
        [Parameter(Position = 1, mandatory = $true)]
        [String]$Username,
        [Parameter(Position = 2, mandatory = $true)]
        [String]$Password
    )
    
    $Directory = "C:\htdata\networkdetective"
    if (-not (Test-Path $Directory)) {
        New-Item -ItemType Directory -Path $Directory | Out-Null
    }

    $URL = "https://s3.amazonaws.com/networkdetective/download/NetworkDetectiveComputerDataCollector.exe"
    $Outfile = "$Directory\NDInstall.exe"
    Invoke-WebRequest -Uri $URL -OutFile $Outfile
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($Outfile, $Directory)
    
    $IPAddress = ((gwmi Win32_NetworkAdapterConfiguration | ? {$_.IPAddress -ne $null}).IPAddress)
    $IPString = $IPAddress -join ","
    $IPSubnet = $IPString.Substring(0, $IPString.LastIndexOf('.'))
    $IPRange = '{0}.1-{0}.254' -f $IPSubnet
    
    $ArgumentList = @()
    $ArgumentList += "-workdir $Directory" 
    $ArgumentList += " -outbase $FileName" 
    $ArgumentList += " -outdir $Directory"
    $ArgumentList += " -logfile ndfRun.log" 
    $ArgumentList += " -creduser $Username" 
    $ArgumentList += " -credspwd $Password" 
    $ArgumentList += " -eventlogs" 
    $ArgumentList += " -silent"
    $ArgumentList += " -local"

    # Full command list: http://support-nd.rapidfiretools.com/customer/portal/articles/1655368-network-detective-data-collector-command-line-options

    Start-Process -FilePath "$Directory\nddc.exe" -ArgumentList $ArgumentList -WindowStyle Hidden -Wait
    $FinalFile = Get-ChildItem -Path "$Directory\*" -Include *.cdf, *.ndf
    
}

$FileName = $env:computername
$Username = Read-Host "Enter Network Detective username"
$Password = Read-Host "Enter Network Detective password" -AsSecureString

Start-NetworkDetective -FileName $FileName -Username $Username -Password ([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)))
