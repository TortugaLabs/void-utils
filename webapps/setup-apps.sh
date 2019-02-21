#!/bin/bash
set -euf -o pipefail

if [ $(id -u) -ne 0 ] ; then
  exec sudo "$0" "$@"
  exit 2
fi

srcdir=$(cd $(dirname "$0") && pwd)
[ -z "$srcdir" ] && exit 1 || :

$srcdir/webapp-setup.sh \
  --name="simplenote" \
  --desc="note-taking application with markdown support" \
  --categories="Network;TextEditor" \
  "https://app.simplenote.com/"
