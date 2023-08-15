<#
.SYNOPSIS
    Sample start-up profile

.DESCRIPTION
    This sample is intented to be copied on top of the standard MS profile.

    cp sample-profile.ps1 $PROFILE

    Be sure to look at the original profile to make certain you aren't killing anything.
    You might also consier:

    cp $PROFILE ~\.mysetup\old-profile.ps1
    code sample-profile.ps1 (edit profile to call this file), then
    cp sample-profile.ps1 $PROFILE

.PARAMETER (none)
    None

.INPUTS
    No inputs required

.OUTPUTS
    No outputs

.NOTES
    Author: John Leonard
    Date: 8/14/2023
    Version: 1.0

.LINK
    None

#>

echo "Running profile: $PROFILE"

# Quarto environment settings
$env:QUARTO_PYTHON=$(pyenv which python)  # to work with pyenv
$env:DENO_NO_UPDATE_CHECK=1               # to warning about deno upgrades
$env:DENO_TLS_CA_STORE="system"           # to stop the BAD CERTIFICATE deno warning
$env:PYDEVD_DISABLE_FILE_VALIDATION=1     # for Python 3.11 above, to disable warning message RE: debugging

oh-my-posh init pwsh --config=$env:USERPROFILE\.mysetup\jleonard99.omp.json| invoke-expression

