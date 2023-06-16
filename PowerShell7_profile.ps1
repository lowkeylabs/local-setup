##
## This script is being called from another PS1 script.
## More care on global vs local variables is necessary!

# function to replace UNC portion of drive name with Drive letter from mapped drives (if exists)
function global:UNCtoDrive( $inputPath )
{
$returnValue = $inputPath
$mappedDrives = @{}
Get-WmiObject win32_logicaldisk -Filter 'drivetype=4' | Foreach { $mappedDrives.($_.ProviderName) = $_.deviceID }
$mappedDrives.Keys.ForEach( {if($inputPath.ToLower().contains( ($_).ToLower())) {$returnValue=$mappedDrives[$_]+$InputPath.substring(($_).length)}})
return $returnValue
}

# function to overload the built-in, default PowerShell prompt
function global:Prompt
{
    $curPath = $ExecutionContext.SessionState.Path.CurrentLocation.Path
    if ($curPath.ToLower().StartsWith($Home.ToLower()))
    {
        $curPath = "~" + $curPath.SubString($Home.Length)
    }
    $curPath = $ExecutionContext.SessionState.Path.CurrentLocation.Path

	$env:VIRTUAL_ENV_DISABLE_PROMPT = 1
	$workOn = ""
	if ( $env:VIRTUAL_ENV )
	{
	    $workOn = "working on ($(split-path $env:VIRTUAL_ENV -leaf))"
	}
	
"
$curPath $workOn
PS $('>' * ($nestedPromptLevel + 1)) "
}

# function to set environment for connections to DB servers using Reporter
function setEnvDB
{
$ENV:ODSPROD_USER="jdleonard"
$ENV:ODSPROD_PASS="c1uwlESp"
$ENV:ODSPROD_SID="ODS1"
$ENV:ODSPROD_DSN="dbi:Oracle:ODSPROD.ODS1"

$ENV:EGRPROD_DSN="dbi:ODBC:EGRPROD"
$ENV:EGRPROD_SERVER="brighton.vcu.edu"
$ENV:EGRPROD_DB="EGRDataWarehouse"

$ENV:EGRDEV_DSN="dbi:ODBC:EGRDEV"
$ENV:EGRDEV_SERVER="bachelor.vcu.edu"
$ENV:EGRDEV_DB="EGRSandbox"

$ENV:FMI8PROD_DSN="dbi:ODBC:FMI8PROD"
$ENV:FMI8PROD_SERVER="jacksonhole.vcu.edu"
$ENV:FMI8PROD_DB="VCU_PROD_FMI8"

$ENV:DICT_DSN="dbi:ODBC:EGRPROD"
$ENV:DICT_SERVER="brighton.vcu.edu"
$ENV:DICT_DB="EGRDataWarehouse"

}

# function to set enviroment for use of R tools
function setRenv
{
# Setting environment for RTOOLS
# Update as versions of RTOOLS and R change
#

$ENV:R_HOME="H:\VDI\R"
$ENV:R_ENVIRON_USER="$ENV:R_HOME\.Renviron"
$ENV:R_PROFILE_USER="$ENV:R_HOME\.Rprofile"

## These change for new versions.  The R_LIBS_USER
## is set in the .Renviron file
#
#$ENV:R_VERSION="3.4.4"
#$ENV:R_TOOLS="3.4"

$ENV:R_VERSION="4.2.1"
$R_ROOT = "C:\Program Files\R"
$ENV:PATH="$ENV:PATH;$R_ROOT\R-$ENV:R_VERSION\bin\x64"


$ENV:R_TOOLS="4.0"
## these should need to change on new versions
$ENV:R_GCC="mingw_64"
#$ENV:R_MAX_MEM_SIZE="20G"
#
#
#  Add path for RTOOLS version set in the R_TOOLS variable above
$ENV:PATH="$ENV:PATH;C:\rtools40\mingw64\bin"
$ENV:PATH="$ENV:PATH;C:\Program Files\MiKTeX\miktex\bin\x64"
# 
#
#
#  Add path for Perl
##$ENV:PERL_VERSION="5.22"
##$ENV:PATH="$ENV:PATH;$ENV:FINROOT\Perl64\$ENV:PERL_VERSION\site\bin;$ENV:FINROOT\Perl64\$ENV:PERL_VERSION\bin"
##$ENV:PERL5LIB="$ENV:FINROOT\Perl64\$ENV:PERL_VERSION\site\lib;$ENV:FINROOT\Perl64\$ENV:PERL_VERSION\lib"
# 
#
#  For GIT version control (RTools should be called before GIT)
#$ENV:PATH="$ENV:PATH;C:\Program Files\Git\cmd;C:\Program Files\Git\bin"
#
#  
##$ENV:SVN_EDITOR="notepad"
##$ENV:EDITOR="notepad"
$ENV:CYGWIN="nodosfilewarning"
##$ENV:R_GSCMD = "C:/Program Files/gs/gs9.05/bin/gswin32c.exe"
# 
#  R is available at:  http://cran.r-project.org/bin/windows/base/  (old versions also available)
#  RTOOLS is available at:  https://cran.r-project.org/bin/windows/Rtools/
#  RTOOLS must be updated to "match" different versions of R.  See cran for details.
#  By default RTOOLS doesn't install into version-specific subdirectories. YOU NEED TO DO IT!

$python_version = python --version
write-host "RTOOLS environment set. R:$ENV:R_VERSION  Rtools:$ENV:R_TOOLS  $python_version"
}

