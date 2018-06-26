#!/bin/sh

# Clone or pull repo
if [ -d picicon-repo ]; then
    (cd picicon-repo; git pull)
else
    git clone --depth 1  https://gitlab.com/picons/picons.git picicon-repo
fi;

# create logos
cp icon-settings/*.conf picicon-repo/build-input
cd picicon-repo

echo "Start building the channel logos... This can take some time."
./2-build-picons.sh snp-full

echo "Building finished..."

# repack the result
mkdir -p logo
tar -xf build-output/binaries-snp-full/snp-full.*hardlink.tar.xz -C logo --strip 1

# copy to theme directory
mkdir -p ../../src/main/webapp/VAADIN/themes/jonglisto/channellogo/
cp  logo/*.png ../../src/main/webapp/VAADIN/themes/jonglisto/channellogo/

# create jar
# jar -cf logo.jar logo/*
# mkdir -p ../../external-jar
# mv logo.jar ../../external-jar

