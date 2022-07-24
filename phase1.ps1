<#
Powershell Install Script
John Leonard
#>

function Test-Administrator  
{  
    [OutputType([bool])]
    param()
    process {
        [Security.Principal.WindowsPrincipal]$user = [Security.Principal.WindowsIdentity]::GetCurrent();
        return $user.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator);
    }
}

if(-not (Test-Administrator))
{
    # TODO: define proper exit codes for the given errors 
    Write-Error "This script must be executed as Administrator.";
    exit 1;
}

# Install Powershell Certificate
Get-Certificate -Template 'VCU-PowershellCodeSigning' -CertStoreLocation "Cert:\currentuser\my"

# Set up important system environment variables
[Environment]::SetEnvironmentVariable("HOMEIPADDRESS",(get-netipaddress -interfacealias "Ethernet" -AddressFamily "IPv4").IPAddress,"Machine")

# Remove app execution alias from local path. This will prevent PYTHON from being overridden.
# ADD CODE HERE! $env:localappdata\Microsoft\WindowsApps

# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
# Reset environment
$Env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")

# Install VSCODE and packages
choco install -y vscode
# Reset environment path
$Env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
code --install-extension ms-vscode.powershell


choco install -y powershell-core --packageparameters '"/CleanUpPath"'
choco install -y git.install --params "/GitAndUnixToolsOnPath /WindowsTerminal/Editor:VisualStudioCode"
choco install -y 7zip
choco install -y microsoft-windows-terminal
choco install -y sqlserver-cmdlineutils
choco install -y sqlserver-odbcdriver
# Reset environment path
$Env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")

choco install -y visualstudio2019enterprise
choco install -y windows-sdk-11-version-21h2-all
choco install -y nodejs-lts
choco install -y openjdk11
choco install -y androidstudio
choco install -y jq
$Env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")

# Another round of tools
choco install -y lastpass
choco install -y evernote
choco install -y docker-desktop
$Env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")

# Make `refreshenv` available right away, by defining the $env:ChocolateyInstall
# variable and importing the Chocolatey profile module.
# Note: Using `. $PROFILE` instead *may* work, but isn't guaranteed to.
$env:ChocolateyInstall = Convert-Path "$((Get-Command choco).Path)\..\.."   
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"

# refreshenv is now an alias for Update-SessionEnvironment
# (rather than invoking refreshenv.cmd, the *batch file* for use with cmd.exe)
# This should make git.exe accessible via the refreshed $env:PATH, so that it
# can be called by name only.
refreshenv

# download local setup scripts using GIT and add to path.
if (-not (Get-Command "git.exe" -ErrorAction silent)){
    write-error "GIT.EXE not installed on path.  Restart command shell."
}
if (-not (Test-Path "$env:userprofile\Projects")){
    new-item  $env:userprofile\Projects -ItemType Directory
}
cd $env:userprofile\Projects
git clone https://github.com/lowkeylabs/local-setup.git

# Add setup path to top of current system path and reset local path
$OLDPATH = [System.Environment]::GetEnvironmentVariable('PATH','machine')
$NEWPATH = "$env:userprofile\Projects\local-setup;" + "$OLDPATH"
[Environment]::SetEnvironmentVariable("PATH", "$NEWPATH", "Machine")
$Env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")

# Install pywin, needs to be codesigned
choco install -y pyenv-win
$Env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
cd $env:userprofile\.pyenv\pyenv-win\bin
codesign pyenv.ps1

# refreshenv is from Chocolatey
#
refreshenv

# Install R and RStudio. May need to be expanded to install particular libraryies
choco install -y r.project
choco install -y r.studio
choco install -y rtools
choco install -y miktex


## Phase 2 stuff. The shell needs to be stopped and restarted to capture other non-Path fixes.
#
### Note - python "App execution alias" needs to be turned off or python won't work
pyenv install 3.9.6
pyenv global 3.9.6
(Invoke-WebRequest -Uri https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py -UseBasicParsing).Content | python -

