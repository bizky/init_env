#!/bin/bash 

SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
#echo "脚本所在的目录: $SCRIPT_DIR"

#####################################################################
# Install SuperFile
#####################################################################
bash -c "$(curl -sLo- https://superfile.netlify.app/install.sh)"

mkdir ~/.config/superfile -p
cp $SCRIPT_DIR/superfile/* ~/.config/superfile/

#####################################################################
# Install ProxyChain
#####################################################################
mkdir -p ~/project/
wget -nv https://github.com/rofl0r/proxychains-ng/releases/download/v4.17/proxychains-ng-4.17.tar.xz -O ~/project/proxychains-ng.tar.xz
tar -xf ~/project/proxychains-ng.tar.xz -C ~/project/
mv ~/project/proxychains-ng*/ ~/project/proxychains-ng/
cd ~/project/proxychains-ng/
./configure
make

echo "alias pc='~/project/proxychains-ng/proxychains4 -f ~/project/proxychains-ng/proxychains.conf'" >> ~/.bashrc
cp $SCRIPT_DIR/proxychains-ng/proxychains.conf ~/project/proxychains-ng/proxychains.conf
