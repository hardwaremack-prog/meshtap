#!/usr/bin/env bash
# One-time Pi setup: installs MeshTap, gives USB radio access, adds a desktop icon.
set -e
DIR="$(cd "$(dirname "$0")" && pwd)"
chmod +x "$DIR/start-pi.sh"

sudo apt-get update -qq
sudo apt-get install -y python3-venv python3-pip bluez >/dev/null

# USB serial radios need the dialout group
if ! groups "$USER" | grep -q dialout; then
  sudo usermod -aG dialout "$USER"
  NEED_RELOG=1
fi

cd "$DIR"
python3 -m venv .venv
.venv/bin/python -m pip install --upgrade pip
.venv/bin/python -m pip install -r requirements.txt && echo ok > .venv/installed.txt

ENTRY="[Desktop Entry]
Type=Application
Name=MeshTap
Comment=See all Meshtastic traffic through your radio
Exec=lxterminal -t MeshTap -e \"$DIR/start-pi.sh\"
Icon=$DIR/meshtap-icon.png
Terminal=false
Categories=Network;HamRadio;"
mkdir -p "$HOME/.local/share/applications" "$HOME/Desktop"
echo "$ENTRY" > "$HOME/.local/share/applications/meshtap.desktop"
echo "$ENTRY" > "$HOME/Desktop/meshtap.desktop"
chmod +x "$HOME/Desktop/meshtap.desktop" "$HOME/.local/share/applications/meshtap.desktop"
command -v gio >/dev/null && gio set "$HOME/Desktop/meshtap.desktop" metadata::trusted true 2>/dev/null || true

echo
echo "MeshTap is installed. Double-click the MeshTap icon on your desktop."
[ -n "$NEED_RELOG" ] && echo "NOTE: log out and back in (or reboot) once so USB radio access takes effect."
