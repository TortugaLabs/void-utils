#!/bin/bash
set -euf -o pipefail

if [ $(id -u) -ne 0 ] ; then
  exec sudo "$0" "$@"
  exit 2
fi

srcdir=$(cd $(dirname "$0") && pwd)
[ -z "$srcdir" ] && exit 1 || :

icon_dir=/usr/share/icons/hicolor/128x128/apps
desktop_dir="/usr/share/applications"
url="https://app.simplenote.com/"

name="simplenote"
exec="/usr/bin/surf $url"
desc="note-taking application with markdown support"
categories="Network;TextEditor"

install -D -m 0644 -C "$srcdir"/"$name".png "$icon_dir"/"$name".png
tmp_desktop=$(mktemp)
trap "rm -f $tmp_desktop" EXIT

cat >$tmp_desktop <<-_EOF_
	#!/usr/bin/env xdg-open
	[Desktop Entry]
	Version=1.0
	Type=Application
	Terminal=false
	Exec=$exec
	Name=$name
	Comment=$desc
	Icon=$icon_dir/$name.png
	Categories=$categories
	_EOF_
install -D -m 0644 -C "$tmp_desktop" "$desktop_dir"/"$name".desktop