## main entry point for this Powershell Script
##

write-host "Windows Powershell - ver."$PSVersionTable.PSVersion.ToString()
$mypath = $myinvocation.MyCommand.Path
write-host "Running common profile: $mypath"


#
# Perform machine specific startup stuff
#
##if($env:computername -eq "EGR-VDI-004"){

  # set a few helper variables (great for set-location)
  $profilehome = split-path $profile
  $egrcodehome = "C:\Users\jdleonard\Projects\vcu-egr-data-warehouse\Integration Services Project1\code"

  #  Add path for conda environment manager
##  $ENV:ANA3="C:\users\jdleonard\anaconda3"
##  $ENV:PATH="$ENV:ANA3;$ENV:ANA3\Library\usr\bin;$ENV:ANA3\Library\bin;$ENV:ANA3\Scripts;$ENV:PATH"
  # 

##}

# fix for "grep -P". Examine "make -d" to find.
$ENV:LC_ALL = "en_US.utf8"

# Prompt to set up rtools and DB environment as necessary
#
#$yesNo = read-host -prompt "Set enviroment for DB and R?"
#if($yesNo.ToLower() -eq "y"){

setEnvDB
setRenv

# Quarto and Poetry setup

$env:QUARTO_PYTHON=$(pyenv which python)
$ENV:PATH="$ENV:PATH;$ENV:APPDATA\Python\Scripts"
$ENV:PATH="$ENV:PATH;C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\Roslyn"

oh-my-posh init pwsh --config "$env:USERPROFILE\.mysetup\jandedobbeleer.omp.json" | Invoke-Expression

#}

