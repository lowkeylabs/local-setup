

## Phase 2 stuff. The shell needs to be stopped and restarted to capture other non-Path fixes.


# Install R and RStudio. May need to be expanded to install particular libraryies
##choco install -y r.project
##choco install -y r.studio
##choco install -y rtools
##choco install -y miktex


##choco install -y wsl2 --params "Version:2 /Retry:true"
##choco install -y wsl-ubuntu-2204
## chocl install docker-desktop

# Other setup tasks
# 1. Create SSH key in $Env:UserProfile\.ssh
# 1. Install SSH public key on https://scm.vcu.edu/plugins/servlet/ssh/account/keys
#       Label the key <jdleonard>@<machine name>,  e.g., jdleonard@EGR-JL-RAK1-VM3
# 1. Open Visual Studio 2019, add SSIS data tools from "Extensions | MarketPlace"
# 1. Ensure Powershell 7 path scripts all work.
# 1. Add ODBC system connector for EGRPROD
