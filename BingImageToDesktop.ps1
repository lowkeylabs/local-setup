
#Location to store original image 
    $saveLocation = 'C:\Users\jdleonard\Projects\local-setup\backgroundDefault.jpg'
#Location to store image with title added to it. Group Policy should point to this image.
    $saveLocationWithDescriptionAdded = 'C:\Users\jdleonard\Projects\local-setup\backgroundDefault1.jpg'
 
#Height From Bottom in Pixels. This controls how far up from the bottom that the next is written. Should not be lower than 21. Set to 75 for the text to appear above taskbar if used as desktop background.
    $HeightfromBottom = 50
 

#Download Bing Image to SaveLocation
$uri = "https://www.bing.com/HPImageArchive.aspx?format=rss&idx=1&n=1&mkt=en-US"

<#
[xml]$BingImage = Invoke-WebRequest -Uri $uri -SessionVariable Bing -ContentType "text/xml; charset=utf-8" -Method Get
$CurrentImage = $BingImage.rss.channel.item
 
#Microsoft provides several different resolutions. This script grabs the 1920x1080. Remove the .Replace* to keep the 1366x768 version.
$ImageURL = "https://www.bing.com" + ($CurrentImage.link).Replace("1366x768.jpg","1920x1080.jpg")
## Invoke-WebRequest $ImageURL -OutFile $savelocation 
 
#>

#### 
$json = (irm "bing.com/HPImageArchive.aspx?format=js&mkt=en-IN&n=1")
$Description = $json.images[0].title
irm "bing.com$($json.images[0].url)" -OutFile $savelocation

 
#Get Bing Image Title
<#
$Title = Invoke-WebRequest -Uri $uri -SessionVariable Bing -ContentType "text/xml; charset=utf-8" -Method Get -OutFile C:\Users\Public\title.txt
$Title = (Get-Content C:\Users\Public\title.txt -Encoding UTF8)
$Title = $Title -split '>' 
$Title = $Title.Item(12)
$Description = $Title.Replace('</title',"")
Remove-Item C:\Users\Public\title.txt -Force
#>

write-output "Description: $Description"
[system.environment]::setenvironmentvariable("BGIMAGETITLE",$Description)

#Find Rough Description Pixel Length. 8.35 is average pixel size of a letter a 14 Ariel font.
[int]$DescriptionPixelLength = ($Description.Length)*8.35
[int]$MiddleStartingPoint = 960 - ($DescriptionPixelLength/2)
 
 
#Get Average Color of bottom left corner of picture
Add-Type -Assembly System.Drawing
$filename = "$saveLocation"
$BitMap = [System.Drawing.Bitmap]::FromFile((Get-Item $filename).fullname) 
 
$Colors = @()
Foreach($y in (($Bitmap.Height-$HeightfromBottom)..($BitMap.Height-($HeightfromBottom-20)))){ 
        Foreach($x in ($MiddleStartingPoint..(($MiddleStartingPoint+$DescriptionPixelLength)))){ 
             
             $Pixel = $BitMap.GetPixel($X,$Y) 
 
                $R = $Pixel | select -ExpandProperty R
                $G = $Pixel | select -ExpandProperty G
                $B = $Pixel | select -ExpandProperty B
                $A = $Pixel | select -ExpandProperty A
 
                $Color = New-Object -TypeName psobject -Property ([ordered] @{
                                R = $R
                                G = $G
                                B = $B
                                A = $A
                                })
 
                $Colors += $Color
 
        }
}
 
#Big thanks to Andrew for finding this out the used by another process bug.
$BitMap.Dispose()
 
$AverageColor = New-Object -TypeName psobject -Property ([ordered] @{
                                R = $Colors.R | Measure-Object -Average | select -ExpandProperty Average
                                G = $Colors.G | Measure-Object -Average | select -ExpandProperty Average
                                B = $Colors.B | Measure-Object -Average | select -ExpandProperty Average
                                A = $Colors.A | Measure-Object -Average | select -ExpandProperty Average
                                })
 
 
#Set Font RGB values for image title text
if ($AverageColor.R -lt 128){$FontColorR = 255} 
if ($AverageColor.G -lt 128){$FontColorG = 255} 
if ($AverageColor.B -lt 128){$FontColorB = 255} 
 
