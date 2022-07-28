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
function setRtools
{
# Setting environment for RTOOLS
# Update as versions of RTOOLS and R change
#$ENV:R_HOME="H:\VDI\R"
#

$ENV:FINROOT="C:\FinReports"
$ENV:R_ENVIRON_USER="C:\FinReports\R_USER\.Renviron"
$ENV:R_PROFILE_USER="C:\FinReports\R_USER\.Rprofile"

## These change for new versions.  The R_LIBS_USER
## is set in the .Renviron file
#
#$ENV:R_VERSION="3.4.4"
#$ENV:R_TOOLS="3.4"

$ENV:R_VERSION="3.5.3"
$ENV:R_TOOLS="3.5"

## these should need to change on new versions
$ENV:R_GCC="mingw_64"
#$ENV:R_MAX_MEM_SIZE="20G"
#
#  Add path for R-program base
$ENV:PATH="$ENV:PATH;$ENV:FINROOT\R\$ENV:R_VERSION\bin\x64"
#
#  Add path for RTOOLS version set in the R_TOOLS variable above
$ENV:PATH="$ENV:PATH;$ENV:FINROOT\Rtools\$ENV:R_TOOLS\bin;$ENV:FINROOT\Rtools\$ENV:R_TOOLS\$ENV:R_GCC\bin"
# 
#
#
#  Add path for Perl
$ENV:PERL_VERSION="5.22"
$ENV:PATH="$ENV:PATH;$ENV:FINROOT\Perl64\$ENV:PERL_VERSION\site\bin;$ENV:FINROOT\Perl64\$ENV:PERL_VERSION\bin"
$ENV:PERL5LIB="$ENV:FINROOT\Perl64\$ENV:PERL_VERSION\site\lib;$ENV:FINROOT\Perl64\$ENV:PERL_VERSION\lib"
# 
#
#  For GIT version control (RTools should be called before GIT)
#$ENV:PATH="$ENV:PATH;C:\Program Files\Git\cmd;C:\Program Files\Git\bin"
#
#  
$ENV:SVN_EDITOR="notepad"
$ENV:EDITOR="notepad"
$ENV:CYGWIN="nodosfilewarning"
$ENV:R_GSCMD = "C:/Program Files/gs/gs9.05/bin/gswin32c.exe"
# 
#  R is available at:  http://cran.r-project.org/bin/windows/base/  (old versions also available)
#  RTOOLS is available at:  https://cran.r-project.org/bin/windows/Rtools/
#  RTOOLS must be updated to "match" different versions of R.  See cran for details.
#  By default RTOOLS doesn't install into version-specific subdirectories. YOU NEED TO DO IT!

write-host "RTOOLS environment set. R:$ENV:R_VERSION  RTOOLS:$ENV:R_TOOLS GCC:$ENV:R_GCC  Perl:$ENV:PERL_VERSION  GIT:Yes  Anaconda:$ENV:ANA3"
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
#setRtools

#}

# SIG # Begin signature block
# MIIcagYJKoZIhvcNAQcCoIIcWzCCHFcCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUqTMD43mkwtyalbEeWxI761Is
# jXigggt6MIIFuDCCBKCgAwIBAgITdwAC96VQTwWUspS0jwAAAAL3pTANBgkqhkiG
# 9w0BAQsFADBxMRMwEQYKCZImiZPyLGQBGRYDZWR1MRMwEQYKCZImiZPyLGQBGRYD
# dmN1MRMwEQYKCZImiZPyLGQBGRYDYWRwMRQwEgYKCZImiZPyLGQBGRYEUkFNUzEa
# MBgGA1UEAxMRVkNVIEluZm9TZWMgU3ViQ0EwHhcNMjIwNjA3MTY1MzA4WhcNMjMw
# NjA3MTY1MzA4WjCBrTETMBEGCgmSJomT8ixkARkWA2VkdTETMBEGCgmSJomT8ixk
# ARkWA3ZjdTETMBEGCgmSJomT8ixkARkWA2FkcDEUMBIGCgmSJomT8ixkARkWBFJB
# TVMxHjAcBgNVBAsTFVNjaG9vbCBvZiBFbmdpbmVlcmluZzEOMAwGA1UECxMFVXNl
# cnMxEjAQBgNVBAsTCUVtcGxveWVlczESMBAGA1UEAxMJamRsZW9uYXJkMIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA8Z6F+LbBkIPdPqzbLxMkiKWuL9Xq
# O92Wsxch2HA/Dr3dqIwzhSrkst0rsj+6Mk0lLGCHsb41mCFeyESgSEKgg/u/Zcm3
# DuChQCZVuWCXrk/1JXiCoct8yzpJ4jHK3hvqAwJXDmjZVyWU8VpTOeU3+wCFIPkG
# Cjar7//3SHnIwRXEvYAfQiCMi1xm5TJBAUg8713ujWM1KPzys7XV0WcX3xcMVxxQ
# 474IrxQtO0eRBRjQ3aoG642yHU8wXRaMzFsfJQQd0ZBmF8rphX7k76azYRAgzXDs
# o2T/3T3+s9OBFEb5Tr6v+FvTvBSLQhnQ1/lHTuzcrq7SHc6w+4QBjwk9xQIDAQAB
# o4ICCjCCAgYwPgYJKwYBBAGCNxUHBDEwLwYnKwYBBAGCNxUIhY6ucoScvQmH0Ysk
# ham6S4KI0UiBeYO+iG+FsIsBAgFkAgEFMBMGA1UdJQQMMAoGCCsGAQUFBwMDMA4G
# A1UdDwEB/wQEAwIHgDAbBgkrBgEEAYI3FQoEDjAMMAoGCCsGAQUFBwMDMB0GA1Ud
# DgQWBBTXIyvyDRFprQTRkfbK79PJgrV+SzAfBgNVHSMEGDAWgBQVPSNZ9WTCNCZL
# GW9D8POOVdwyITBIBgNVHR8EQTA/MD2gO6A5hjdodHRwOi8vcGtpLnZjdS5lZHUv
# Q2VydEVucm9sbC9WQ1UlMjBJbmZvU2VjJTIwU3ViQ0EuY3JsMHgGCCsGAQUFBwEB
# BGwwajBDBggrBgEFBQcwAoY3aHR0cDovL3BraS52Y3UuZWR1L0NlcnRFbnJvbGwv
# VkNVJTIwSW5mb1NlYyUyMFN1YkNBLmNydDAjBggrBgEFBQcwAYYXaHR0cDovL3Br
# aS52Y3UuZWR1L29jc3AwLAYDVR0RBCUwI6AhBgorBgEEAYI3FAIDoBMMEWpkbGVv
# bmFyZEB2Y3UuZWR1MFAGCSsGAQQBgjcZAgRDMEGgPwYKKwYBBAGCNxkCAaAxBC9T
# LTEtNS0yMS0zMzYyMTM0Njc0LTE0MzQyNTQ4NzAtNjE4NDI0MDE4LTE0MjExOTAN
# BgkqhkiG9w0BAQsFAAOCAQEAkJCu4BWXZSCzjDIImO1MbNfSfawZ258r0Up5tQB3
# 3NGs8q/OlPWlrVUrhL4HylKxPPwCeDbM+OqSnCij/dvavPMVmCUAjLOyu20NoXQz
# SDYhnNZ4NCM2K2UyCh1lzcww2dl0Y79tfv0z+02Ysm42rTo4Op/vqr6dNR4YfP0l
# 7sbTiAw0rvMwzyi+bC58I3cDPDM2OE7oTCzFdAeOWth7Lz9Looq20QGm/CfQyadq
# UORu/CY+oGgjs8SQusMjeZ4/VVUWZF/FbC5BtpBm4MHEw/ZCfRvaj9qWdODKF5wH
# U4ZfjgGSBqMI3ma+cKOrJ3TCxQ3G1jqqfJT5CYbBAQKP2zCCBbowggOioAMCAQIC
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
# +HJxczOWedb2q8stnrbc1zGCEFowghBWAgEBMIGIMHExEzARBgoJkiaJk/IsZAEZ
# FgNlZHUxEzARBgoJkiaJk/IsZAEZFgN2Y3UxEzARBgoJkiaJk/IsZAEZFgNhZHAx
# FDASBgoJkiaJk/IsZAEZFgRSQU1TMRowGAYDVQQDExFWQ1UgSW5mb1NlYyBTdWJD
# QQITdwAC96VQTwWUspS0jwAAAAL3pTAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIB
# DDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEE
# AYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUSPAh3Mdut9oD
# Y74uV5/55xR/ugAwDQYJKoZIhvcNAQEBBQAEggEAwCbWpq+cmu+UXhgvZ6dEdNOv
# LynnoItYKb49nF2oxFL/PCTIIhM/jUIKi02X1DFoO9R1xAszBRj4ewHkMs49DJkI
# 552+Rye2Gp09p6HoY1RB8AzUUYDSPfUI/IYC0TBKxPKD+yqplSHegHtyiecdUWu6
# uojKUiwwLgPjrW4GvGnG5HssCZkpqJvtabkPTVzDWZKeI3ciwDWu8W4vm+j6Qanz
# tKS7T82PX5r7BC2miHoPM0aBe/obCiGU9T0L7RWN0NZDVbg8zoxJaEfydXGJN1Fb
# jPLUWOunmQBzIWnDAFbBPuwaDNkWL96aHNDiM2R7Os/11dFYeqgq9yyRP6egk6GC
# Diwwgg4oBgorBgEEAYI3AwMBMYIOGDCCDhQGCSqGSIb3DQEHAqCCDgUwgg4BAgED
# MQ0wCwYJYIZIAWUDBAIBMIH/BgsqhkiG9w0BCRABBKCB7wSB7DCB6QIBAQYLYIZI
# AYb4RQEHFwMwITAJBgUrDgMCGgUABBQWK8ZwJDDzn9vtFlkM+iM4xH01JQIVAI2N
# KhMZLzP+/ynTlxbJtZLacc5JGA8yMDIyMDcxOTE5MDAwMlowAwIBHqCBhqSBgzCB
# gDELMAkGA1UEBhMCVVMxHTAbBgNVBAoTFFN5bWFudGVjIENvcnBvcmF0aW9uMR8w
# HQYDVQQLExZTeW1hbnRlYyBUcnVzdCBOZXR3b3JrMTEwLwYDVQQDEyhTeW1hbnRl
# YyBTSEEyNTYgVGltZVN0YW1waW5nIFNpZ25lciAtIEczoIIKizCCBTgwggQgoAMC
# AQICEHsFsdRJaFFE98mJ0pwZnRIwDQYJKoZIhvcNAQELBQAwgb0xCzAJBgNVBAYT
# AlVTMRcwFQYDVQQKEw5WZXJpU2lnbiwgSW5jLjEfMB0GA1UECxMWVmVyaVNpZ24g
# VHJ1c3QgTmV0d29yazE6MDgGA1UECxMxKGMpIDIwMDggVmVyaVNpZ24sIEluYy4g
# LSBGb3IgYXV0aG9yaXplZCB1c2Ugb25seTE4MDYGA1UEAxMvVmVyaVNpZ24gVW5p
# dmVyc2FsIFJvb3QgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMTYwMTEyMDAw
# MDAwWhcNMzEwMTExMjM1OTU5WjB3MQswCQYDVQQGEwJVUzEdMBsGA1UEChMUU3lt
# YW50ZWMgQ29ycG9yYXRpb24xHzAdBgNVBAsTFlN5bWFudGVjIFRydXN0IE5ldHdv
# cmsxKDAmBgNVBAMTH1N5bWFudGVjIFNIQTI1NiBUaW1lU3RhbXBpbmcgQ0EwggEi
# MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC7WZ1ZVU+djHJdGoGi61XzsAGt
# PHGsMo8Fa4aaJwAyl2pNyWQUSym7wtkpuS7sY7Phzz8LVpD4Yht+66YH4t5/Xm1A
# ONSRBudBfHkcy8utG7/YlZHz8O5s+K2WOS5/wSe4eDnFhKXt7a+Hjs6Nx23q0pi1
# Oh8eOZ3D9Jqo9IThxNF8ccYGKbQ/5IMNJsN7CD5N+Qq3M0n/yjvU9bKbS+GImRr1
# wOkzFNbfx4Dbke7+vJJXcnf0zajM/gn1kze+lYhqxdz0sUvUzugJkV+1hHk1inis
# GTKPI8EyQRtZDqk+scz51ivvt9jk1R1tETqS9pPJnONI7rtTDtQ2l4Z4xaE3AgMB
# AAGjggF3MIIBczAOBgNVHQ8BAf8EBAMCAQYwEgYDVR0TAQH/BAgwBgEB/wIBADBm
# BgNVHSAEXzBdMFsGC2CGSAGG+EUBBxcDMEwwIwYIKwYBBQUHAgEWF2h0dHBzOi8v
# ZC5zeW1jYi5jb20vY3BzMCUGCCsGAQUFBwICMBkaF2h0dHBzOi8vZC5zeW1jYi5j
# b20vcnBhMC4GCCsGAQUFBwEBBCIwIDAeBggrBgEFBQcwAYYSaHR0cDovL3Muc3lt
# Y2QuY29tMDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9zLnN5bWNiLmNvbS91bml2
# ZXJzYWwtcm9vdC5jcmwwEwYDVR0lBAwwCgYIKwYBBQUHAwgwKAYDVR0RBCEwH6Qd
# MBsxGTAXBgNVBAMTEFRpbWVTdGFtcC0yMDQ4LTMwHQYDVR0OBBYEFK9j1sqjToVy
# 4Ke8QfMpojh/gHViMB8GA1UdIwQYMBaAFLZ3+mlIR59TEtXC6gcydgfRlwcZMA0G
# CSqGSIb3DQEBCwUAA4IBAQB16rAt1TQZXDJF/g7h1E+meMFv1+rd3E/zociBiPen
# jxXmQCmt5l30otlWZIRxMCrdHmEXZiBWBpgZjV1x8viXvAn9HJFHyeLojQP7zJAv
# 1gpsTjPs1rSTyEyQY0g5QCHE3dZuiZg8tZiX6KkGtwnJj1NXQZAv4R5NTtzKEHhs
# Qm7wtsX4YVxS9U72a433Snq+8839A9fZ9gOoD+NT9wp17MZ1LqpmhQSZt/gGV+HG
# Dvbor9rsmxgfqrnjOgC/zoqUywHbnsc4uw9Sq9HjlANgCk2g/idtFDL8P5dA4b+Z
# idvkORS92uTTw+orWrOVWFUEfcea7CMDjYUq0v+uqWGBMIIFSzCCBDOgAwIBAgIQ
# e9Tlr7rMBz+hASMEIkFNEjANBgkqhkiG9w0BAQsFADB3MQswCQYDVQQGEwJVUzEd
# MBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xHzAdBgNVBAsTFlN5bWFudGVj
# IFRydXN0IE5ldHdvcmsxKDAmBgNVBAMTH1N5bWFudGVjIFNIQTI1NiBUaW1lU3Rh
# bXBpbmcgQ0EwHhcNMTcxMjIzMDAwMDAwWhcNMjkwMzIyMjM1OTU5WjCBgDELMAkG
# A1UEBhMCVVMxHTAbBgNVBAoTFFN5bWFudGVjIENvcnBvcmF0aW9uMR8wHQYDVQQL
# ExZTeW1hbnRlYyBUcnVzdCBOZXR3b3JrMTEwLwYDVQQDEyhTeW1hbnRlYyBTSEEy
# NTYgVGltZVN0YW1waW5nIFNpZ25lciAtIEczMIIBIjANBgkqhkiG9w0BAQEFAAOC
# AQ8AMIIBCgKCAQEArw6Kqvjcv2l7VBdxRwm9jTyB+HQVd2eQnP3eTgKeS3b25TY+
# ZdUkIG0w+d0dg+k/J0ozTm0WiuSNQI0iqr6nCxvSB7Y8tRokKPgbclE9yAmIJgg6
# +fpDI3VHcAyzX1uPCB1ySFdlTa8CPED39N0yOJM/5Sym81kjy4DeE035EMmqChhs
# VWFX0fECLMS1q/JsI9KfDQ8ZbK2FYmn9ToXBilIxq1vYyXRS41dsIr9Vf2/KBqs/
# SrcidmXs7DbylpWBJiz9u5iqATjTryVAmwlT8ClXhVhe6oVIQSGH5d600yaye0BT
# WHmOUjEGTZQDRcTOPAPstwDyOiLFtG/l77CKmwIDAQABo4IBxzCCAcMwDAYDVR0T
# AQH/BAIwADBmBgNVHSAEXzBdMFsGC2CGSAGG+EUBBxcDMEwwIwYIKwYBBQUHAgEW
# F2h0dHBzOi8vZC5zeW1jYi5jb20vY3BzMCUGCCsGAQUFBwICMBkaF2h0dHBzOi8v
# ZC5zeW1jYi5jb20vcnBhMEAGA1UdHwQ5MDcwNaAzoDGGL2h0dHA6Ly90cy1jcmwu
# d3Muc3ltYW50ZWMuY29tL3NoYTI1Ni10c3MtY2EuY3JsMBYGA1UdJQEB/wQMMAoG
# CCsGAQUFBwMIMA4GA1UdDwEB/wQEAwIHgDB3BggrBgEFBQcBAQRrMGkwKgYIKwYB
# BQUHMAGGHmh0dHA6Ly90cy1vY3NwLndzLnN5bWFudGVjLmNvbTA7BggrBgEFBQcw
# AoYvaHR0cDovL3RzLWFpYS53cy5zeW1hbnRlYy5jb20vc2hhMjU2LXRzcy1jYS5j
# ZXIwKAYDVR0RBCEwH6QdMBsxGTAXBgNVBAMTEFRpbWVTdGFtcC0yMDQ4LTYwHQYD
# VR0OBBYEFKUTAamfhcwbbhYeXzsxqnk2AHsdMB8GA1UdIwQYMBaAFK9j1sqjToVy
# 4Ke8QfMpojh/gHViMA0GCSqGSIb3DQEBCwUAA4IBAQBGnq/wuKJfoplIz6gnSyHN
# srmmcnBjL+NVKXs5Rk7nfmUGWIu8V4qSDQjYELo2JPoKe/s702K/SpQV5oLbilRt
# /yj+Z89xP+YzCdmiWRD0Hkr+Zcze1GvjUil1AEorpczLm+ipTfe0F1mSQcO3P4bm
# 9sB/RDxGXBda46Q71Wkm1SF94YBnfmKst04uFZrlnCOvWxHqcalB+Q15OKmhDc+0
# sdo+mnrHIsV0zd9HCYbE/JElshuW6YUI6N3qdGBuYKVWeg3IRFjc5vlIFJ7lv94A
# vXexmBRyFCTfxxEsHwA/w0sUxmcczB4Go5BfXFSLPuMzW4IPxbeGAk5xn+lmRT92
# MYICWjCCAlYCAQEwgYswdzELMAkGA1UEBhMCVVMxHTAbBgNVBAoTFFN5bWFudGVj
# IENvcnBvcmF0aW9uMR8wHQYDVQQLExZTeW1hbnRlYyBUcnVzdCBOZXR3b3JrMSgw
# JgYDVQQDEx9TeW1hbnRlYyBTSEEyNTYgVGltZVN0YW1waW5nIENBAhB71OWvuswH
# P6EBIwQiQU0SMAsGCWCGSAFlAwQCAaCBpDAaBgkqhkiG9w0BCQMxDQYLKoZIhvcN
# AQkQAQQwHAYJKoZIhvcNAQkFMQ8XDTIyMDcxOTE5MDAwMlowLwYJKoZIhvcNAQkE
# MSIEIFMv4+2HPZs4Cdbdwg34tKJTcTQ+fUQ2MAM2TOFFpDQ0MDcGCyqGSIb3DQEJ
# EAIvMSgwJjAkMCIEIMR0znYAfQI5Tg2l5N58FMaA+eKCATz+9lPvXbcf32H4MAsG
# CSqGSIb3DQEBAQSCAQCTbFtOGsw8kbgUnvoVHKeCDRJNXnOaHO4OiFqogbzmFWMR
# H0a0clbhGGdkjvmElIuJG2NJJX3m7PDx/u6jOl2olXnXJIMHCOowduVxv66sgxVQ
# 3uwkyplEkYu49Roxg1JN2FKubIRWNNvFNfgfytxaZbbzItbapmr6MnxaAGQWWNC9
# CCwpF5MoGPNvXnWiYSuG7W5igF8UMFxiGpPzMkQOHv6GQvRdh32WlDz7UlPL1zKb
# 4ixOtTmDeYU0JgAzMgRMWw7soLJBBUIVM2LGJrMQci83lebKGd4pGuOhMuQ2MaET
# wvwaQUuyvOJ3nTQgquKyJLwhqpmMO89SnnEBno6/
# SIG # End signature block
