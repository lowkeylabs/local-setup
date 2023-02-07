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

# Quarto setup

$env:QUARTO_PYTHON=$(pyenv which python3)

#}

# SIG # Begin signature block
# MIIcFwYJKoZIhvcNAQcCoIIcCDCCHAQCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUIaJ0CMzQhZ3II+Y5BCBfhPzn
# W32gggsoMIIFZjCCBE6gAwIBAgITdwACwrL5F2tX4uCXugAAAALCsjANBgkqhkiG
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
# BDEWBBR0FgUOfYnD268lFYpGhYYQgrPePjANBgkqhkiG9w0BAQEFAASCAQCamo/8
# Z8VTWIO9T6eeF/R36YLjUmPwb3sEnDlPdjnxYKT3wKdf8nuAy62cn+vQQlAnm5Bd
# xdhvRsOlwbKnjTqBufjbiVdfGtx/vkThC5rmicgVkqV9L9jJYimug5b+83qvjQix
# +C5oScVlI0PCVAYzZpfRvtoLHuRqaODt2plpoG2ap7yfCVoTqN95/QZmBRvi6BH6
# DiD44PIa0gxzy+4/vxFtfuWMKTXkWS5CJvLQ20TKMh2K/Idyyb2toOte67C8op2Q
# zwjMP1Cpg229gEC1u3zdnMoTg3C+vF/n4AXcjqsw/sq12kGSohItYtF5qOzMBAlM
# elLNsd/CYvWovTifoYIOKzCCDicGCisGAQQBgjcDAwExgg4XMIIOEwYJKoZIhvcN
# AQcCoIIOBDCCDgACAQMxDTALBglghkgBZQMEAgEwgf4GCyqGSIb3DQEJEAEEoIHu
# BIHrMIHoAgEBBgtghkgBhvhFAQcXAzAhMAkGBSsOAwIaBQAEFDFaVtUQ3jYGash/
# vtbeMAmnGta7AhQ4v6jlm3E5ytmrh1KACpVKMSxBMxgPMjAyMjA4MDIxODM0NDZa
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
# AQkDMQ0GCyqGSIb3DQEJEAEEMBwGCSqGSIb3DQEJBTEPFw0yMjA4MDIxODM0NDZa
# MC8GCSqGSIb3DQEJBDEiBCAjgMVzlW6kT6DokZcJ/DKljVg3bBlAxO2OSLTJL3eo
# XjA3BgsqhkiG9w0BCRACLzEoMCYwJDAiBCDEdM52AH0COU4NpeTefBTGgPniggE8
# /vZT7123H99h+DALBgkqhkiG9w0BAQEEggEApyAgYK7Slq5uz0v1jJ8/b/gvdYOZ
# Mmmvzof9EyFxYXSwu8I0EW7veGJ76GTCs09nK9IAx4FwthYP1ATkvjmjV03hzxl/
# 7nycEJHlKnM0MlLKRiH1S+4tiBBy9B9dPN6qUO4++ahIiFXUHpHt/6Lf32PKBQkB
# 79h+/2MZRGxLVdweCb81RVc9DtZr2ThQAy6f2W3pg3tqMQxhWlK/bQRzxxrkauVk
# YT09KJ8+rXmEQe0eQyFdaQkSNMhxY+yrWpMw2kKlcK5MZE1GxIrTdXkELSJ568kw
# R8M+duqKVtKZgO59nxK3AtCgzEsRk03LzfFLlxDXKaNXYXP93FzS3pdYcw==
# SIG # End signature block