# Set up important system environment variables
[Environment]::SetEnvironmentVariable("HOMEIPADDRESS",(get-netipaddress -interfacealias "Ethernet" -AddressFamily "IPv4").IPAddress,"Machine")


# Other setup tasks
# 1. Create SSH key in $Env:UserProfile\.ssh
# 1. Install SSH public key on https://scm.vcu.edu/plugins/servlet/ssh/account/keys
#       Label the key <jdleonard>@<machine name>,  e.g., jdleonard@EGR-JL-RAK1-VM3
# 1. Open Visual Studio 2019, add SSIS data tools from "Extensions | MarketPlace"
# 1. Ensure Powershell 7 path scripts all work.
# 1. Add ODBC system connector for EGRPROD
# 1. Install lots of packages for VSCODE



# SIG # Begin signature block
# MIIcFwYJKoZIhvcNAQcCoIIcCDCCHAQCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU7pHcUp5wteoX4YZkon9S1GYT
# TW2gggsoMIIFZjCCBE6gAwIBAgITdwACwrL5F2tX4uCXugAAAALCsjANBgkqhkiG
# 9w0BAQsFADBxMRMwEQYKCZImiZPyLGQBGRYDZWR1MRMwEQYKCZImiZPyLGQBGRYD
# dmN1MRMwEQYKCZImiZPyLGQBGRYDYWRwMRQwEgYKCZImiZPyLGQBGRYEUkFNUzEa
# MBgGA1UEAxMRVkNVIEluZm9TZWMgU3ViQ0EwHhcNMjEwOTIwMTQzMjQ2WhcNMjIw
# OTIwMTQzMjQ2WjCBrTETMBEGCgmSJomT8ixkARkWA2VkdTETMBEGCgmSJomT8ixk
# ARkWA3ZjdTETMBEGCgmSJomT8ixkARkWA2FkcDEUMBIGCgmSJomT8ixkARkWBFJB
# TVMxHjAcBgNVBAsTFVNjaG9vbCBvZiBFbmdpbmVlcmluZzEOMAwGA1UECxMFVXNl
# cnMxEjAQBgNVBAsTCUVtcGxveWVlczESMBAGA1UEAxMJamRsZW9uYXJkMIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1H/K+BJOCnI+JluymsG4etDGqhKI
# oZdhqlGyGonAef9lb8Uz/k3X4jWwCVSfzJfiW9xOxAabzcM7QURFEi4ouNNsap/i
# Y5fKbulo+9I8HqisFaEYtSH1hs80pKwd6lTwidjn8b0EKvflK5RkEHxNwtG+dw8c
# cGf/9fPQkkJQS069322JzyoGvKO7uXcjQdhSNW4vXoDKeHvs3Pa0BOlDeZl61Srk
# NGhiQWfG4lKQ1n4s0H4a1B0jijXsafcnJD8rx6QI9WBqIZGBNBYVap3z1wlcu+WE
# Aa4fiZbmiAsSv5TGseOUu/nwtS5CB/CeVv1cXrEYzFVJxN62EV/DqlC7sQIDAQAB
# o4IBuDCCAbQwPgYJKwYBBAGCNxUHBDEwLwYnKwYBBAGCNxUIhY6ucoScvQmH0Ysk
# ham6S4KI0UiBeYO+iG+FsIsBAgFkAgEFMBMGA1UdJQQMMAoGCCsGAQUFBwMDMA4G
# A1UdDwEB/wQEAwIHgDAbBgkrBgEEAYI3FQoEDjAMMAoGCCsGAQUFBwMDMCwGA1Ud
# EQQlMCOgIQYKKwYBBAGCNxQCA6ATDBFqZGxlb25hcmRAdmN1LmVkdTAdBgNVHQ4E
# FgQULq8qdy2Xs8+J+ZHuwBIPXKhBdWswHwYDVR0jBBgwFoAUFT0jWfVkwjQmSxlv
# Q/DzjlXcMiEwSAYDVR0fBEEwPzA9oDugOYY3aHR0cDovL3BraS52Y3UuZWR1L0Nl
# cnRFbnJvbGwvVkNVJTIwSW5mb1NlYyUyMFN1YkNBLmNybDB4BggrBgEFBQcBAQRs
# MGowQwYIKwYBBQUHMAKGN2h0dHA6Ly9wa2kudmN1LmVkdS9DZXJ0RW5yb2xsL1ZD
# VSUyMEluZm9TZWMlMjBTdWJDQS5jcnQwIwYIKwYBBQUHMAGGF2h0dHA6Ly9wa2ku
# dmN1LmVkdS9vY3NwMA0GCSqGSIb3DQEBCwUAA4IBAQBIbaubbK77AsaEgbVTbbP3
# B9Zm9U9sdiVxm5HnXYW6dYRWS2+x9HbuoFi+AoCK/fWhpkF2nkVS6lHfZnfstx0x
# 1yuJq31Tm+a5PniUt4Me+teCEPjMaulUqdWNvLsAHkCtvbmXYxSiaMsoe1DcrO3Z
# I3MqY/eHxzNf7dbBgPjkTfWzxE9gZpfQ0Ul7+bk1nYgbVDMbxcDSpzcdGxZXZcJR
# m+oK1j6E5FjMwzVqbEAUGGJ8htwV3eeHUKU18h6qTD2yIyttPdER0HFv5rbU0iQ8
# gwUcwS6ZiFaphZiKmS+OGIKd2k89kolieihFEByq0+5iM4mLcATkedhNtWl6eurb
# MIIFujCCA6KgAwIBAgITHwAAAAbNiK9rbBvq+AAAAAAABjANBgkqhkiG9w0BAQ0F
# ADAWMRQwEgYDVQQDEwtWQ1UgUm9vdCBDQTAeFw0xNzA5MTMxNjI0NTVaFw0yNzA5
# MTMxNjM0NTVaMHExEzARBgoJkiaJk/IsZAEZFgNlZHUxEzARBgoJkiaJk/IsZAEZ
# FgN2Y3UxEzARBgoJkiaJk/IsZAEZFgNhZHAxFDASBgoJkiaJk/IsZAEZFgRSQU1T
# MRowGAYDVQQDExFWQ1UgSW5mb1NlYyBTdWJDQTCCASIwDQYJKoZIhvcNAQEBBQAD
# ggEPADCCAQoCggEBAMBzjWLmzh8TmxKSY0548f4FwBnBd5s5l3Vkbv7Eob+7aFXx
# gAC23XLAOhtUeGiISjkhpu0R/2paZbhJ3ezOzcKQ7n3bJw4GYbZDrfEyMvCg2wSi
# vZ0UvpxUv2h5n7tR/i/bdkxEk3/jYja1N9X/U24s5fqdlkjPUJJ1hmShNi1epz/a
# fOFDI+hXiKIpwaE1JaooJhghcKkh700Z9hT4vKQ4rmiApb7O3/iNczbj+B1wkeLn
# ecGt/GGUdUPRW11q4/Amjfz7v0lxq6iAgnpHi3ntBWu2zsy3cGCHsEDpEvBUJCpq
# ma/zbI8scKS+MQuy8wj5sjRjioQwzi49Kqahz3MCAwEAAaOCAaQwggGgMBAGCSsG
# AQQBgjcVAQQDAgEAMB0GA1UdDgQWBBQVPSNZ9WTCNCZLGW9D8POOVdwyITB6BgNV
# HSAEczBxMG8GBysGAQQB0RAwZDA6BggrBgEFBQcCAjAuHiwATABlAGcAYQBsACAA
# UABvAGwAaQBjAHkAIABTAHQAYQB0AGUAbQBlAG4AdDAmBggrBgEFBQcCARYaaHR0
# cDovL3BraS52Y3UuZWR1L2Nwcy50eHQwGQYJKwYBBAGCNxQCBAweCgBTAHUAYgBD
# AEEwCwYDVR0PBAQDAgGGMA8GA1UdEwEB/wQFMAMBAf8wHwYDVR0jBBgwFoAUk4PN
# ShVEeUceCSFYZPM8uEbc71owQgYDVR0fBDswOTA3oDWgM4YxaHR0cDovL3BraS52
# Y3UuZWR1L2NlcnRlbnJvbGwvVkNVJTIwUm9vdCUyMENBLmNybDBTBggrBgEFBQcB
# AQRHMEUwQwYIKwYBBQUHMAKGN2h0dHA6Ly9wa2kudmN1LmVkdS9DZXJ0RW5yb2xs
# L0FMQlVTX1ZDVSUyMFJvb3QlMjBDQS5jcnQwDQYJKoZIhvcNAQENBQADggIBAFoS
# JfRjPLt2/AjScl1g0Oe9KYoYaVcJEe43buGEfGT1UE7wnN2wTztZibl8mO4f2elo
# +O1fM+3Hl9ESlQOsVW2pVrIUQ+ZW1CJ+bRVflLh9Pi6vSu+6gguNAZFp1W5czWli
# 5jPJTXVPbP5Hz30BmnrBdUKlL/fQkMhGmOhZpfC1bUTd6gGALU1/GmfB1vwU+KAU
# 4dWHiCEQWDvVnGcYsZfPmJpAtr4t6XLFrFeYuqCr8MNHlmm5C+1AxxlPaSiQRp3l
# QJaoQthLAU/SJ6Xqobp+cvxYOkkMUL9zvbZ58wQcTwekVIAH8FQlv1FjBkxK0TGn
# wkbXWrfGSVAnGBtxPkmtfQm25zeyhQOzjZSNOHJUIvUrWZlIvQaItsd3ooO2yJh1
# XmuR7UY2QkwHvcie62IXIe66vwASHpMM57lnykxrDpxXAalBx5vU3hj9NOj1u6Wh
# 6GxIFzLnmtqTc/scZLWuzQe1T84WlDRI7gu9KcRO2SLm+ncBMg7nbeJhlq4i1Wwz
# wKvN6zGBaHkApd8ctGV0l1lNAqycaO87S3PZxzxTB/UwwbJcUPvWRC+BDdKSxJ1a
# HyXHs0Ce3s0vydH1PeG53Cdog9BCEluOFsIceNf9OPMTMaHYXvzzH37nk4UAeguS
# 5mDv6sqmzI2ohVbIK1f4cnFzM5Z51varyy2ettzXMYIQWTCCEFUCAQEwgYgwcTET
# MBEGCgmSJomT8ixkARkWA2VkdTETMBEGCgmSJomT8ixkARkWA3ZjdTETMBEGCgmS
# JomT8ixkARkWA2FkcDEUMBIGCgmSJomT8ixkARkWBFJBTVMxGjAYBgNVBAMTEVZD
# VSBJbmZvU2VjIFN1YkNBAhN3AALCsvkXa1fi4Je6AAAAAsKyMAkGBSsOAwIaBQCg
# eDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkGCSqGSIb3DQEJAzEMBgorBgEE
# AYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMGCSqGSIb3DQEJ
# BDEWBBTWWadKrDbWAiqKn6catarQMcmFjjANBgkqhkiG9w0BAQEFAASCAQAMnRrl
# UzRr8uBWi6IW1erKAwiDziJ9Pgq2mEWvmONKBPbrD2vHdv876+BwYNb6TOzVSLtc
# syT4U7DDFPiV3Bp0pD2KmZixHtbJN4dqCbJnqlOxVxGKXX+WpMedkp0nB8GOE6Ka
# nB94Uxe9rsdlkYy0mX/Wi6djjbYc93SGjERGw/F3XIgo2I/AzCSCpjUshObTvrti
# 1qRK0jg4gtsyeUGEOnH1Afhit7+EUVCttYpbDzqtR/TBfZqALZJC4PYHMpyNLmv6
# oTIfrNQ51pRH03QooKuUmNCNxVMd2y/ML+2s0FNuE6a2TW5wdF/zmIdWebe6vM/Z
# 8NGI5WWToHc06QlKoYIOKzCCDicGCisGAQQBgjcDAwExgg4XMIIOEwYJKoZIhvcN
# AQcCoIIOBDCCDgACAQMxDTALBglghkgBZQMEAgEwgf4GCyqGSIb3DQEJEAEEoIHu
# BIHrMIHoAgEBBgtghkgBhvhFAQcXAzAhMAkGBSsOAwIaBQAEFD3O14RV2IBRTZYE
# li1jYlmsTsE1AhRMBo1tmD26AdKDM1D3fsl+duHUAhgPMjAyMjA3MjIxMzEyMDJa
# MAMCAR6ggYakgYMwgYAxCzAJBgNVBAYTAlVTMR0wGwYDVQQKExRTeW1hbnRlYyBD
# b3Jwb3JhdGlvbjEfMB0GA1UECxMWU3ltYW50ZWMgVHJ1c3QgTmV0d29yazExMC8G
# A1UEAxMoU3ltYW50ZWMgU0hBMjU2IFRpbWVTdGFtcGluZyBTaWduZXIgLSBHM6CC
# CoswggU4MIIEIKADAgECAhB7BbHUSWhRRPfJidKcGZ0SMA0GCSqGSIb3DQEBCwUA
# MIG9MQswCQYDVQQGEwJVUzEXMBUGA1UEChMOVmVyaVNpZ24sIEluYy4xHzAdBgNV
# BAsTFlZlcmlTaWduIFRydXN0IE5ldHdvcmsxOjA4BgNVBAsTMShjKSAyMDA4IFZl
# cmlTaWduLCBJbmMuIC0gRm9yIGF1dGhvcml6ZWQgdXNlIG9ubHkxODA2BgNVBAMT
# L1ZlcmlTaWduIFVuaXZlcnNhbCBSb290IENlcnRpZmljYXRpb24gQXV0aG9yaXR5
# MB4XDTE2MDExMjAwMDAwMFoXDTMxMDExMTIzNTk1OVowdzELMAkGA1UEBhMCVVMx
# HTAbBgNVBAoTFFN5bWFudGVjIENvcnBvcmF0aW9uMR8wHQYDVQQLExZTeW1hbnRl
# YyBUcnVzdCBOZXR3b3JrMSgwJgYDVQQDEx9TeW1hbnRlYyBTSEEyNTYgVGltZVN0
# YW1waW5nIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAu1mdWVVP
# nYxyXRqBoutV87ABrTxxrDKPBWuGmicAMpdqTclkFEspu8LZKbku7GOz4c8/C1aQ
# +GIbfuumB+Lef15tQDjUkQbnQXx5HMvLrRu/2JWR8/DubPitljkuf8EnuHg5xYSl
# 7e2vh47Ojcdt6tKYtTofHjmdw/SaqPSE4cTRfHHGBim0P+SDDSbDewg+TfkKtzNJ
# /8o71PWym0vhiJka9cDpMxTW38eA25Hu/rySV3J39M2ozP4J9ZM3vpWIasXc9LFL
# 1M7oCZFftYR5NYp4rBkyjyPBMkEbWQ6pPrHM+dYr77fY5NUdbRE6kvaTyZzjSO67
# Uw7UNpeGeMWhNwIDAQABo4IBdzCCAXMwDgYDVR0PAQH/BAQDAgEGMBIGA1UdEwEB
# /wQIMAYBAf8CAQAwZgYDVR0gBF8wXTBbBgtghkgBhvhFAQcXAzBMMCMGCCsGAQUF
# BwIBFhdodHRwczovL2Quc3ltY2IuY29tL2NwczAlBggrBgEFBQcCAjAZGhdodHRw
# czovL2Quc3ltY2IuY29tL3JwYTAuBggrBgEFBQcBAQQiMCAwHgYIKwYBBQUHMAGG
# Emh0dHA6Ly9zLnN5bWNkLmNvbTA2BgNVHR8ELzAtMCugKaAnhiVodHRwOi8vcy5z
# eW1jYi5jb20vdW5pdmVyc2FsLXJvb3QuY3JsMBMGA1UdJQQMMAoGCCsGAQUFBwMI
# MCgGA1UdEQQhMB+kHTAbMRkwFwYDVQQDExBUaW1lU3RhbXAtMjA0OC0zMB0GA1Ud
# DgQWBBSvY9bKo06FcuCnvEHzKaI4f4B1YjAfBgNVHSMEGDAWgBS2d/ppSEefUxLV
# wuoHMnYH0ZcHGTANBgkqhkiG9w0BAQsFAAOCAQEAdeqwLdU0GVwyRf4O4dRPpnjB
# b9fq3dxP86HIgYj3p48V5kApreZd9KLZVmSEcTAq3R5hF2YgVgaYGY1dcfL4l7wJ
# /RyRR8ni6I0D+8yQL9YKbE4z7Na0k8hMkGNIOUAhxN3WbomYPLWYl+ipBrcJyY9T
# V0GQL+EeTU7cyhB4bEJu8LbF+GFcUvVO9muN90p6vvPN/QPX2fYDqA/jU/cKdezG
# dS6qZoUEmbf4Blfhxg726K/a7JsYH6q54zoAv86KlMsB257HOLsPUqvR45QDYApN
# oP4nbRQy/D+XQOG/mYnb5DkUvdrk08PqK1qzlVhVBH3HmuwjA42FKtL/rqlhgTCC
# BUswggQzoAMCAQICEHvU5a+6zAc/oQEjBCJBTRIwDQYJKoZIhvcNAQELBQAwdzEL
# MAkGA1UEBhMCVVMxHTAbBgNVBAoTFFN5bWFudGVjIENvcnBvcmF0aW9uMR8wHQYD
# VQQLExZTeW1hbnRlYyBUcnVzdCBOZXR3b3JrMSgwJgYDVQQDEx9TeW1hbnRlYyBT
# SEEyNTYgVGltZVN0YW1waW5nIENBMB4XDTE3MTIyMzAwMDAwMFoXDTI5MDMyMjIz
# NTk1OVowgYAxCzAJBgNVBAYTAlVTMR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3Jh
# dGlvbjEfMB0GA1UECxMWU3ltYW50ZWMgVHJ1c3QgTmV0d29yazExMC8GA1UEAxMo
# U3ltYW50ZWMgU0hBMjU2IFRpbWVTdGFtcGluZyBTaWduZXIgLSBHMzCCASIwDQYJ
# KoZIhvcNAQEBBQADggEPADCCAQoCggEBAK8Oiqr43L9pe1QXcUcJvY08gfh0FXdn
# kJz93k4Cnkt29uU2PmXVJCBtMPndHYPpPydKM05tForkjUCNIqq+pwsb0ge2PLUa
# JCj4G3JRPcgJiCYIOvn6QyN1R3AMs19bjwgdckhXZU2vAjxA9/TdMjiTP+UspvNZ
# I8uA3hNN+RDJqgoYbFVhV9HxAizEtavybCPSnw0PGWythWJp/U6FwYpSMatb2Ml0
# UuNXbCK/VX9vygarP0q3InZl7Ow28paVgSYs/buYqgE4068lQJsJU/ApV4VYXuqF
# SEEhh+XetNMmsntAU1h5jlIxBk2UA0XEzjwD7LcA8joixbRv5e+wipsCAwEAAaOC
# AccwggHDMAwGA1UdEwEB/wQCMAAwZgYDVR0gBF8wXTBbBgtghkgBhvhFAQcXAzBM
# MCMGCCsGAQUFBwIBFhdodHRwczovL2Quc3ltY2IuY29tL2NwczAlBggrBgEFBQcC
# AjAZGhdodHRwczovL2Quc3ltY2IuY29tL3JwYTBABgNVHR8EOTA3MDWgM6Axhi9o
# dHRwOi8vdHMtY3JsLndzLnN5bWFudGVjLmNvbS9zaGEyNTYtdHNzLWNhLmNybDAW
# BgNVHSUBAf8EDDAKBggrBgEFBQcDCDAOBgNVHQ8BAf8EBAMCB4AwdwYIKwYBBQUH
# AQEEazBpMCoGCCsGAQUFBzABhh5odHRwOi8vdHMtb2NzcC53cy5zeW1hbnRlYy5j
# b20wOwYIKwYBBQUHMAKGL2h0dHA6Ly90cy1haWEud3Muc3ltYW50ZWMuY29tL3No
# YTI1Ni10c3MtY2EuY2VyMCgGA1UdEQQhMB+kHTAbMRkwFwYDVQQDExBUaW1lU3Rh
# bXAtMjA0OC02MB0GA1UdDgQWBBSlEwGpn4XMG24WHl87Map5NgB7HTAfBgNVHSME
# GDAWgBSvY9bKo06FcuCnvEHzKaI4f4B1YjANBgkqhkiG9w0BAQsFAAOCAQEARp6v
# 8LiiX6KZSM+oJ0shzbK5pnJwYy/jVSl7OUZO535lBliLvFeKkg0I2BC6NiT6Cnv7
# O9Niv0qUFeaC24pUbf8o/mfPcT/mMwnZolkQ9B5K/mXM3tRr41IpdQBKK6XMy5vo
# qU33tBdZkkHDtz+G5vbAf0Q8RlwXWuOkO9VpJtUhfeGAZ35irLdOLhWa5Zwjr1sR
# 6nGpQfkNeTipoQ3PtLHaPpp6xyLFdM3fRwmGxPyRJbIblumFCOjd6nRgbmClVnoN
# yERY3Ob5SBSe5b/eAL13sZgUchQk38cRLB8AP8NLFMZnHMweBqOQX1xUiz7jM1uC
# D8W3hgJOcZ/pZkU/djGCAlowggJWAgEBMIGLMHcxCzAJBgNVBAYTAlVTMR0wGwYD
# VQQKExRTeW1hbnRlYyBDb3Jwb3JhdGlvbjEfMB0GA1UECxMWU3ltYW50ZWMgVHJ1
# c3QgTmV0d29yazEoMCYGA1UEAxMfU3ltYW50ZWMgU0hBMjU2IFRpbWVTdGFtcGlu
# ZyBDQQIQe9Tlr7rMBz+hASMEIkFNEjALBglghkgBZQMEAgGggaQwGgYJKoZIhvcN
# AQkDMQ0GCyqGSIb3DQEJEAEEMBwGCSqGSIb3DQEJBTEPFw0yMjA3MjIxMzEyMDJa
# MC8GCSqGSIb3DQEJBDEiBCCYEZOkTk6WowK7aFVyOmUrOIQg8rCi/TwQx6Jv72/5
# IjA3BgsqhkiG9w0BCRACLzEoMCYwJDAiBCDEdM52AH0COU4NpeTefBTGgPniggE8
# /vZT7123H99h+DALBgkqhkiG9w0BAQEEggEAmBfK+BUn35+eV6DDjSvAtsgaRkL3
# RY2Lt+XDFMTB8hIq7SsfzYkaf0I04fB0yDDsZAIkux+llPbNjUsYPEqTMdF8eOb/
# nc6JhqApqMeRT3Owm8skDdHSGBDNu/vCWyOMA6hjpAx75JyJWfnhXRXxo6LS3CHc
# A+UgL2tbRTaNExtjicTiM2fmGVX7wVbsiphbGCDXTHEnmn3A4ORR8GjAnEBXwgrl
# kq/qblNrvXk9Ywj4RyIM1gSZeDNUnkK3f22txno5BfHJ7EnD3FYTPyfNgZU0NAI+
# /A/5f7sEn51Eux6+9g6lJW3iN5GhGzaHOH7DCyjABlmFbMPWNM3fJiga8w==
# SIG # End signature block
