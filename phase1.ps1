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
$descriptions = @{
    "EGR-JL-RAK1-SRV" = "Server main"
    "EGR-JL-RAK1-VM1" = "VM1-SQL platform"
    "EGR-JL-RAK1-VM2" = "VM2-Dev platform"
}
[Environment]::SetEnvironmentVariable("COMPUTERDESCRIPTION",$descriptions[$env:COMPUTERNAME],"Machine")

# Remove app execution alias folder from User Path. This will prevent PYTHON from being overridden.
$Remove = "$env:localappdata\Microsoft\WindowsApps"
$OldPath = [Environment]::GetEnvironmentVariable("PATH","User")
$NewPath = ($OldPath.Split(';') | Where-Object -FilterScript {$_ -ne $Remove}) -join ';'
[System.Environment]::SetEnvironmentVariable("PATH", "$NewPath", "User")


# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
# Reset environment
refreshenv


# Install VSCODE and packages
choco install -y vscode
# Reset environment path
$Env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
refreshenv
code --install-extension ms-vscode.powershell
code --install-extension yzhang.markdown-all-in-one
code --install-extension DavidAnson.vscode-markdownlint
code --install-extension dsznajder.es7-react-js-snippets
code --install-extension msjsdiag.vscode-react-native
code --install-extension dbaeumer.vscode-eslint
code --install-extension esbenp.prettier-vscode
code --install-extension ms-vscode.makefile-tools


choco install -y powershell-core --packageparameters '"/CleanUpPath"'
choco install -y git.install --params "/GitAndUnixToolsOnPath /WindowsTerminal/Editor:VisualStudioCode"
choco install -y 7zip
choco install -y make
choco install -y grep
choco install -y sqlserver-cmdlineutils
choco install -y sqlserver-odbcdriver
choco install -y googlechrome

# Reset environment path
$Env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
refreshenv

git config --global user.email "jdleonard@vcu.edu"
git config --global user.name "John Leonard"
git config --global core.editor "code --wait"

choco install -y visualstudio2019enterprise
choco install -y windows-sdk-11-version-21h2-all
choco install -y nodejs-lts
choco install -y openjdk11
choco install -y androidstudio
choco install -y jq
$Env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
refreshenv

# Another round of tools
choco install -y lastpass
choco install -y evernote
$Env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
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

$Env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
refreshenv

# Install pywin, needs to be codesigned
choco install -y pyenv-win
$Env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
refreshenv
cd $env:userprofile\.pyenv\pyenv-win\bin
codesign pyenv.ps1
cd $env:userprofile

pyenv install 3.9.6
pyenv global 3.9.6
(Invoke-WebRequest -Uri https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py -UseBasicParsing).Content | python -
$Env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
refreshenv


