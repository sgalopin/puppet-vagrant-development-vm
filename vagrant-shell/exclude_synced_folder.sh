#!/bin/bash
set -e
set -o pipefail

# $1 => localpath
# $2 => sharedpath

umask 000
mkdir -m 0777 -p $1
chown www-data:www-data $1
#fix local access
apt-get install -y acl
setfacl -R -m u:www-data:rwX -m u:vagrant:rwX -m u:root:rwX $1
setfacl -dR -m u:www-data:rwX -m u:vagrant:rwX -m u:root:rwX $1
mkdir -p $2
mount -o bind $1 $2