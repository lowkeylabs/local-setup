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

    Added new QUARTO section
    Date: 11/3/2023
    Version: 1.1

.LINK
    None

#>

write-output "Running profile: $PROFILE"

$ENV:PATH="$ENV:PATH;$ENV:APPDATA\Python\Scripts"
$ENV:PATH="$ENV:PATH;C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\Roslyn"

## Aliases added on 10/29/2023 by JL
## The powershell SET-ALIAS function doesn't accept arguments, so we'll use function instead
function ListPath {$env:PATH -split ";"}
function ListEnv {Get-ChildItem Env: | Sort-Object Name | Format-Table Name, Value -AutoSize}


# These settings disable annoying quarto messages
$env:DENO_NO_UPDATE_CHECK=1               # to warning about deno upgrades
$env:DENO_TLS_CA_STORE="system"           # to stop the BAD CERTIFICATE deno warning
$env:PYDEVD_DISABLE_FILE_VALIDATION=1     # for Python 3.11 above, to disable warning message RE: debugging
$env:VIRTUAL_ENV_DISABLE_PROMPT=1         # set to 1 to disable venv prompt change

# This code ensures Quarto finds the correct python from pyenv or poetry if a venv exists.
$env:QUARTO_PYTHON=$(pyenv which python)  # to work with pyenv global or local python
$pythonPoetryPath = $(poetry env info -e 2> $null)
if ($pythonPoetryPath -ne $null) {
  # extract the venv name from the python poetry path
  $venvName = Split-Path -Path $pythonPoetryPath -Parent | Split-Path -Parent | Split-Path -Leaf
  Write-Output "QUARTO_PYTHON set to Poetry venv: $venvName"
  $env:QUARTO_PYTHON=$pythonPoetryPath    # override with poetry venv python as needed
} else {
  Write-Output "QUARTO_PYTHON set to $(pyenv version)"
}

# posh prompt shows current venv, so disable the prompt change above!
oh-my-posh init pwsh --config=$env:USERPROFILE\.mysetup\jleonard99.omp.json| invoke-expression

