#!/bin/bash
set -euf -o pipefail

if [ $(id -u) -ne 0 ] ; then
  exec sudo "$0" "$@"
  exit 2
fi

srcdir=$(cd $(dirname "$0") && pwd)
[ -z "$srcdir" ] && exit 1 || :

type unzip || exit 1

if [ ! -d /usr/lib/TkXext.vfs ] ; then
  ( cd /usr/lib && unzip "$srcdir"/TkXext.zip )
fi
install -D -m 0755 -C "$srcdir"/webapp.tk /usr/bin/webapp.tk

