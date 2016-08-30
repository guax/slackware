#!/bin/sh

set -e

repo="https://nodejs.org/dist/latest/"
latest=$(curl -s $repo | grep -Po 'href="\Knode-v[0-9]+\.[0-9]+\.[0-9]+\.tar\.xz')
download_url=$repo$latest

if [ ! -f $latest ]; then
	wget $download_url -O $latest --progress=bar
fi

md5=$(md5sum $latest | awk '{print $1}')

echo "Latest release is $latest with md5 $md5"

latest_version=$(echo $latest | grep -oP 'v\K[0-9]+\.[0-9]+\.[0-9]+')
sed "s/VERSION:\-[^}]*/VERSION:-$latest_version/g" -i nodejs.SlackBuild

update_info() {
	sed "s/$1=\"[^\"]*\"/$1=\"$2\"/g" -i nodejs.info
}

update_info VERSION $latest_version
update_info DOWNLOAD $(echo -n $download_url | sed 's/\//\\\//g')
update_info MD5SUM $md5