# SIG # Begin signature block
# MIIcaQYJKoZIhvcNAQcCoIIcWjCCHFYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUCr8L60GJlxcNfK1+1ynlbMR1
# 16igggt6MIIFuDCCBKCgAwIBAgITdwADAeYBHSSX0B/omgAAAAMB5jANBgkqhkiG
# 9w0BAQsFADBxMRMwEQYKCZImiZPyLGQBGRYDZWR1MRMwEQYKCZImiZPyLGQBGRYD
# dmN1MRMwEQYKCZImiZPyLGQBGRYDYWRwMRQwEgYKCZImiZPyLGQBGRYEUkFNUzEa
# MBgGA1UEAxMRVkNVIEluZm9TZWMgU3ViQ0EwHhcNMjIwNzI0MTcwMzMwWhcNMjMw
# NzI0MTcwMzMwWjCBrTETMBEGCgmSJomT8ixkARkWA2VkdTETMBEGCgmSJomT8ixk
# ARkWA3ZjdTETMBEGCgmSJomT8ixkARkWA2FkcDEUMBIGCgmSJomT8ixkARkWBFJB
# TVMxHjAcBgNVBAsTFVNjaG9vbCBvZiBFbmdpbmVlcmluZzEOMAwGA1UECxMFVXNl
# cnMxEjAQBgNVBAsTCUVtcGxveWVlczESMBAGA1UEAxMJamRsZW9uYXJkMIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqJgUsjzdyxcA5b1KjlvqP4c9mdB6
# IO+lB/wIyVL4vR8g6k7K8zH1MEWpxrIKHTn4Ap3kYYNMe+pZAB5MGlCP/rtGDPc3
# P+f1RXw0dzpEtR5ZzaRuoNq+1vpTAQHpnbmf7BXgXwuBSoTiHOPoQahf64Y6blmj
# rkFnvWJlhggIw9HrtgwvDffzd09YQieZ5mPQXAwxKkzLLoXcezpbOgYo58ZQb8zJ
# XG12Um9OaNS0seein8PjUC9tPqO7p1+TahUnEFsClszscaAe9O59qaz6ITLNRrW6
# dCVc0rk9ivPEaFTOkzw4HvtttUTDFSn+dwLW5Oyb4Ocibnc0uZN0I7YaJQIDAQAB
# o4ICCjCCAgYwPgYJKwYBBAGCNxUHBDEwLwYnKwYBBAGCNxUIhY6ucoScvQmH0Ysk
# ham6S4KI0UiBeYO+iG+FsIsBAgFkAgEFMBMGA1UdJQQMMAoGCCsGAQUFBwMDMA4G
# A1UdDwEB/wQEAwIHgDAbBgkrBgEEAYI3FQoEDjAMMAoGCCsGAQUFBwMDMB0GA1Ud
# DgQWBBRAFyj//i4TkNtgnfHkVcbKL+VMpjAfBgNVHSMEGDAWgBQVPSNZ9WTCNCZL
# GW9D8POOVdwyITBIBgNVHR8EQTA/MD2gO6A5hjdodHRwOi8vcGtpLnZjdS5lZHUv
# Q2VydEVucm9sbC9WQ1UlMjBJbmZvU2VjJTIwU3ViQ0EuY3JsMHgGCCsGAQUFBwEB
# BGwwajBDBggrBgEFBQcwAoY3aHR0cDovL3BraS52Y3UuZWR1L0NlcnRFbnJvbGwv
# VkNVJTIwSW5mb1NlYyUyMFN1YkNBLmNydDAjBggrBgEFBQcwAYYXaHR0cDovL3Br
# aS52Y3UuZWR1L29jc3AwLAYDVR0RBCUwI6AhBgorBgEEAYI3FAIDoBMMEWpkbGVv
# bmFyZEB2Y3UuZWR1MFAGCSsGAQQBgjcZAgRDMEGgPwYKKwYBBAGCNxkCAaAxBC9T
# LTEtNS0yMS0zMzYyMTM0Njc0LTE0MzQyNTQ4NzAtNjE4NDI0MDE4LTE0MjExOTAN
# BgkqhkiG9w0BAQsFAAOCAQEApn54T4KwZkb+11zSsTZQa0rITgxxu2XQPDkZGq6a
# 59NlAnUc0lT2i6mWhA6K4bBgX3fQcD33XZAq0HD14+kmk5BzC3yqJzcZ3AH9dAn+
# EaACfa5yugko4NQ/nx4a1giHRlV46HR10bvx8uri9X4mWoZ7V0PD09TbYSN6JXZn
# TPxWXFCFrm2mSFczA9Vto/Yz76OXn6iwKqkWtcn8Wolpo8TvRUu7p0BAQ4+vraQZ
# o1PlknrEozVMNb0uC40BMlEP1CjjmqqGvPBM/dsKSSjNyqT0SpKnSSP/YuzAomuM
# dTQw8DrVgnK3j5PfQdXzYlrAQ2cNAdDMB2dTAAsZuUAEDDCCBbowggOioAMCAQIC
# Ex8AAAAGzYiva2wb6vgAAAAAAAYwDQYJKoZIhvcNAQENBQAwFjEUMBIGA1UEAxML
# VkNVIFJvb3QgQ0EwHhcNMTcwOTEzMTYyNDU1WhcNMjcwOTEzMTYzNDU1WjBxMRMw
# EQYKCZImiZPyLGQBGRYDZWR1MRMwEQYKCZImiZPyLGQBGRYDdmN1MRMwEQYKCZIm
# iZPyLGQBGRYDYWRwMRQwEgYKCZImiZPyLGQBGRYEUkFNUzEaMBgGA1UEAxMRVkNV
# IEluZm9TZWMgU3ViQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDA
# c41i5s4fE5sSkmNOePH+BcAZwXebOZd1ZG7+xKG/u2hV8YAAtt1ywDobVHhoiEo5
# IabtEf9qWmW4Sd3szs3CkO592ycOBmG2Q63xMjLwoNsEor2dFL6cVL9oeZ+7Uf4v
# 23ZMRJN/42I2tTfV/1NuLOX6nZZIz1CSdYZkoTYtXqc/2nzhQyPoV4iiKcGhNSWq
# KCYYIXCpIe9NGfYU+LykOK5ogKW+zt/4jXM24/gdcJHi53nBrfxhlHVD0VtdauPw
# Jo38+79JcauogIJ6R4t57QVrts7Mt3Bgh7BA6RLwVCQqapmv82yPLHCkvjELsvMI
# +bI0Y4qEMM4uPSqmoc9zAgMBAAGjggGkMIIBoDAQBgkrBgEEAYI3FQEEAwIBADAd
# BgNVHQ4EFgQUFT0jWfVkwjQmSxlvQ/DzjlXcMiEwegYDVR0gBHMwcTBvBgcrBgEE
# AdEQMGQwOgYIKwYBBQUHAgIwLh4sAEwAZQBnAGEAbAAgAFAAbwBsAGkAYwB5ACAA
# UwB0AGEAdABlAG0AZQBuAHQwJgYIKwYBBQUHAgEWGmh0dHA6Ly9wa2kudmN1LmVk
# dS9jcHMudHh0MBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIAQwBBMAsGA1UdDwQEAwIB
# hjAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaAFJODzUoVRHlHHgkhWGTzPLhG
# 3O9aMEIGA1UdHwQ7MDkwN6A1oDOGMWh0dHA6Ly9wa2kudmN1LmVkdS9jZXJ0ZW5y
# b2xsL1ZDVSUyMFJvb3QlMjBDQS5jcmwwUwYIKwYBBQUHAQEERzBFMEMGCCsGAQUF
# BzAChjdodHRwOi8vcGtpLnZjdS5lZHUvQ2VydEVucm9sbC9BTEJVU19WQ1UlMjBS
# b290JTIwQ0EuY3J0MA0GCSqGSIb3DQEBDQUAA4ICAQBaEiX0Yzy7dvwI0nJdYNDn
# vSmKGGlXCRHuN27hhHxk9VBO8JzdsE87WYm5fJjuH9npaPjtXzPtx5fREpUDrFVt
# qVayFEPmVtQifm0VX5S4fT4ur0rvuoILjQGRadVuXM1pYuYzyU11T2z+R899AZp6
# wXVCpS/30JDIRpjoWaXwtW1E3eoBgC1Nfxpnwdb8FPigFOHVh4ghEFg71ZxnGLGX
# z5iaQLa+LelyxaxXmLqgq/DDR5ZpuQvtQMcZT2kokEad5UCWqELYSwFP0iel6qG6
# fnL8WDpJDFC/c722efMEHE8HpFSAB/BUJb9RYwZMStExp8JG11q3xklQJxgbcT5J
# rX0Jtuc3soUDs42UjThyVCL1K1mZSL0GiLbHd6KDtsiYdV5rke1GNkJMB73Inuti
# FyHuur8AEh6TDOe5Z8pMaw6cVwGpQceb1N4Y/TTo9buloehsSBcy55rak3P7HGS1
# rs0HtU/OFpQ0SO4LvSnETtki5vp3ATIO523iYZauItVsM8CrzesxgWh5AKXfHLRl
# dJdZTQKsnGjvO0tz2cc8Uwf1MMGyXFD71kQvgQ3SksSdWh8lx7NAnt7NL8nR9T3h
# udwnaIPQQhJbjhbCHHjX/TjzEzGh2F788x9+55OFAHoLkuZg7+rKpsyNqIVWyCtX
# +HJxczOWedb2q8stnrbc1zGCEFkwghBVAgEBMIGIMHExEzARBgoJkiaJk/IsZAEZ
# FgNlZHUxEzARBgoJkiaJk/IsZAEZFgN2Y3UxEzARBgoJkiaJk/IsZAEZFgNhZHAx
# FDASBgoJkiaJk/IsZAEZFgRSQU1TMRowGAYDVQQDExFWQ1UgSW5mb1NlYyBTdWJD
# QQITdwADAeYBHSSX0B/omgAAAAMB5jAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIB
# DDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEE
# AYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUFXR/ZI56SYf4
# C7GXbWVr0J99aPwwDQYJKoZIhvcNAQEBBQAEggEASqeaOSZsBKYp0mz0jaC70Yak
# /B9XIMzXPl3Pkg9C9OjURJik/uIsFRQVG3G9yxUuFqQ8mkz1Oacfp/la+ktpzs6U
# +IdBjKkhxdyIHo4h7St9UnEY1oqsZiQIRskPpAis88kf7uQglHoiSINsWpQHXsGX
# WRY2+c6S794i5vcVM3fFMdvAzPyb4UDgTsV50ooHQryfxyPMrQTng6EeLDi+VJIr
# U/fKB76uP5PaQ9C8KjZ9FswE9egG5CFIRKkIs08TTHMegl9z2ZVxhOzzqTRLFrAa
# lkp0wXk9jnxmjmy/lZt3i3x6T/DEQeyafefbSICqTJ6dAkeZAKE6FlvghVVF46GC
# Diswgg4nBgorBgEEAYI3AwMBMYIOFzCCDhMGCSqGSIb3DQEHAqCCDgQwgg4AAgED
# MQ0wCwYJYIZIAWUDBAIBMIH+BgsqhkiG9w0BCRABBKCB7gSB6zCB6AIBAQYLYIZI
# AYb4RQEHFwMwITAJBgUrDgMCGgUABBRQSgDoEE6WPscL3blScNLKE/OJ0wIUGocR
# ztfld85RAPbwo/EF0yDaQZ8YDzIwMjIwNzI0MTc0MzQ5WjADAgEeoIGGpIGDMIGA
# MQswCQYDVQQGEwJVUzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xHzAd
# BgNVBAsTFlN5bWFudGVjIFRydXN0IE5ldHdvcmsxMTAvBgNVBAMTKFN5bWFudGVj
# IFNIQTI1NiBUaW1lU3RhbXBpbmcgU2lnbmVyIC0gRzOgggqLMIIFODCCBCCgAwIB
# AgIQewWx1EloUUT3yYnSnBmdEjANBgkqhkiG9w0BAQsFADCBvTELMAkGA1UEBhMC
# VVMxFzAVBgNVBAoTDlZlcmlTaWduLCBJbmMuMR8wHQYDVQQLExZWZXJpU2lnbiBU
# cnVzdCBOZXR3b3JrMTowOAYDVQQLEzEoYykgMjAwOCBWZXJpU2lnbiwgSW5jLiAt
# IEZvciBhdXRob3JpemVkIHVzZSBvbmx5MTgwNgYDVQQDEy9WZXJpU2lnbiBVbml2
# ZXJzYWwgUm9vdCBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTAeFw0xNjAxMTIwMDAw
# MDBaFw0zMTAxMTEyMzU5NTlaMHcxCzAJBgNVBAYTAlVTMR0wGwYDVQQKExRTeW1h
# bnRlYyBDb3Jwb3JhdGlvbjEfMB0GA1UECxMWU3ltYW50ZWMgVHJ1c3QgTmV0d29y
# azEoMCYGA1UEAxMfU3ltYW50ZWMgU0hBMjU2IFRpbWVTdGFtcGluZyBDQTCCASIw
# DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALtZnVlVT52Mcl0agaLrVfOwAa08
# cawyjwVrhponADKXak3JZBRLKbvC2Sm5Luxjs+HPPwtWkPhiG37rpgfi3n9ebUA4
# 1JEG50F8eRzLy60bv9iVkfPw7mz4rZY5Ln/BJ7h4OcWEpe3tr4eOzo3HberSmLU6
# Hx45ncP0mqj0hOHE0XxxxgYptD/kgw0mw3sIPk35CrczSf/KO9T1sptL4YiZGvXA
# 6TMU1t/HgNuR7v68kldyd/TNqMz+CfWTN76ViGrF3PSxS9TO6AmRX7WEeTWKeKwZ
# Mo8jwTJBG1kOqT6xzPnWK++32OTVHW0ROpL2k8mc40juu1MO1DaXhnjFoTcCAwEA
# AaOCAXcwggFzMA4GA1UdDwEB/wQEAwIBBjASBgNVHRMBAf8ECDAGAQH/AgEAMGYG
# A1UdIARfMF0wWwYLYIZIAYb4RQEHFwMwTDAjBggrBgEFBQcCARYXaHR0cHM6Ly9k
# LnN5bWNiLmNvbS9jcHMwJQYIKwYBBQUHAgIwGRoXaHR0cHM6Ly9kLnN5bWNiLmNv
# bS9ycGEwLgYIKwYBBQUHAQEEIjAgMB4GCCsGAQUFBzABhhJodHRwOi8vcy5zeW1j
# ZC5jb20wNgYDVR0fBC8wLTAroCmgJ4YlaHR0cDovL3Muc3ltY2IuY29tL3VuaXZl
# cnNhbC1yb290LmNybDATBgNVHSUEDDAKBggrBgEFBQcDCDAoBgNVHREEITAfpB0w
# GzEZMBcGA1UEAxMQVGltZVN0YW1wLTIwNDgtMzAdBgNVHQ4EFgQUr2PWyqNOhXLg
# p7xB8ymiOH+AdWIwHwYDVR0jBBgwFoAUtnf6aUhHn1MS1cLqBzJ2B9GXBxkwDQYJ
# KoZIhvcNAQELBQADggEBAHXqsC3VNBlcMkX+DuHUT6Z4wW/X6t3cT/OhyIGI96eP
# FeZAKa3mXfSi2VZkhHEwKt0eYRdmIFYGmBmNXXHy+Je8Cf0ckUfJ4uiNA/vMkC/W
# CmxOM+zWtJPITJBjSDlAIcTd1m6JmDy1mJfoqQa3CcmPU1dBkC/hHk1O3MoQeGxC
# bvC2xfhhXFL1TvZrjfdKer7zzf0D19n2A6gP41P3CnXsxnUuqmaFBJm3+AZX4cYO
# 9uiv2uybGB+queM6AL/OipTLAduexzi7D1Kr0eOUA2AKTaD+J20UMvw/l0Dhv5mJ
# 2+Q5FL3a5NPD6itas5VYVQR9x5rsIwONhSrS/66pYYEwggVLMIIEM6ADAgECAhB7
# 1OWvuswHP6EBIwQiQU0SMA0GCSqGSIb3DQEBCwUAMHcxCzAJBgNVBAYTAlVTMR0w
# GwYDVQQKExRTeW1hbnRlYyBDb3Jwb3JhdGlvbjEfMB0GA1UECxMWU3ltYW50ZWMg
# VHJ1c3QgTmV0d29yazEoMCYGA1UEAxMfU3ltYW50ZWMgU0hBMjU2IFRpbWVTdGFt
# cGluZyBDQTAeFw0xNzEyMjMwMDAwMDBaFw0yOTAzMjIyMzU5NTlaMIGAMQswCQYD
# VQQGEwJVUzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xHzAdBgNVBAsT
# FlN5bWFudGVjIFRydXN0IE5ldHdvcmsxMTAvBgNVBAMTKFN5bWFudGVjIFNIQTI1
# NiBUaW1lU3RhbXBpbmcgU2lnbmVyIC0gRzMwggEiMA0GCSqGSIb3DQEBAQUAA4IB
# DwAwggEKAoIBAQCvDoqq+Ny/aXtUF3FHCb2NPIH4dBV3Z5Cc/d5OAp5LdvblNj5l
# 1SQgbTD53R2D6T8nSjNObRaK5I1AjSKqvqcLG9IHtjy1GiQo+BtyUT3ICYgmCDr5
# +kMjdUdwDLNfW48IHXJIV2VNrwI8QPf03TI4kz/lLKbzWSPLgN4TTfkQyaoKGGxV
# YVfR8QIsxLWr8mwj0p8NDxlsrYViaf1OhcGKUjGrW9jJdFLjV2wiv1V/b8oGqz9K
# tyJ2ZezsNvKWlYEmLP27mKoBONOvJUCbCVPwKVeFWF7qhUhBIYfl3rTTJrJ7QFNY
# eY5SMQZNlANFxM48A+y3API6IsW0b+XvsIqbAgMBAAGjggHHMIIBwzAMBgNVHRMB
# Af8EAjAAMGYGA1UdIARfMF0wWwYLYIZIAYb4RQEHFwMwTDAjBggrBgEFBQcCARYX
# aHR0cHM6Ly9kLnN5bWNiLmNvbS9jcHMwJQYIKwYBBQUHAgIwGRoXaHR0cHM6Ly9k
# LnN5bWNiLmNvbS9ycGEwQAYDVR0fBDkwNzA1oDOgMYYvaHR0cDovL3RzLWNybC53
# cy5zeW1hbnRlYy5jb20vc2hhMjU2LXRzcy1jYS5jcmwwFgYDVR0lAQH/BAwwCgYI
# KwYBBQUHAwgwDgYDVR0PAQH/BAQDAgeAMHcGCCsGAQUFBwEBBGswaTAqBggrBgEF
# BQcwAYYeaHR0cDovL3RzLW9jc3Aud3Muc3ltYW50ZWMuY29tMDsGCCsGAQUFBzAC
# hi9odHRwOi8vdHMtYWlhLndzLnN5bWFudGVjLmNvbS9zaGEyNTYtdHNzLWNhLmNl
# cjAoBgNVHREEITAfpB0wGzEZMBcGA1UEAxMQVGltZVN0YW1wLTIwNDgtNjAdBgNV
# HQ4EFgQUpRMBqZ+FzBtuFh5fOzGqeTYAex0wHwYDVR0jBBgwFoAUr2PWyqNOhXLg
# p7xB8ymiOH+AdWIwDQYJKoZIhvcNAQELBQADggEBAEaer/C4ol+imUjPqCdLIc2y
# uaZycGMv41UpezlGTud+ZQZYi7xXipINCNgQujYk+gp7+zvTYr9KlBXmgtuKVG3/
# KP5nz3E/5jMJ2aJZEPQeSv5lzN7Ua+NSKXUASiulzMub6KlN97QXWZJBw7c/hub2
# wH9EPEZcF1rjpDvVaSbVIX3hgGd+Yqy3Ti4VmuWcI69bEepxqUH5DXk4qaENz7Sx
# 2j6aescixXTN30cJhsT8kSWyG5bphQjo3ep0YG5gpVZ6DchEWNzm+UgUnuW/3gC9
# d7GYFHIUJN/HESwfAD/DSxTGZxzMHgajkF9cVIs+4zNbgg/Ft4YCTnGf6WZFP3Yx
# ggJaMIICVgIBATCBizB3MQswCQYDVQQGEwJVUzEdMBsGA1UEChMUU3ltYW50ZWMg
# Q29ycG9yYXRpb24xHzAdBgNVBAsTFlN5bWFudGVjIFRydXN0IE5ldHdvcmsxKDAm
# BgNVBAMTH1N5bWFudGVjIFNIQTI1NiBUaW1lU3RhbXBpbmcgQ0ECEHvU5a+6zAc/
# oQEjBCJBTRIwCwYJYIZIAWUDBAIBoIGkMBoGCSqGSIb3DQEJAzENBgsqhkiG9w0B
# CRABBDAcBgkqhkiG9w0BCQUxDxcNMjIwNzI0MTc0MzQ5WjAvBgkqhkiG9w0BCQQx
# IgQg5nxTD/cYypAEY2ACKaOEFTx7ZqZyz3Eoig7AP1J7uTYwNwYLKoZIhvcNAQkQ
# Ai8xKDAmMCQwIgQgxHTOdgB9AjlODaXk3nwUxoD54oIBPP72U+9dtx/fYfgwCwYJ
# KoZIhvcNAQEBBIIBAG2tnHN6MTmlLG1sNHj9F40wHj2j94v36p9TQBiZvD4BhxPr
# 7TiC+gK7H/LNok8qjUyY3SXxxR56H97IJO7gWCMz72e323tWmdLqlVmOaKaAJ7XC
# LXKQVZF4vwTPgkiysoo06fu5XcWqQwNZtMDaUgiGYxIsqavZv+JljJoydC/l9RP1
# rxfLvJeyW004s1tgYbv/nmInFlSNzPl7xXkqh7fdHNDvK/3QmaGPrhc5B9YGTVLs
# Rwr8n6s2/akiOGM2CGAtAf5QvmilWUsTKjouWbZgUJUR+NkzAhMrWFezc5YikFVc
# xzV+Ix/REgsa5LoAOC5cznct2dgKvz7aB6qflgE=
# SIG # End signature block
