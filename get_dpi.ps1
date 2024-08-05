# Credit: Peter Hinchley via https://hinchley.net/articles/get-the-scaling-rate-of-a-display-using-powershell/
Add-Type @'
  using System; 
  using System.Runtime.InteropServices;
  using System.Drawing;

  public class DPI {  
    [DllImport("gdi32.dll")]
    static extern int GetDeviceCaps(IntPtr hdc, int nIndex);

    public enum DeviceCap {
      VERTRES = 10,
      DESKTOPVERTRES = 117
    } 

    public static float scaling() {
      Graphics g = Graphics.FromHwnd(IntPtr.Zero);
      IntPtr desktop = g.GetHdc();
      int LogicalScreenHeight = GetDeviceCaps(desktop, (int)DeviceCap.VERTRES);
      int PhysicalScreenHeight = GetDeviceCaps(desktop, (int)DeviceCap.DESKTOPVERTRES);

      return (float)PhysicalScreenHeight / (float)LogicalScreenHeight;
    }
  }
'@ -ReferencedAssemblies 'System.Drawing.dll'

[Math]::round([DPI]::scaling(), 2) * 100
# SIG # Begin signature block
# MIIcjwYJKoZIhvcNAQcCoIIcgDCCHHwCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDIbsqeZ/pSCE1i
# Mj5Lp3h83cSOhGHZx91oQPh8DCYQN6CCC3owggW4MIIEoKADAgECAhN3AAQyJqyI
# 5iCDAqULAAAABDImMA0GCSqGSIb3DQEBCwUAMHExEzARBgoJkiaJk/IsZAEZFgNl
# ZHUxEzARBgoJkiaJk/IsZAEZFgN2Y3UxEzARBgoJkiaJk/IsZAEZFgNhZHAxFDAS
# BgoJkiaJk/IsZAEZFgRSQU1TMRowGAYDVQQDExFWQ1UgSW5mb1NlYyBTdWJDQTAe
# Fw0yNDA4MDUxMjA1NThaFw0yNTA4MDUxMjA1NThaMIGtMRMwEQYKCZImiZPyLGQB
# GRYDZWR1MRMwEQYKCZImiZPyLGQBGRYDdmN1MRMwEQYKCZImiZPyLGQBGRYDYWRw
# MRQwEgYKCZImiZPyLGQBGRYEUkFNUzEeMBwGA1UECxMVU2Nob29sIG9mIEVuZ2lu
# ZWVyaW5nMQ4wDAYDVQQLEwVVc2VyczESMBAGA1UECxMJRW1wbG95ZWVzMRIwEAYD
# VQQDEwlqZGxlb25hcmQwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDR
# kBtkDwSFsMwFoyipF+g0y/bkGvvB/6zvmCzBvDBM5bMadKUU+B8C/o4bBgOhKNtL
# XIRYHJSDzdyuhm6LqDg8OmlTrSo7wTYE0o75/Zs9ufeRuGvYTOyJx41upS4/VXhw
# b9izAo1JpTY3VqdCeqWW5pVDvJQo0Z1t0Svvb/pyjSCX9PKcTpvMXMZ25JfboYiE
# NVAA5gs/7GafTIFvRZDfyxr87JkFwuYp5HgelaF+UeUfm31O8AGzIwLX9Mhd2iY/
# Ds8REWSB6LqRKWCYmGji/rKPTYG6nvxkqKsVXgonxd2ZmC4ODRkRheGozwky6f1B
# rgtioejLW96N7hfrQHOtAgMBAAGjggIKMIICBjA+BgkrBgEEAYI3FQcEMTAvBicr
# BgEEAYI3FQiFjq5yhJy9CYfRiySFqbpLgojRSIF5g76Ib4WwiwECAWQCAQUwEwYD
# VR0lBAwwCgYIKwYBBQUHAwMwDgYDVR0PAQH/BAQDAgeAMBsGCSsGAQQBgjcVCgQO
# MAwwCgYIKwYBBQUHAwMwHQYDVR0OBBYEFBiqNejxBGoPmCJU4bL6qrILMZ5AMB8G
# A1UdIwQYMBaAFBU9I1n1ZMI0JksZb0Pw845V3DIhMEgGA1UdHwRBMD8wPaA7oDmG
# N2h0dHA6Ly9wa2kudmN1LmVkdS9DZXJ0RW5yb2xsL1ZDVSUyMEluZm9TZWMlMjBT
# dWJDQS5jcmwweAYIKwYBBQUHAQEEbDBqMEMGCCsGAQUFBzAChjdodHRwOi8vcGtp
# LnZjdS5lZHUvQ2VydEVucm9sbC9WQ1UlMjBJbmZvU2VjJTIwU3ViQ0EuY3J0MCMG
# CCsGAQUFBzABhhdodHRwOi8vcGtpLnZjdS5lZHUvb2NzcDAsBgNVHREEJTAjoCEG
# CisGAQQBgjcUAgOgEwwRamRsZW9uYXJkQHZjdS5lZHUwUAYJKwYBBAGCNxkCBEMw
# QaA/BgorBgEEAYI3GQIBoDEEL1MtMS01LTIxLTMzNjIxMzQ2NzQtMTQzNDI1NDg3
# MC02MTg0MjQwMTgtMTQyMTE5MA0GCSqGSIb3DQEBCwUAA4IBAQAVTFqrDLYG+wjB
# TFRsvr51QywO8RviYR0cPK+CQ9pKHYdatSNovLMXboREwB3eX1MOrmkbguNGKCrj
# zr3E1pAkEt/NB79m3lSRDqNqWwGipAdSzrJdUyLv9lr7dv9WVGLaFPV4IOxA+HGo
# OkGb0bwuu5rKqe/du00sbDSc4W7Ii9H3qqexiv/qvJQi4XAdHstYumauBAL/+qpt
# LXjIurJvAaYbm+c4tBRBFdSPApMPyaUNt5BQ+RHl2NmWZRubz8Y5ZrgfeizpiUtj
# +BaTilij+QYaKvxSjomXkPgb5oaUI9fbiUZcNKk/l1lLzmH1SSqZfnea2u95ipkT
# fpRwD7n9MIIFujCCA6KgAwIBAgITHwAAAAbNiK9rbBvq+AAAAAAABjANBgkqhkiG
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
# BAMTEVZDVSBJbmZvU2VjIFN1YkNBAhN3AAQyJqyI5iCDAqULAAAABDImMA0GCWCG
# SAFlAwQCAQUAoIGEMBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcN
# AQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUw
# LwYJKoZIhvcNAQkEMSIEIGd6mMkvQn44pbMFR24zYUGHqu3YDAXMbHsqL26850pZ
# MA0GCSqGSIb3DQEBAQUABIIBAC09s/YkDNAo8+IEFh/4Gs8P798DyiFyPgv8w8pt
# cI0Bn8HfnMbSkwhKJv5dE0ipDgDc11Hm3x8fobx+QchHhODMC/isj0qpK//Z7hZz
# ++eFkN9W0NTpP54LJyE/k5WXFaBX0dhIRN49gyKyGwts+Oqng9zWz0DdOmb+GX7D
# ivK4Ol+EJ5zvXwaf/T+zqf7xdIOLBoaYgqFwFqmfmp2LupVX7NOZgm0m5e9vyFiq
# 81CCGytpt4mPlGRceW/oaxe0Ua+R/xK/t8rbPebKLidZxiXYTz51GflmMtP/Obwx
# srYk2YCiijPaI4o3ic/AmXlAGvO8P2SqnOKYK8DKcHcMm2Ghgg4sMIIOKAYKKwYB
# BAGCNwMDATGCDhgwgg4UBgkqhkiG9w0BBwKggg4FMIIOAQIBAzENMAsGCWCGSAFl
# AwQCATCB/wYLKoZIhvcNAQkQAQSgge8EgewwgekCAQEGC2CGSAGG+EUBBxcDMCEw
# CQYFKw4DAhoFAAQUarVHMpLuixM9VNGXwzivngMG51ACFQC3dzwzI1MoTfCY7tB1
# sDu1/6EG8hgPMjAyNDA4MDUxMjIyMjNaMAMCAR6ggYakgYMwgYAxCzAJBgNVBAYT
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
# SIb3DQEJBTEPFw0yNDA4MDUxMjIyMjNaMC8GCSqGSIb3DQEJBDEiBCBrRDOpWO/I
# JKKhfICLDVUboY0kR/1sAgcdc8GpLPE7dDA3BgsqhkiG9w0BCRACLzEoMCYwJDAi
# BCDEdM52AH0COU4NpeTefBTGgPniggE8/vZT7123H99h+DALBgkqhkiG9w0BAQEE
# ggEASbHfuJegUUIShiQJspU+THhSv/hbSRt5mzBaTVcHzHG92HXi2d9wa6ZuZWG3
# Y0Sv+AhXE8XneZWfu6/0cc2xT+zQIZp6+RIPa4uKz0oOx237FiBl/cXs+Lk3X+fM
# Lw7X2vwYI3hBYLL+E6Pfm4bj+b0+UZeb70YBrUey18xTs5aJsSC1HM6bzu3BqjDw
# 5sK9T83hXzpUkidt/KoKxKFRZ2ktWBy9QKmRXMujiF9knmsinCefKpuI5YC789Cl
# VeqJIcIuMtOyFJI0pNtgastRnycOzYrScnmP+/9Hyof9MKPilj6e+d6c+nWMvYJu
# onXWJIneI7SlA8TV8bGHR4sB7g==
# SIG # End signature block