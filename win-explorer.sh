#!/bin/bash
# win-explore.sh
# Open a WSL path in Windows Explorer

# Default to current directory if no arguments given
if [ $# -eq 0 ]; then
  set -- .
fi

for arg in "$@"; do
  if [ -e "$arg" ]; then
    winpath=$(wslpath -w "$arg")
    explorer.exe "$winpath"
  else
    echo "Path not found: $arg" >&2
  fi
done