# SIG # Begin signature block
# MIIcjgYJKoZIhvcNAQcCoIIcfzCCHHsCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCDiqFwdqa4MZP5
# mJ+7TH9GSIQYUhr8bx4U1mXPCDFw1KCCC3owggW4MIIEoKADAgECAhN3AANJL5Ja
# qcsDuRSnAAAAA0kvMA0GCSqGSIb3DQEBCwUAMHExEzARBgoJkiaJk/IsZAEZFgNl
# ZHUxEzARBgoJkiaJk/IsZAEZFgN2Y3UxEzARBgoJkiaJk/IsZAEZFgNhZHAxFDAS
# BgoJkiaJk/IsZAEZFgRSQU1TMRowGAYDVQQDExFWQ1UgSW5mb1NlYyBTdWJDQTAe
# Fw0yMzA1MzExMjM5MTRaFw0yNDA1MzAxMjM5MTRaMIGtMRMwEQYKCZImiZPyLGQB
# GRYDZWR1MRMwEQYKCZImiZPyLGQBGRYDdmN1MRMwEQYKCZImiZPyLGQBGRYDYWRw
# MRQwEgYKCZImiZPyLGQBGRYEUkFNUzEeMBwGA1UECxMVU2Nob29sIG9mIEVuZ2lu
# ZWVyaW5nMQ4wDAYDVQQLEwVVc2VyczESMBAGA1UECxMJRW1wbG95ZWVzMRIwEAYD
# VQQDEwlqZGxlb25hcmQwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC9
# OtrrnvOjlaSXr+XE/6FmWOsq+qail1j4zrpgbfc35QM45I4JZ6HNbEEUgJp4tZ/H
# IfyflmyMBc3WIItjr/cPaPJK/aNDSUdC5jMj1lybx1COE9sMIJjzl4KXGXbSKMvP
# gqJd3OaN0CxZ7JZy7ofV0V3N+Jt9YDrmYEGBIepm5CKnnTESt7Q6x7KeY4yHnYR1
# 8dTINNauJRM4SzvKgqlnE0j+8pXE+GuawY53s8HGH7dupm9TpS90QnUXMVpP1hgf
# 3i5+LyBTt+AL7Q2R4csZLnzL0rjdr7fsXMCqs840V417/DXUfUMAoBvE2IkMpQvx
# MeiFLZALU2LRiNpoAS2VAgMBAAGjggIKMIICBjA+BgkrBgEEAYI3FQcEMTAvBicr
# BgEEAYI3FQiFjq5yhJy9CYfRiySFqbpLgojRSIF5g76Ib4WwiwECAWQCAQUwEwYD
# VR0lBAwwCgYIKwYBBQUHAwMwDgYDVR0PAQH/BAQDAgeAMBsGCSsGAQQBgjcVCgQO
# MAwwCgYIKwYBBQUHAwMwHQYDVR0OBBYEFDXekxubP2zIb4e9MqZHbw3U5DROMB8G
# A1UdIwQYMBaAFBU9I1n1ZMI0JksZb0Pw845V3DIhMEgGA1UdHwRBMD8wPaA7oDmG
# N2h0dHA6Ly9wa2kudmN1LmVkdS9DZXJ0RW5yb2xsL1ZDVSUyMEluZm9TZWMlMjBT
# dWJDQS5jcmwweAYIKwYBBQUHAQEEbDBqMEMGCCsGAQUFBzAChjdodHRwOi8vcGtp
# LnZjdS5lZHUvQ2VydEVucm9sbC9WQ1UlMjBJbmZvU2VjJTIwU3ViQ0EuY3J0MCMG
# CCsGAQUFBzABhhdodHRwOi8vcGtpLnZjdS5lZHUvb2NzcDAsBgNVHREEJTAjoCEG
# CisGAQQBgjcUAgOgEwwRamRsZW9uYXJkQHZjdS5lZHUwUAYJKwYBBAGCNxkCBEMw
# QaA/BgorBgEEAYI3GQIBoDEEL1MtMS01LTIxLTMzNjIxMzQ2NzQtMTQzNDI1NDg3
# MC02MTg0MjQwMTgtMTQyMTE5MA0GCSqGSIb3DQEBCwUAA4IBAQBT/ROj3cPKn/pt
# gGEes2/y+7JoR8mdTDjv5ffEJWlPWaivbxw5cz/CBaZENxOpX9GEvd2JS3WEHSjl
# TI57xTIcjWyBXCywu77UoSk7a/3Tz5U0Ks27tnNm+sphhcWncPyzzbYQ/mbQlblF
# sJO+dS7K2Eo3RMzZIMDV0ILgzRWwj09seLkqmP91CJIM0FW8GgaNNzc7E2DOKhbP
# 705x8hn31xpRPS4HCUloj86mQswyU9oElo+ccF6dsBLCQVQ8XcuaVqq0DL980fr5
# FiUHU3CvEJrJk/Bu99BnycrbGKKSxufsOb1GXvoKyDAp45A5lo9S3r14RtDKfJsF
# FSvJvdp4MIIFujCCA6KgAwIBAgITHwAAAAbNiK9rbBvq+AAAAAAABjANBgkqhkiG
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
# k4UAeguS5mDv6sqmzI2ohVbIK1f4cnFzM5Z51varyy2ettzXMYIQajCCEGYCAQEw
# gYgwcTETMBEGCgmSJomT8ixkARkWA2VkdTETMBEGCgmSJomT8ixkARkWA3ZjdTET
# MBEGCgmSJomT8ixkARkWA2FkcDEUMBIGCgmSJomT8ixkARkWBFJBTVMxGjAYBgNV
# BAMTEVZDVSBJbmZvU2VjIFN1YkNBAhN3AANJL5JaqcsDuRSnAAAAA0kvMA0GCWCG
# SAFlAwQCAQUAoIGEMBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcN
# AQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUw
# LwYJKoZIhvcNAQkEMSIEIIA+1ediV72msFb4kHf5Ap07iiddOne0tTXb60sONc6F
# MA0GCSqGSIb3DQEBAQUABIIBAKf8xmmcLKlkO27AooJ6w1tmsbuyujRUzMJ6S1mA
# Tl5d9qHyYcXyfq1S+RKF/JQIBlmgRlucziKBW198tqS4AjXDXDCFQUyz89zS4wCE
# k/897kFSfZfndqbTnKb6pbD7lVviTO2iBRyQLA1MXc4BzLInyOMkygwI6tRLE8FC
# oGP7oSvPMqujk9KaD9rO/bcX76XmJ94/wek7IB4yka59LwcUONp3jnFQfx2/gYLm
# UR+AfUOo6rB27AH3FKY67FGvSKHvO2izprwRAMnL0hUaRHYXUvghf0qwKGHIXQkQ
# ol8H77n6OGiRC2o7X3npWzLinsdW5drVeAWjt1Up4cDekBihgg4rMIIOJwYKKwYB
# BAGCNwMDATGCDhcwgg4TBgkqhkiG9w0BBwKggg4EMIIOAAIBAzENMAsGCWCGSAFl
# AwQCATCB/gYLKoZIhvcNAQkQAQSgge4EgeswgegCAQEGC2CGSAGG+EUBBxcDMCEw
# CQYFKw4DAhoFAAQU4efjOrdS0aeayJsqPKUZLFT1oFoCFGooH7hXiQhKpxp9I4ec
# wpuZ/EOEGA8yMDIzMDgxNTIwMDk1OFowAwIBHqCBhqSBgzCBgDELMAkGA1UEBhMC
# VVMxHTAbBgNVBAoTFFN5bWFudGVjIENvcnBvcmF0aW9uMR8wHQYDVQQLExZTeW1h
# bnRlYyBUcnVzdCBOZXR3b3JrMTEwLwYDVQQDEyhTeW1hbnRlYyBTSEEyNTYgVGlt
# ZVN0YW1waW5nIFNpZ25lciAtIEczoIIKizCCBTgwggQgoAMCAQICEHsFsdRJaFFE
# 98mJ0pwZnRIwDQYJKoZIhvcNAQELBQAwgb0xCzAJBgNVBAYTAlVTMRcwFQYDVQQK
# Ew5WZXJpU2lnbiwgSW5jLjEfMB0GA1UECxMWVmVyaVNpZ24gVHJ1c3QgTmV0d29y
# azE6MDgGA1UECxMxKGMpIDIwMDggVmVyaVNpZ24sIEluYy4gLSBGb3IgYXV0aG9y
# aXplZCB1c2Ugb25seTE4MDYGA1UEAxMvVmVyaVNpZ24gVW5pdmVyc2FsIFJvb3Qg
# Q2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMTYwMTEyMDAwMDAwWhcNMzEwMTEx
# MjM1OTU5WjB3MQswCQYDVQQGEwJVUzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9y
# YXRpb24xHzAdBgNVBAsTFlN5bWFudGVjIFRydXN0IE5ldHdvcmsxKDAmBgNVBAMT
# H1N5bWFudGVjIFNIQTI1NiBUaW1lU3RhbXBpbmcgQ0EwggEiMA0GCSqGSIb3DQEB
# AQUAA4IBDwAwggEKAoIBAQC7WZ1ZVU+djHJdGoGi61XzsAGtPHGsMo8Fa4aaJwAy
# l2pNyWQUSym7wtkpuS7sY7Phzz8LVpD4Yht+66YH4t5/Xm1AONSRBudBfHkcy8ut
# G7/YlZHz8O5s+K2WOS5/wSe4eDnFhKXt7a+Hjs6Nx23q0pi1Oh8eOZ3D9Jqo9ITh
# xNF8ccYGKbQ/5IMNJsN7CD5N+Qq3M0n/yjvU9bKbS+GImRr1wOkzFNbfx4Dbke7+
# vJJXcnf0zajM/gn1kze+lYhqxdz0sUvUzugJkV+1hHk1inisGTKPI8EyQRtZDqk+
# scz51ivvt9jk1R1tETqS9pPJnONI7rtTDtQ2l4Z4xaE3AgMBAAGjggF3MIIBczAO
# BgNVHQ8BAf8EBAMCAQYwEgYDVR0TAQH/BAgwBgEB/wIBADBmBgNVHSAEXzBdMFsG
# C2CGSAGG+EUBBxcDMEwwIwYIKwYBBQUHAgEWF2h0dHBzOi8vZC5zeW1jYi5jb20v
# Y3BzMCUGCCsGAQUFBwICMBkaF2h0dHBzOi8vZC5zeW1jYi5jb20vcnBhMC4GCCsG
# AQUFBwEBBCIwIDAeBggrBgEFBQcwAYYSaHR0cDovL3Muc3ltY2QuY29tMDYGA1Ud
# HwQvMC0wK6ApoCeGJWh0dHA6Ly9zLnN5bWNiLmNvbS91bml2ZXJzYWwtcm9vdC5j
# cmwwEwYDVR0lBAwwCgYIKwYBBQUHAwgwKAYDVR0RBCEwH6QdMBsxGTAXBgNVBAMT
# EFRpbWVTdGFtcC0yMDQ4LTMwHQYDVR0OBBYEFK9j1sqjToVy4Ke8QfMpojh/gHVi
# MB8GA1UdIwQYMBaAFLZ3+mlIR59TEtXC6gcydgfRlwcZMA0GCSqGSIb3DQEBCwUA
# A4IBAQB16rAt1TQZXDJF/g7h1E+meMFv1+rd3E/zociBiPenjxXmQCmt5l30otlW
# ZIRxMCrdHmEXZiBWBpgZjV1x8viXvAn9HJFHyeLojQP7zJAv1gpsTjPs1rSTyEyQ
# Y0g5QCHE3dZuiZg8tZiX6KkGtwnJj1NXQZAv4R5NTtzKEHhsQm7wtsX4YVxS9U72
# a433Snq+8839A9fZ9gOoD+NT9wp17MZ1LqpmhQSZt/gGV+HGDvbor9rsmxgfqrnj
# OgC/zoqUywHbnsc4uw9Sq9HjlANgCk2g/idtFDL8P5dA4b+ZidvkORS92uTTw+or
# WrOVWFUEfcea7CMDjYUq0v+uqWGBMIIFSzCCBDOgAwIBAgIQe9Tlr7rMBz+hASME
# IkFNEjANBgkqhkiG9w0BAQsFADB3MQswCQYDVQQGEwJVUzEdMBsGA1UEChMUU3lt
# YW50ZWMgQ29ycG9yYXRpb24xHzAdBgNVBAsTFlN5bWFudGVjIFRydXN0IE5ldHdv
# cmsxKDAmBgNVBAMTH1N5bWFudGVjIFNIQTI1NiBUaW1lU3RhbXBpbmcgQ0EwHhcN
# MTcxMjIzMDAwMDAwWhcNMjkwMzIyMjM1OTU5WjCBgDELMAkGA1UEBhMCVVMxHTAb
# BgNVBAoTFFN5bWFudGVjIENvcnBvcmF0aW9uMR8wHQYDVQQLExZTeW1hbnRlYyBU
# cnVzdCBOZXR3b3JrMTEwLwYDVQQDEyhTeW1hbnRlYyBTSEEyNTYgVGltZVN0YW1w
# aW5nIFNpZ25lciAtIEczMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
# rw6Kqvjcv2l7VBdxRwm9jTyB+HQVd2eQnP3eTgKeS3b25TY+ZdUkIG0w+d0dg+k/
# J0ozTm0WiuSNQI0iqr6nCxvSB7Y8tRokKPgbclE9yAmIJgg6+fpDI3VHcAyzX1uP
# CB1ySFdlTa8CPED39N0yOJM/5Sym81kjy4DeE035EMmqChhsVWFX0fECLMS1q/Js
# I9KfDQ8ZbK2FYmn9ToXBilIxq1vYyXRS41dsIr9Vf2/KBqs/SrcidmXs7DbylpWB
# Jiz9u5iqATjTryVAmwlT8ClXhVhe6oVIQSGH5d600yaye0BTWHmOUjEGTZQDRcTO
# PAPstwDyOiLFtG/l77CKmwIDAQABo4IBxzCCAcMwDAYDVR0TAQH/BAIwADBmBgNV
# HSAEXzBdMFsGC2CGSAGG+EUBBxcDMEwwIwYIKwYBBQUHAgEWF2h0dHBzOi8vZC5z
# eW1jYi5jb20vY3BzMCUGCCsGAQUFBwICMBkaF2h0dHBzOi8vZC5zeW1jYi5jb20v
# cnBhMEAGA1UdHwQ5MDcwNaAzoDGGL2h0dHA6Ly90cy1jcmwud3Muc3ltYW50ZWMu
# Y29tL3NoYTI1Ni10c3MtY2EuY3JsMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMIMA4G
# A1UdDwEB/wQEAwIHgDB3BggrBgEFBQcBAQRrMGkwKgYIKwYBBQUHMAGGHmh0dHA6
# Ly90cy1vY3NwLndzLnN5bWFudGVjLmNvbTA7BggrBgEFBQcwAoYvaHR0cDovL3Rz
# LWFpYS53cy5zeW1hbnRlYy5jb20vc2hhMjU2LXRzcy1jYS5jZXIwKAYDVR0RBCEw
# H6QdMBsxGTAXBgNVBAMTEFRpbWVTdGFtcC0yMDQ4LTYwHQYDVR0OBBYEFKUTAamf
# hcwbbhYeXzsxqnk2AHsdMB8GA1UdIwQYMBaAFK9j1sqjToVy4Ke8QfMpojh/gHVi
# MA0GCSqGSIb3DQEBCwUAA4IBAQBGnq/wuKJfoplIz6gnSyHNsrmmcnBjL+NVKXs5
# Rk7nfmUGWIu8V4qSDQjYELo2JPoKe/s702K/SpQV5oLbilRt/yj+Z89xP+YzCdmi
# WRD0Hkr+Zcze1GvjUil1AEorpczLm+ipTfe0F1mSQcO3P4bm9sB/RDxGXBda46Q7
# 1Wkm1SF94YBnfmKst04uFZrlnCOvWxHqcalB+Q15OKmhDc+0sdo+mnrHIsV0zd9H
# CYbE/JElshuW6YUI6N3qdGBuYKVWeg3IRFjc5vlIFJ7lv94AvXexmBRyFCTfxxEs
# HwA/w0sUxmcczB4Go5BfXFSLPuMzW4IPxbeGAk5xn+lmRT92MYICWjCCAlYCAQEw
# gYswdzELMAkGA1UEBhMCVVMxHTAbBgNVBAoTFFN5bWFudGVjIENvcnBvcmF0aW9u
# MR8wHQYDVQQLExZTeW1hbnRlYyBUcnVzdCBOZXR3b3JrMSgwJgYDVQQDEx9TeW1h
# bnRlYyBTSEEyNTYgVGltZVN0YW1waW5nIENBAhB71OWvuswHP6EBIwQiQU0SMAsG
# CWCGSAFlAwQCAaCBpDAaBgkqhkiG9w0BCQMxDQYLKoZIhvcNAQkQAQQwHAYJKoZI
# hvcNAQkFMQ8XDTIzMDgxNTIwMDk1OFowLwYJKoZIhvcNAQkEMSIEICBMRNys/79x
# Cw9HP3yWnORJH4zoMUw6RwfKyYCC+pxoMDcGCyqGSIb3DQEJEAIvMSgwJjAkMCIE
# IMR0znYAfQI5Tg2l5N58FMaA+eKCATz+9lPvXbcf32H4MAsGCSqGSIb3DQEBAQSC
# AQBjYQ+Hy6zqlRUtgqvBdGE2I2Urci0lkdyyCwHDje8D3rI/r2+Pft9VkeYgmr1w
# vJbv+jWSOE1a/OCbG+32z+Qf2CXnRyWvE9N2xcywMcr7L9evYBQajX+DftWwzbjY
# U5MJ9trWhSEFpZWlABPbS59Z4EoUMlt5vSroxSzaJvFHsJZVfEyv+a0hXp5yh+Uu
# vPYqIlS48M6v5ZG191UPzOBYtAyIhMo3zbGTjnksDRP/zj9bzFv6CSW94/ExJ4Lc
# LmJGfSWVgYTaI763EO1qIsNHebJ2akHFU16GRjYg0xOnheunkPJJHpt7Mvw4JflG
# juKQlTkTf8b2ZvzniDDe8c0K
# SIG # End signature block
