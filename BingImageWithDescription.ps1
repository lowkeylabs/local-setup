
#Location to store original image 
    $saveLocation = ‘\\SERVER\SHARE\Bing Background\WithoutText\backgroundDefault.jpg’
#Location to store image with title added to it. Group Policy should point to this image.
    $saveLocationWithDescriptionAdded = '\\SERVER\SHARE\Bing Background\backgroundDefault.JPG'
 
#Height From Bottom in Pixels. This controls how far up from the bottom that the next is written. Should not be lower than 21. Set to 75 for the text to appear above taskbar if used as desktop background.
    $HeightfromBottom = 45
 
#Download Bing Image to SaveLocation
$uri = “https://www.bing.com/HPImageArchive.aspx?format=rss&idx=0&n=1&mkt=en-US”
[xml]$BingImage = Invoke-WebRequest -Uri $uri -SessionVariable Bing -ContentType "text/xml; charset=utf-8" -Method Get
$CurrentImage = $BingImage.rss.channel.item
 
#Microsoft provides several different resolutions. This script grabs the 1920x1080. Remove the .Replace* to keep the 1366x768 version.
$ImageURL = "https://www.bing.com" + ($CurrentImage.link).Replace("1366x768.jpg","1920x1080.jpg")
Invoke-WebRequest $ImageURL -OutFile $savelocation 
 
 
#Get Bing Image Title
$Title = Invoke-WebRequest -Uri $uri -SessionVariable Bing -ContentType "text/xml; charset=utf-8" -Method Get -OutFile C:\Users\Public\title.txt
$Title = (Get-Content C:\Users\Public\title.txt -Encoding UTF8)
$Title = $Title -split '>' 
$Title = $Title.Item(12)
$Description = $Title.Replace('</title',"")
Remove-Item C:\Users\Public\title.txt -Force
 
 
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

