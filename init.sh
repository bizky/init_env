#!/bin/bash 

SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
PROJECT_DIR="$HOME/project"

#####################################################################
# Install Python3 Alias
#####################################################################
echo "alias py='python3'" >> $HOME/.bashrc


#####################################################################
# Install SuperFile
#####################################################################
bash -c "$(curl -sLo- https://superfile.netlify.app/install.sh)"

mkdir ~/.config/superfile -p
cp $SCRIPT_DIR/superfile/* ~/.config/superfile/

#####################################################################
# Install ProxyChain
#####################################################################
mkdir -p $PROJECT_DIR
wget -nv https://github.com/rofl0r/proxychains-ng/releases/download/v4.17/proxychains-ng-4.17.tar.xz -O $PROJECT_DIR/proxychains-ng.tar.xz
tar -xf $PROJECT_DIR/proxychains-ng.tar.xz -C $PROJECT_DIR/
mv $PROJECT_DIR/proxychains-ng*/ $PROJECT_DIR/proxychains-ng/
cd $PROJECT_DIR/proxychains-ng/
./configure
make

echo "alias pc='$PROJECT_DIR/proxychains-ng/proxychains4 -f $PROJECT_DIR/proxychains-ng/proxychains.conf'" >> ~/.bashrc
cp $SCRIPT_DIR/proxychains-ng/proxychains.conf $PROJECT_DIR/proxychains-ng/proxychains.conf
rm $PROJECT_DIR/proxychains-ng.tar.xz
