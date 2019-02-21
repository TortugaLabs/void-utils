#!/bin/bash
set -euf -o pipefail

if [ $(id -u) -ne 0 ] ; then
  exec sudo "$0" "$@"
  exit 2
fi

srcdir=$(cd $(dirname "$0") && pwd)
[ -z "$srcdir" ] && exit 1 || :
bindir="/usr/bin"
icondir=/usr/share/icons/hicolor
iconsz=128
icon_path="$icondir"/${iconsz}x${iconsz}/apps/patoggle.png
desktopdir="/usr/share/applications"

install -D -m 0755 -C "$srcdir"/patoggle "$bindir"/patoggle
install -D -m 0644 -C "$srcdir"/soundsw-${iconsz}x${iconsz}.png "$icon_path"

tmp_desktop=$(mktemp)
trap "rm -f $tmp_desktop" EXIT

cat >$tmp_desktop <<-_EOF_
	#!/usr/bin/env xdg-open
	[Desktop Entry]
	Version=1.0
	Type=Application
	Terminal=false
	Exec=$bindir/patoggle
	Name=Toggle Audio
	Comment=Toggle Pulse Audio Output
	Icon=$icon_path
	Categories=AudioVideo;Audio
	_EOF_
install -D -m 0644 -C "$tmp_desktop" "$desktopdir"/patoggle.desktop