if ($AverageColor.R -ge 128){$FontColorR = 0} 
if ($AverageColor.G -ge 128){$FontColorG = 0} 
if ($AverageColor.B -ge 128){$FontColorB = 0} 
 
 
#Converts Font Color to Black or White
if (($FontColorR + $FontColorB + $FontColorG) -ge 510){$FontColorR = 255; $FontColorG = 255; $FontColorB = 255} 
if (($FontColorR + $FontColorB + $FontColorG) -lt 510){$FontColorR = 0  ; $FontColorG = 0  ; $FontColorB = 0  } 
 
 
#Add Bing Image Title to lower left corner of image. Orignal code from http://www.ravichaganti.com/blog/?p=1012
Function Add-TextToImage {
    [CmdletBinding()]
    PARAM (
        [Parameter(Mandatory=$true)][String] $sourcePath,
        [Parameter(Mandatory=$true)][String] $destPath,
        [Parameter(Mandatory=$true)][String] $Title
    )
 
    Write-Verbose "Load System.Drawing"
    [Reflection.Assembly]::LoadWithPartialName("System.Drawing") | Out-Null
     
    Write-Verbose "Get the image from $sourcePath"
    $srcImg = [System.Drawing.Image]::FromFile($sourcePath)
     
    Write-Verbose "Create a bitmap as $destPath"
    $bmpFile = new-object System.Drawing.Bitmap([int]($srcImg.width)),([int]($srcImg.height))
 
    Write-Verbose "Intialize Graphics"
    $Image = [System.Drawing.Graphics]::FromImage($bmpFile)
    $Image.SmoothingMode = "AntiAlias"
     
    $Rectangle = New-Object Drawing.Rectangle 0, 0, $srcImg.Width, $srcImg.Height
    $Bottom = $srcImg.Height - $HeightfromBottom
    $Image.DrawImage($srcImg, $Rectangle, 0, 0, $srcImg.Width, $srcImg.Height, ([Drawing.GraphicsUnit]::Pixel))
 
    Write-Verbose "Draw title: $Title"
    $Font = new-object System.Drawing.Font("Arial", 14)
    $Brush = New-Object Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(240,$FontColorR,$FontColorG,$FontColorB))
    $Image.DrawString($Title, $Font, $Brush, $MiddleStartingPoint, $Bottom)
    
    Write-Verbose "Save and close the files"
    $bmpFile.Save($savelocationwithdescriptionadded,[System.Drawing.Imaging.ImageFormat]::JPEG)
    $bmpFile.Dispose()
    $srcImg.Dispose()
}
 
Add-TextToImage -sourcePath $savelocation -destPath $savelocationwithdescriptionadded -Title $Description