# SIG # Begin signature block
# MIIcjwYJKoZIhvcNAQcCoIIcgDCCHHwCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBHEJCzfhIJvEPN
# OkkO9S/kIFdTtCvVO799/JUXlVAMkKCCC3owggW4MIIEoKADAgECAhN3AAMfIYTN
# K++c4eOVAAAAAx8hMA0GCSqGSIb3DQEBCwUAMHExEzARBgoJkiaJk/IsZAEZFgNl
# ZHUxEzARBgoJkiaJk/IsZAEZFgN2Y3UxEzARBgoJkiaJk/IsZAEZFgNhZHAxFDAS
# BgoJkiaJk/IsZAEZFgRSQU1TMRowGAYDVQQDExFWQ1UgSW5mb1NlYyBTdWJDQTAe
# Fw0yMjEyMTQxMjU0MDVaFw0yMzEyMTQxMjU0MDVaMIGtMRMwEQYKCZImiZPyLGQB
# GRYDZWR1MRMwEQYKCZImiZPyLGQBGRYDdmN1MRMwEQYKCZImiZPyLGQBGRYDYWRw
# MRQwEgYKCZImiZPyLGQBGRYEUkFNUzEeMBwGA1UECxMVU2Nob29sIG9mIEVuZ2lu
# ZWVyaW5nMQ4wDAYDVQQLEwVVc2VyczESMBAGA1UECxMJRW1wbG95ZWVzMRIwEAYD
# VQQDEwlqZGxlb25hcmQwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDU
# f8r4Ek4Kcj4mW7Kawbh60MaqEoihl2GqUbIaicB5/2VvxTP+TdfiNbAJVJ/Ml+Jb
# 3E7EBpvNwztBREUSLii402xqn+Jjl8pu6Wj70jweqKwVoRi1IfWGzzSkrB3qVPCJ
# 2OfxvQQq9+UrlGQQfE3C0b53DxxwZ//189CSQlBLTr3fbYnPKga8o7u5dyNB2FI1
# bi9egMp4e+zc9rQE6UN5mXrVKuQ0aGJBZ8biUpDWfizQfhrUHSOKNexp9yckPyvH
# pAj1YGohkYE0FhVqnfPXCVy75YQBrh+JluaICxK/lMax45S7+fC1LkIH8J5W/Vxe
# sRjMVUnE3rYRX8OqULuxAgMBAAGjggIKMIICBjA+BgkrBgEEAYI3FQcEMTAvBicr
# BgEEAYI3FQiFjq5yhJy9CYfRiySFqbpLgojRSIF5g76Ib4WwiwECAWQCAQUwEwYD
# VR0lBAwwCgYIKwYBBQUHAwMwDgYDVR0PAQH/BAQDAgeAMBsGCSsGAQQBgjcVCgQO
# MAwwCgYIKwYBBQUHAwMwHQYDVR0OBBYEFC6vKnctl7PPifmR7sASD1yoQXVrMB8G
# A1UdIwQYMBaAFBU9I1n1ZMI0JksZb0Pw845V3DIhMEgGA1UdHwRBMD8wPaA7oDmG
# N2h0dHA6Ly9wa2kudmN1LmVkdS9DZXJ0RW5yb2xsL1ZDVSUyMEluZm9TZWMlMjBT
# dWJDQS5jcmwweAYIKwYBBQUHAQEEbDBqMEMGCCsGAQUFBzAChjdodHRwOi8vcGtp
# LnZjdS5lZHUvQ2VydEVucm9sbC9WQ1UlMjBJbmZvU2VjJTIwU3ViQ0EuY3J0MCMG
# CCsGAQUFBzABhhdodHRwOi8vcGtpLnZjdS5lZHUvb2NzcDAsBgNVHREEJTAjoCEG
# CisGAQQBgjcUAgOgEwwRamRsZW9uYXJkQHZjdS5lZHUwUAYJKwYBBAGCNxkCBEMw
# QaA/BgorBgEEAYI3GQIBoDEEL1MtMS01LTIxLTMzNjIxMzQ2NzQtMTQzNDI1NDg3
# MC02MTg0MjQwMTgtMTQyMTE5MA0GCSqGSIb3DQEBCwUAA4IBAQA1KhGcE46trMLb
# TlPxFSLE7u7eg4rY/wczXavdZKxE9U6IgWx80J/jJZbDeVWWYwQe/qDlB9ID/Qg1
# CBs+aEGM2VgwErL3wf2c9TgA2eWneqSq8IaMs3VnAgp6U2WPn5woyC6hioUTWCbQ
# NclOEs+3jMCIz0f0+u+HeXKhhN6XvrtbiaDFNwR9AHV7UF7CQ3IVxen3rYxxlQwc
# 9dJ04IG/icKLdcGgQ/VG02C5gzQQG/XsUxTPk0DgqofZ3P3Xd32IVUOYKwJyA9vd
# BOiHgGozwzo8RdVc3Secz06OxMULX+j9lpPXtTKOqd4zg3i0ksNshTTKKnYBm+W1
# 7rB4XHaYMIIFujCCA6KgAwIBAgITHwAAAAbNiK9rbBvq+AAAAAAABjANBgkqhkiG
# 9w0BAQ0FADAWMRQwEgYDVQQDEwtWQ1UgUm9vdCBDQTAeFw0xNzA5MTMxNjI0NTVa
# Fw0yNzA5MTMxNjM0NTVaMHExEzARBgoJkiaJk/IsZAEZFgNlZHUxEzARBgoJkiaJ
# k/IsZAEZFgN2Y3UxEzARBgoJkiaJk/IsZAEZFgNhZHAxFDASBgoJkiaJk/IsZAEZ
# FgRSQU1TMRowGAYDVQQDExFWQ1UgSW5mb1NlYyBTdWJDQTCCASIwDQYJKoZIhvcN
# AQEBBQADggEPADCCAQoCggEBAMBzjWLmzh8TmxKSY0548f4FwBnBd5s5l3Vkbv7E
# ob+7aFXxgAC23XLAOhtUeGiISjkhpu0R/2paZbhJ3ezOzcKQ7n3bJw4GYbZDrfEy
# MvCg2wSivZ0UvpxUv2h5n7tR/i/bdkxEk3/jYja1N9X/U24s5fqdlkjPUJJ1hmSh
# Ni1epz/afOFDI+hXiKIpwaE1JaooJhghcKkh700Z9hT4vKQ4rmiApb7O3/iNczbj
# +B1wkeLnecGt/GGUdUPRW11q4/Amjfz7v0lxq6iAgnpHi3ntBWu2zsy3cGCHsEDp
# EvBUJCpqma/zbI8scKS+MQuy8wj5sjRjioQwzi49Kqahz3MCAwEAAaOCAaQwggGg
# MBAGCSsGAQQBgjcVAQQDAgEAMB0GA1UdDgQWBBQVPSNZ9WTCNCZLGW9D8POOVdwy
# ITB6BgNVHSAEczBxMG8GBysGAQQB0RAwZDA6BggrBgEFBQcCAjAuHiwATABlAGcA
# YQBsACAAUABvAGwAaQBjAHkAIABTAHQAYQB0AGUAbQBlAG4AdDAmBggrBgEFBQcC
# ARYaaHR0cDovL3BraS52Y3UuZWR1L2Nwcy50eHQwGQYJKwYBBAGCNxQCBAweCgBT
# AHUAYgBDAEEwCwYDVR0PBAQDAgGGMA8GA1UdEwEB/wQFMAMBAf8wHwYDVR0jBBgw
# FoAUk4PNShVEeUceCSFYZPM8uEbc71owQgYDVR0fBDswOTA3oDWgM4YxaHR0cDov
# L3BraS52Y3UuZWR1L2NlcnRlbnJvbGwvVkNVJTIwUm9vdCUyMENBLmNybDBTBggr
# BgEFBQcBAQRHMEUwQwYIKwYBBQUHMAKGN2h0dHA6Ly9wa2kudmN1LmVkdS9DZXJ0
# RW5yb2xsL0FMQlVTX1ZDVSUyMFJvb3QlMjBDQS5jcnQwDQYJKoZIhvcNAQENBQAD
# ggIBAFoSJfRjPLt2/AjScl1g0Oe9KYoYaVcJEe43buGEfGT1UE7wnN2wTztZibl8
# mO4f2elo+O1fM+3Hl9ESlQOsVW2pVrIUQ+ZW1CJ+bRVflLh9Pi6vSu+6gguNAZFp
# 1W5czWli5jPJTXVPbP5Hz30BmnrBdUKlL/fQkMhGmOhZpfC1bUTd6gGALU1/GmfB
# 1vwU+KAU4dWHiCEQWDvVnGcYsZfPmJpAtr4t6XLFrFeYuqCr8MNHlmm5C+1AxxlP
# aSiQRp3lQJaoQthLAU/SJ6Xqobp+cvxYOkkMUL9zvbZ58wQcTwekVIAH8FQlv1Fj
# BkxK0TGnwkbXWrfGSVAnGBtxPkmtfQm25zeyhQOzjZSNOHJUIvUrWZlIvQaItsd3
# ooO2yJh1XmuR7UY2QkwHvcie62IXIe66vwASHpMM57lnykxrDpxXAalBx5vU3hj9
# NOj1u6Wh6GxIFzLnmtqTc/scZLWuzQe1T84WlDRI7gu9KcRO2SLm+ncBMg7nbeJh
# lq4i1WwzwKvN6zGBaHkApd8ctGV0l1lNAqycaO87S3PZxzxTB/UwwbJcUPvWRC+B
# DdKSxJ1aHyXHs0Ce3s0vydH1PeG53Cdog9BCEluOFsIceNf9OPMTMaHYXvzzH37n
# k4UAeguS5mDv6sqmzI2ohVbIK1f4cnFzM5Z51varyy2ettzXMYIQazCCEGcCAQEw
# gYgwcTETMBEGCgmSJomT8ixkARkWA2VkdTETMBEGCgmSJomT8ixkARkWA3ZjdTET
# MBEGCgmSJomT8ixkARkWA2FkcDEUMBIGCgmSJomT8ixkARkWBFJBTVMxGjAYBgNV
# BAMTEVZDVSBJbmZvU2VjIFN1YkNBAhN3AAMfIYTNK++c4eOVAAAAAx8hMA0GCWCG
# SAFlAwQCAQUAoIGEMBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcN
# AQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUw
# LwYJKoZIhvcNAQkEMSIEIL1rj+JkB8Ti80j7KVuxEmvzsVQU1h/oYdccbpKbOlNx
# MA0GCSqGSIb3DQEBAQUABIIBAIDT2UdC6VOgBUjhPFMX9C7YxRTMvxbi0IpEouGh
# zyJavEXUnvtt+++azVaFfOLMU1x9CPIpENAPf98FQd86zrr6NwU4v8TJtELe/D6r
# BvYEbnQ69WRi6wO6fSd90drcpNPng8pNkuW2Rj/5BMpEOymqAAkT/wESARfjxs93
# w9CVAdHfFEdhfUJFH+lplZ607TvFK/EGNS0WOxlLXPflBxsGa0ftoHYO6Za0KO6X
# FwCxIBmQIxql0d50hytpiJZnKYP0ihUoq7n21E6CLR4Z2Rx21TBpuPda1mxr/e8u
# dbW8SGXIQEFWkHNNzF5lkYThn4SKcAzdlznBuikQ3fh8vKWhgg4sMIIOKAYKKwYB
# BAGCNwMDATGCDhgwgg4UBgkqhkiG9w0BBwKggg4FMIIOAQIBAzENMAsGCWCGSAFl
# AwQCATCB/wYLKoZIhvcNAQkQAQSgge8EgewwgekCAQEGC2CGSAGG+EUBBxcDMCEw
# CQYFKw4DAhoFAAQUbFethzNt2yb0HM3rSVN9EMh+uTACFQC+Mo9lokavyKjMR+ox
# UGYNQE1AsxgPMjAyMzA2MDYxOTAwMjJaMAMCAR6ggYakgYMwgYAxCzAJBgNVBAYT
# AlVTMR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3JhdGlvbjEfMB0GA1UECxMWU3lt
# YW50ZWMgVHJ1c3QgTmV0d29yazExMC8GA1UEAxMoU3ltYW50ZWMgU0hBMjU2IFRp
# bWVTdGFtcGluZyBTaWduZXIgLSBHM6CCCoswggU4MIIEIKADAgECAhB7BbHUSWhR
# RPfJidKcGZ0SMA0GCSqGSIb3DQEBCwUAMIG9MQswCQYDVQQGEwJVUzEXMBUGA1UE
# ChMOVmVyaVNpZ24sIEluYy4xHzAdBgNVBAsTFlZlcmlTaWduIFRydXN0IE5ldHdv
# cmsxOjA4BgNVBAsTMShjKSAyMDA4IFZlcmlTaWduLCBJbmMuIC0gRm9yIGF1dGhv
# cml6ZWQgdXNlIG9ubHkxODA2BgNVBAMTL1ZlcmlTaWduIFVuaXZlcnNhbCBSb290
# IENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTE2MDExMjAwMDAwMFoXDTMxMDEx
# MTIzNTk1OVowdzELMAkGA1UEBhMCVVMxHTAbBgNVBAoTFFN5bWFudGVjIENvcnBv
# cmF0aW9uMR8wHQYDVQQLExZTeW1hbnRlYyBUcnVzdCBOZXR3b3JrMSgwJgYDVQQD
# Ex9TeW1hbnRlYyBTSEEyNTYgVGltZVN0YW1waW5nIENBMIIBIjANBgkqhkiG9w0B
# AQEFAAOCAQ8AMIIBCgKCAQEAu1mdWVVPnYxyXRqBoutV87ABrTxxrDKPBWuGmicA
# MpdqTclkFEspu8LZKbku7GOz4c8/C1aQ+GIbfuumB+Lef15tQDjUkQbnQXx5HMvL
# rRu/2JWR8/DubPitljkuf8EnuHg5xYSl7e2vh47Ojcdt6tKYtTofHjmdw/SaqPSE
# 4cTRfHHGBim0P+SDDSbDewg+TfkKtzNJ/8o71PWym0vhiJka9cDpMxTW38eA25Hu
# /rySV3J39M2ozP4J9ZM3vpWIasXc9LFL1M7oCZFftYR5NYp4rBkyjyPBMkEbWQ6p
# PrHM+dYr77fY5NUdbRE6kvaTyZzjSO67Uw7UNpeGeMWhNwIDAQABo4IBdzCCAXMw
# DgYDVR0PAQH/BAQDAgEGMBIGA1UdEwEB/wQIMAYBAf8CAQAwZgYDVR0gBF8wXTBb
# BgtghkgBhvhFAQcXAzBMMCMGCCsGAQUFBwIBFhdodHRwczovL2Quc3ltY2IuY29t
# L2NwczAlBggrBgEFBQcCAjAZGhdodHRwczovL2Quc3ltY2IuY29tL3JwYTAuBggr
# BgEFBQcBAQQiMCAwHgYIKwYBBQUHMAGGEmh0dHA6Ly9zLnN5bWNkLmNvbTA2BgNV
# HR8ELzAtMCugKaAnhiVodHRwOi8vcy5zeW1jYi5jb20vdW5pdmVyc2FsLXJvb3Qu
# Y3JsMBMGA1UdJQQMMAoGCCsGAQUFBwMIMCgGA1UdEQQhMB+kHTAbMRkwFwYDVQQD
# ExBUaW1lU3RhbXAtMjA0OC0zMB0GA1UdDgQWBBSvY9bKo06FcuCnvEHzKaI4f4B1
# YjAfBgNVHSMEGDAWgBS2d/ppSEefUxLVwuoHMnYH0ZcHGTANBgkqhkiG9w0BAQsF
# AAOCAQEAdeqwLdU0GVwyRf4O4dRPpnjBb9fq3dxP86HIgYj3p48V5kApreZd9KLZ
# VmSEcTAq3R5hF2YgVgaYGY1dcfL4l7wJ/RyRR8ni6I0D+8yQL9YKbE4z7Na0k8hM
# kGNIOUAhxN3WbomYPLWYl+ipBrcJyY9TV0GQL+EeTU7cyhB4bEJu8LbF+GFcUvVO
# 9muN90p6vvPN/QPX2fYDqA/jU/cKdezGdS6qZoUEmbf4Blfhxg726K/a7JsYH6q5
# 4zoAv86KlMsB257HOLsPUqvR45QDYApNoP4nbRQy/D+XQOG/mYnb5DkUvdrk08Pq
# K1qzlVhVBH3HmuwjA42FKtL/rqlhgTCCBUswggQzoAMCAQICEHvU5a+6zAc/oQEj
# BCJBTRIwDQYJKoZIhvcNAQELBQAwdzELMAkGA1UEBhMCVVMxHTAbBgNVBAoTFFN5
# bWFudGVjIENvcnBvcmF0aW9uMR8wHQYDVQQLExZTeW1hbnRlYyBUcnVzdCBOZXR3
# b3JrMSgwJgYDVQQDEx9TeW1hbnRlYyBTSEEyNTYgVGltZVN0YW1waW5nIENBMB4X
# DTE3MTIyMzAwMDAwMFoXDTI5MDMyMjIzNTk1OVowgYAxCzAJBgNVBAYTAlVTMR0w
# GwYDVQQKExRTeW1hbnRlYyBDb3Jwb3JhdGlvbjEfMB0GA1UECxMWU3ltYW50ZWMg
# VHJ1c3QgTmV0d29yazExMC8GA1UEAxMoU3ltYW50ZWMgU0hBMjU2IFRpbWVTdGFt
# cGluZyBTaWduZXIgLSBHMzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEB
# AK8Oiqr43L9pe1QXcUcJvY08gfh0FXdnkJz93k4Cnkt29uU2PmXVJCBtMPndHYPp
# PydKM05tForkjUCNIqq+pwsb0ge2PLUaJCj4G3JRPcgJiCYIOvn6QyN1R3AMs19b
# jwgdckhXZU2vAjxA9/TdMjiTP+UspvNZI8uA3hNN+RDJqgoYbFVhV9HxAizEtavy
# bCPSnw0PGWythWJp/U6FwYpSMatb2Ml0UuNXbCK/VX9vygarP0q3InZl7Ow28paV
# gSYs/buYqgE4068lQJsJU/ApV4VYXuqFSEEhh+XetNMmsntAU1h5jlIxBk2UA0XE
# zjwD7LcA8joixbRv5e+wipsCAwEAAaOCAccwggHDMAwGA1UdEwEB/wQCMAAwZgYD
# VR0gBF8wXTBbBgtghkgBhvhFAQcXAzBMMCMGCCsGAQUFBwIBFhdodHRwczovL2Qu
# c3ltY2IuY29tL2NwczAlBggrBgEFBQcCAjAZGhdodHRwczovL2Quc3ltY2IuY29t
# L3JwYTBABgNVHR8EOTA3MDWgM6Axhi9odHRwOi8vdHMtY3JsLndzLnN5bWFudGVj
# LmNvbS9zaGEyNTYtdHNzLWNhLmNybDAWBgNVHSUBAf8EDDAKBggrBgEFBQcDCDAO
# BgNVHQ8BAf8EBAMCB4AwdwYIKwYBBQUHAQEEazBpMCoGCCsGAQUFBzABhh5odHRw
# Oi8vdHMtb2NzcC53cy5zeW1hbnRlYy5jb20wOwYIKwYBBQUHMAKGL2h0dHA6Ly90
# cy1haWEud3Muc3ltYW50ZWMuY29tL3NoYTI1Ni10c3MtY2EuY2VyMCgGA1UdEQQh
# MB+kHTAbMRkwFwYDVQQDExBUaW1lU3RhbXAtMjA0OC02MB0GA1UdDgQWBBSlEwGp
# n4XMG24WHl87Map5NgB7HTAfBgNVHSMEGDAWgBSvY9bKo06FcuCnvEHzKaI4f4B1
# YjANBgkqhkiG9w0BAQsFAAOCAQEARp6v8LiiX6KZSM+oJ0shzbK5pnJwYy/jVSl7
# OUZO535lBliLvFeKkg0I2BC6NiT6Cnv7O9Niv0qUFeaC24pUbf8o/mfPcT/mMwnZ
# olkQ9B5K/mXM3tRr41IpdQBKK6XMy5voqU33tBdZkkHDtz+G5vbAf0Q8RlwXWuOk
# O9VpJtUhfeGAZ35irLdOLhWa5Zwjr1sR6nGpQfkNeTipoQ3PtLHaPpp6xyLFdM3f
# RwmGxPyRJbIblumFCOjd6nRgbmClVnoNyERY3Ob5SBSe5b/eAL13sZgUchQk38cR
# LB8AP8NLFMZnHMweBqOQX1xUiz7jM1uCD8W3hgJOcZ/pZkU/djGCAlowggJWAgEB
# MIGLMHcxCzAJBgNVBAYTAlVTMR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3JhdGlv
# bjEfMB0GA1UECxMWU3ltYW50ZWMgVHJ1c3QgTmV0d29yazEoMCYGA1UEAxMfU3lt
# YW50ZWMgU0hBMjU2IFRpbWVTdGFtcGluZyBDQQIQe9Tlr7rMBz+hASMEIkFNEjAL
# BglghkgBZQMEAgGggaQwGgYJKoZIhvcNAQkDMQ0GCyqGSIb3DQEJEAEEMBwGCSqG
# SIb3DQEJBTEPFw0yMzA2MDYxOTAwMjJaMC8GCSqGSIb3DQEJBDEiBCDb9frUdw57
# SIEDa3vJNnrtz7ug8uyj5PAn6NUd5sMdtjA3BgsqhkiG9w0BCRACLzEoMCYwJDAi
# BCDEdM52AH0COU4NpeTefBTGgPniggE8/vZT7123H99h+DALBgkqhkiG9w0BAQEE
# ggEAQm+uJJNsvOp6VjhoVUOr9KtBKUAQNypYZEKFsUeM8g4vsqGaqvkmg8R8uZVz
# NYUcPb8SiqE/mCyUBbhdoOpYttN3bEj3nRZd54SGthw/YrUAfUue+fmeLwYR/ZVM
# YH/POG5Xi2kyGJMOgUEPkW90hsiWb6p/LbnjQiRGGvfmtGanTPShMQ8vGHQZk24j
# 6hXVTGRyl4i8C1wYJbO0D0PZpergPgF7wgKmI3AcM3wx5ifs8YEHr2bxbfOaXu/P
# N52X2DloPcxg816aH/fB3SqAlrN7PZFLA/U7KwiNdS7Pz+N42ZlFiaD6f3qrOZWa
# pdjMHhFf4RnQuZaH8CzhP/yrvg==
# SIG # End signature block
