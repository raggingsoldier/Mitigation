function Import-ActiveDirectory
{
<#
.SYNOPSIS
ADModule Script which could import ActiveDirectory module without writing DLL to disk.

.DESCRIPTION
This script will import AD modules without writing DLL to disk. To use your own DLL byte array use the below commands:

PS > [byte[]] $DLL = Get-Content -Encoding byte -path C:\ADModule\Microsoft.ActiveDirectory.Management.dll
PS > [System.IO.File]::WriteAllLines(C:\ADModule\dll.txt, ([string]$DLL))

It is always advised to load your own DLL ;)

.PARAMETER ActiveDirectoryModule
Path to the ActiveDirectoryModule DLL.

.EXAMPLE
PS > Import-ActiveDirectory

Use the above command to load the DLL byte array already hard-coded in the script. 

.EXAMPLE
PS > Import-ActiveDirectory -ActiveDirectoryModule C:\ADModule\Microsoft.ActiveDirectory.Management.dll

Use the above path to load the Microsoft.ActiveDirectory.Management.dll from disk.

.LINK
https://github.com/samratashok/ADModule/pull/1
https://github.com/samratashok/ADModule
#>  

#>
    [CmdletBinding()] Param(
        [Parameter(Position = 0, Mandatory = $False)]
        [String]
        $ActiveDirectoryModule
    )

    $retVal = Get-Module -ListAvailable | where { $_.Name -eq "ActiveDirectory" }
    if ($retVal) {
        Import-Module ActiveDirectory
    } else {
        if($ActiveDirectoryModule) {
            $path = Resolve-Path $ActiveDirectoryModule
            $DllBytes = [IO.File]::ReadAllBytes($path)
        } else {
            [Byte[]] $DllBytes = $Data -split ' '
        }
        
        $Assembly = [System.Reflection.Assembly]::Load($DllBytes)
        Import-Module -Assembly $Assembly
    }
}

$DllFromGitHub = Invoke-WebRequest https://raw.githubusercontent.com/raggingsoldier/Mitigation/main/Microsoft.ActiveDirectory.Management%201.dll

Import-ActiveDirectory -ActiveDirectoryModule Invoke-Expression $($DllFromGitHub.Content)