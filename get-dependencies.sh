#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm webkit2gtk-4.1

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
# make-aur-package iloader-bin

echo "Getting binary..."
echo "---------------------------------------------------------------"
case "$ARCH" in
	x86_64)  farch=amd64;;
	aarch64) farch=arm64;;
esac
link=https://github.com/nab138/iloader/releases/latest/download/iloader-linux-$farch.deb
if ! wget --retry-connrefused --tries=30 "$link" -O /tmp/temp.deb 2>/tmp/download.log; then
	cat /tmp/download.log
	exit 1
fi
ar x /tmp/temp.deb
tar -xvf ./data.tar.gz
rm -f ./*.tar.gz /tmp/temp.deb

mkdir -p ./AppDir/bin
cp -v ./usr/bin/* ./AppDir/bin
cp -v ./usr/share/applications/*.desktop ./AppDir
cp -v ./usr/share/icons/hicolor/128x128/apps/iloader.png ./AppDir
cp -v ./usr/share/icons/hicolor/128x128/apps/iloader.png ./AppDir/.DirIcon

awk -F'/' '/Location:/{print $(NF-1); exit}' /tmp/download.log > ~/version

