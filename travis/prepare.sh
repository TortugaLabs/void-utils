#!/bin/sh
#
# install_tools.sh

echo XBPS_CHROOT_CMD=uchroot >> etc/conf
echo XBPS_MAKEJOBS=4 >> etc/conf
echo XBPS_ALLOW_RESTRICTED=yes >> etc/conf
echo XBPS_CHROOT_CMD=ethereal >> etc/conf
echo XBPS_ALLOW_CHROOT_BREAKOUT=yes >> etc/conf
ln -s / masterdir
