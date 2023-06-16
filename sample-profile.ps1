echo "Running profile: $PROFILE"
$env:QUARTO_PYTHON=$(pyenv which python)
oh-my-posh init pwsh --config=$env:USERPROFILE\.mysetup\jleonard99.omp.json| invoke-expression
