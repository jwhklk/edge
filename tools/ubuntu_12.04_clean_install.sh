#!/bin/bash

THE_USER=${SUDO_USER:-${USERNAME:-guest}}

set -e
sudo -u ${THE_USER} mkdir ~/tmp

# install prerequisities

apt-get install curl g++ pkg-config

# download and build Node.js

sudo -u ${THE_USER} curl https://codeload.github.com/joyent/node/tar.gz/v0.10.26 > node.v0.10.26.tar.gz
sudo -u ${THE_USER} tar -xvf node.v0.10.26.tar.gz
cd node-0.10.26/
sudo -u ${THE_USER} bash -c './configure'
sudo -u ${THE_USER} make
make install
cd ..

# install node-gyp and mocha

npm install node-gyp -g
npm install mocha -g

# download and build Mono x64

sudo -u ${THE_USER} curl http://download.mono-project.com/sources/mono/mono-3.4.0.tar.bz2 > mono-3.4.0.tar.bz2
sudo -u ${THE_USER} tar -xvf mono-3.4.0.tar.bz2
sudo -u ${THE_USER} curl https://raw.githubusercontent.com/tjanczuk/edge/mono/tools/Microsoft.Portable.Common.targets > ./mono-3.4.0/mcs/tools/xbuild/targets/Microsoft.Portable.Common.targets
cd mono-3.4.0
sudo -u ${THE_USER} bash -c './configure --prefix=/usr/local --with-glib=embedded --enable-nls=no'
sudo -u ${THE_USER} make
make install
ln -s -f /lib/x86_64-linux-gnu/libc.so.6 /lib/x86_64-linux-gnu/libc.so
ldconfig
cd ..

# download and build Edge.js

sudo -u ${THE_USER} curl https://codeload.github.com/tjanczuk/edge/zip/mono > edge.js.zip
sudo -u ${THE_USER} unzip edge.js.zip 
cd edge-mono/
sudo -u ${THE_USER} npm install
sudo -u ${THE_USER} npm test
