<#
.SYNOPSIS
Set current enviroment for R tools

.DESCRIPTION
Set current enviroment for Rtools


.NOTES
Author: John Leonard
Version: 1.0
Last Updated 2023-06-28

.EXAMPLE
>> .\r-tools.ps1

#>

# these values are VERY version dependent!

##$ENV:R_TOOLS="Not installed"
$ENV:R_TOOLS="4.3"
$ENV:PATH="$ENV:PATH;C:\rtools43\x86_64-w64-mingw32.static.posix\bin;C:\Program Files\Git\usr\bin"

write-host "RTOOLS environment set. R: $ENV:R_VERSION  Rtools: $ENV:R_TOOLS"
