#!/usr/bin/env bash
# ------------------------------------------------------------
# install-xdg-open-wsl-shim.sh
# Safe replacement for broken xdg-open in WSL
# ------------------------------------------------------------
set -e

if [[ "$(readlink -f /usr/local/bin/xdg-open)" == "/usr/local/bin/xdg-open-wsl.sh" ]]; then
  echo "✅ xdg-open shim already installed. Nothing to do."
  exit 0
fi


echo "🔧 Installing universal WSL-aware xdg-open shim..."

# ------------------------------------------------------------
# Create xdg-open shim (non-blocking, works standalone)
# ------------------------------------------------------------
sudo tee /usr/local/bin/xdg-open-wsl.sh >/dev/null <<'EOF'
#!/usr/bin/env bash
# ------------------------------------------------------------
# xdg-open-wsl.sh — universal WSL-safe xdg-open wrapper
# Works even if appendWindowsPath=false
# ------------------------------------------------------------
set -e

target="$1"
if [[ -z "$target" ]]; then
  echo "Usage: xdg-open <file-or-url>"
  exit 1
fi

if grep -qi microsoft /proc/version; then
  # Determine correct explorer.exe path
  if command -v explorer.exe >/dev/null 2>&1; then
    WINEXE="explorer.exe"
  else
    WINEXE="/mnt/c/Windows/explorer.exe"
  fi

  case "$target" in
    http*|www.*)
      "$WINEXE" "$target" >/dev/null 2>&1 &
      ;;
    *)
      "$WINEXE" "$(wslpath -w "$target")" >/dev/null 2>&1 &
      ;;
  esac
else
  /usr/bin/xdg-open "$target" >/dev/null 2>&1 &
fi
EOF

sudo chmod +x /usr/local/bin/xdg-open-wsl.sh
sudo ln -sf /usr/local/bin/xdg-open-wsl.sh /usr/local/bin/xdg-open

# ------------------------------------------------------------
# Create "open" shim — call xdg-open directly (no extra &)
# ------------------------------------------------------------
sudo tee /usr/local/bin/open >/dev/null <<'EOF'
#!/usr/bin/env bash
# "open" wrapper — delegates directly to xdg-open
/usr/local/bin/xdg-open "$@"
EOF
sudo chmod +x /usr/local/bin/open

# ------------------------------------------------------------
# Verify installation
# ------------------------------------------------------------
echo
echo "✅ Shim installed successfully!"
which xdg-open
readlink -f "$(which xdg-open)"
echo
echo "Try:"
echo "  xdg-open index.html"
echo "  open index.html"
echo
echo "Both should open in your Windows browser and return immediately."
