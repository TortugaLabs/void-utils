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
url="https://www.yahoo.com"
name="webapp.tk"
title=""
categories="Network"
cmd=/usr/bin/webapp.tk
icon=""
desc="Generic Web App"

while [ $# -gt 0 ]
do
  case "$1" in
  --icon_dir=*)
    icon_dir=${1#--icon_dir=}
    ;;
  --icon=*)
    icon=${1#--icon=}
    ;;
  --desc=*)
    desc=${1#--desc=}
    ;;
  --desktop_dir=*)
    desktop_dir=${1#--desktop_dir=}
    ;;
  --name=*)
    name=${1#--name=}
    ;;
  --title=*)
    title=${1#--title=}
    ;;
  --categories=*)
    categories=${1#--categories=}
    ;;
  --cmd=*)
    cmd=${1#--cmd=}
    ;;
  *)
    url="$1"
    ;;
  esac
  shift
done

[ -z "$title" ] && title="$name" || :
[ -z "$icon" ] && icon="$srcdir/$name" || :
if [ ! -f "$icon".png ] ; then
  echo "Icon file not found: $icon.png"
  exit 2
fi

exec="$cmd --icon='$icon_dir/$name.png' --name='$name' --title='$title' '$url'"

install -D -m 0644 -C "$icon".png "$icon_dir"/"$name".png
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
