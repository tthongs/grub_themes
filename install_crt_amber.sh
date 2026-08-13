#!/bin/bash
set -e

THEME_SRC="/home/tthhongs/build_tthongs/grub_themes/CRT-Amber-GRUB-Theme"
TARGET_DIR="/boot/grub/themes/CRT-Amber-GRUB-Theme"
GRUB_DEFAULT="/etc/default/grub"

echo "==> Copying CRT Amber GRUB Theme to $TARGET_DIR..."
mkdir -p /boot/grub/themes
cp -r "$THEME_SRC" /boot/grub/themes/

if [ -d "/usr/share/grub/themes" ]; then
    cp -r "$THEME_SRC" /usr/share/grub/themes/
fi

echo "==> Backing up /etc/default/grub..."
if [ ! -f "${GRUB_DEFAULT}.bak" ]; then
    cp "$GRUB_DEFAULT" "${GRUB_DEFAULT}.bak"
fi

echo "==> Setting GRUB_THEME in $GRUB_DEFAULT..."
if grep -q "^GRUB_THEME=" "$GRUB_DEFAULT"; then
    sed -i 's|^GRUB_THEME=.*|GRUB_THEME="/boot/grub/themes/CRT-Amber-GRUB-Theme/theme.txt"|' "$GRUB_DEFAULT"
elif grep -q "^#GRUB_THEME=" "$GRUB_DEFAULT"; then
    sed -i 's|^#GRUB_THEME=.*|GRUB_THEME="/boot/grub/themes/CRT-Amber-GRUB-Theme/theme.txt"|' "$GRUB_DEFAULT"
else
    echo 'GRUB_THEME="/boot/grub/themes/CRT-Amber-GRUB-Theme/theme.txt"' >> "$GRUB_DEFAULT"
fi

echo "==> Regenerating GRUB config..."
grub-mkconfig -o /boot/grub/grub.cfg

echo "==> CRT Amber GRUB Theme successfully set!"