# SIG # Begin signature block
# MIIcagYJKoZIhvcNAQcCoIIcWzCCHFcCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUDlS112jLqFp4H1DU/grHYdU6
# 3bagggt6MIIFuDCCBKCgAwIBAgITdwADHyGEzSvvnOHjlQAAAAMfITANBgkqhkiG
# 9w0BAQsFADBxMRMwEQYKCZImiZPyLGQBGRYDZWR1MRMwEQYKCZImiZPyLGQBGRYD
# dmN1MRMwEQYKCZImiZPyLGQBGRYDYWRwMRQwEgYKCZImiZPyLGQBGRYEUkFNUzEa
# MBgGA1UEAxMRVkNVIEluZm9TZWMgU3ViQ0EwHhcNMjIxMjE0MTI1NDA1WhcNMjMx
# MjE0MTI1NDA1WjCBrTETMBEGCgmSJomT8ixkARkWA2VkdTETMBEGCgmSJomT8ixk
# ARkWA3ZjdTETMBEGCgmSJomT8ixkARkWA2FkcDEUMBIGCgmSJomT8ixkARkWBFJB
# TVMxHjAcBgNVBAsTFVNjaG9vbCBvZiBFbmdpbmVlcmluZzEOMAwGA1UECxMFVXNl
# cnMxEjAQBgNVBAsTCUVtcGxveWVlczESMBAGA1UEAxMJamRsZW9uYXJkMIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1H/K+BJOCnI+JluymsG4etDGqhKI
# oZdhqlGyGonAef9lb8Uz/k3X4jWwCVSfzJfiW9xOxAabzcM7QURFEi4ouNNsap/i
# Y5fKbulo+9I8HqisFaEYtSH1hs80pKwd6lTwidjn8b0EKvflK5RkEHxNwtG+dw8c
# cGf/9fPQkkJQS069322JzyoGvKO7uXcjQdhSNW4vXoDKeHvs3Pa0BOlDeZl61Srk
# NGhiQWfG4lKQ1n4s0H4a1B0jijXsafcnJD8rx6QI9WBqIZGBNBYVap3z1wlcu+WE
# Aa4fiZbmiAsSv5TGseOUu/nwtS5CB/CeVv1cXrEYzFVJxN62EV/DqlC7sQIDAQAB
# o4ICCjCCAgYwPgYJKwYBBAGCNxUHBDEwLwYnKwYBBAGCNxUIhY6ucoScvQmH0Ysk
# ham6S4KI0UiBeYO+iG+FsIsBAgFkAgEFMBMGA1UdJQQMMAoGCCsGAQUFBwMDMA4G
# A1UdDwEB/wQEAwIHgDAbBgkrBgEEAYI3FQoEDjAMMAoGCCsGAQUFBwMDMB0GA1Ud
# DgQWBBQuryp3LZezz4n5ke7AEg9cqEF1azAfBgNVHSMEGDAWgBQVPSNZ9WTCNCZL
# GW9D8POOVdwyITBIBgNVHR8EQTA/MD2gO6A5hjdodHRwOi8vcGtpLnZjdS5lZHUv
# Q2VydEVucm9sbC9WQ1UlMjBJbmZvU2VjJTIwU3ViQ0EuY3JsMHgGCCsGAQUFBwEB
# BGwwajBDBggrBgEFBQcwAoY3aHR0cDovL3BraS52Y3UuZWR1L0NlcnRFbnJvbGwv
# VkNVJTIwSW5mb1NlYyUyMFN1YkNBLmNydDAjBggrBgEFBQcwAYYXaHR0cDovL3Br
# aS52Y3UuZWR1L29jc3AwLAYDVR0RBCUwI6AhBgorBgEEAYI3FAIDoBMMEWpkbGVv
# bmFyZEB2Y3UuZWR1MFAGCSsGAQQBgjcZAgRDMEGgPwYKKwYBBAGCNxkCAaAxBC9T
# LTEtNS0yMS0zMzYyMTM0Njc0LTE0MzQyNTQ4NzAtNjE4NDI0MDE4LTE0MjExOTAN
# BgkqhkiG9w0BAQsFAAOCAQEANSoRnBOOrazC205T8RUixO7u3oOK2P8HM12r3WSs
# RPVOiIFsfNCf4yWWw3lVlmMEHv6g5QfSA/0INQgbPmhBjNlYMBKy98H9nPU4ANnl
# p3qkqvCGjLN1ZwIKelNlj5+cKMguoYqFE1gm0DXJThLPt4zAiM9H9Prvh3lyoYTe
# l767W4mgxTcEfQB1e1BewkNyFcXp962McZUMHPXSdOCBv4nCi3XBoEP1RtNguYM0
# EBv17FMUz5NA4KqH2dz913d9iFVDmCsCcgPb3QToh4BqM8M6PEXVXN0nnM9OjsTF
# C1/o/ZaT17UyjqneM4N4tJLDbIU0yip2AZvlte6weFx2mDCCBbowggOioAMCAQIC
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
# QQITdwADHyGEzSvvnOHjlQAAAAMfITAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIB
# DDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEE
# AYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUTTE+yJPTlTrf
# BFiWEZbY+ol2NhYwDQYJKoZIhvcNAQEBBQAEggEAbzzR3aGZm0QSlqY1W2x/tac6
# FD16FxZfotV5z0odCIq3DPAFQmiSHyFC8SOf7SkTT6Kjv/oxkRpcPb4ScyxNBG9d
# vBtzE5bkl2tNaftIVpFiDWLVQD8sQeLVwM5f9NWohaln77PgxVQdJ6IBBCd3Igtd
# 3PXgO7Vv7eU6BznrDQYO2Lh4tum1qjWuxoBne/bqW4eH33iM5/wET+mzEM0ySW7X
# AIeqnGFbEavppcSmher/lFTD4dQeyetX2C9mkzGl6WE6/vZEmuImfuCH2l0wHvav
# BnVc8xi/Vp2MfSje19A9Oetzpl39aI1BEk8JrEK/JBGqlu+12RdjV4e7mmZ4OaGC
# Diwwgg4oBgorBgEEAYI3AwMBMYIOGDCCDhQGCSqGSIb3DQEHAqCCDgUwgg4BAgED
# MQ0wCwYJYIZIAWUDBAIBMIH/BgsqhkiG9w0BCRABBKCB7wSB7DCB6QIBAQYLYIZI
# AYb4RQEHFwMwITAJBgUrDgMCGgUABBRJUhln5kdGXmf2MBci8uKgbCe5aAIVALE/
# OUiUPt1TXxHukXQNhG7LSyvcGA8yMDIyMTIxNDEzMDUxMVowAwIBHqCBhqSBgzCB
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
# AQkQAQQwHAYJKoZIhvcNAQkFMQ8XDTIyMTIxNDEzMDUxMVowLwYJKoZIhvcNAQkE
# MSIEILMNpwc7i++j00u5Ps4LUxIlEutTwOEIchO0YA1CNBu1MDcGCyqGSIb3DQEJ
# EAIvMSgwJjAkMCIEIMR0znYAfQI5Tg2l5N58FMaA+eKCATz+9lPvXbcf32H4MAsG
# CSqGSIb3DQEBAQSCAQCqmaTbJXt0XZffGjEUgtIYbSUOzGE4hKVKt7JWqzKQwPg5
# J/YcJ2WVl4PI1Fn5zqu707sz/mlpCNCKkRg2Q7pweA5o2/1iTa231fv/f31tIneD
# d1ciRjD4MqpM0+pT8wrxurkTzAy+aOkYae8ElumEtQJm6AsO10D0DHWuHJes1fo8
# dbWJixE2qqUvuGNUN71MsuP0LKAh2rYULl4j8MzbRncNeRDxfAUcLw15F3R3fOWj
# P56VYcVB/9g3JiREOstaVhBKziPNIFbDSKQF/zoF+HCQV/jLmCStHi3CIfa03xUa
# faHcIX7D5HGQRdEuyAAs6F1uN1bymKWX1TQ8YEhi
# SIG # End signature block
