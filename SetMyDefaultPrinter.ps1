#
# from https://learn.microsoft.com/en-us/powershell/scripting/samples/working-with-printers?view=powershell-7.2
#

$printer = Get-CimInstance -Class Win32_Printer -Filter "Location='ERB-2327'"
Invoke-CimMethod -InputObject $printer -MethodName SetDefaultPrinter
