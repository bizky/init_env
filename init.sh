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


#####################################################################
# Install Custom docker-pull
#####################################################################

function docker-pull() {

  DOCKER_HUB_DOMAIN="hub.hotmonitor.top"
  local image_name="$1"
  set -x
  docker pull -q $DOCKER_HUB_DOMAIN/library/"$image_name";
  docker tag $DOCKER_HUB_DOMAIN/library/"$image_name" "$image_name";
  docker rmi $DOCKER_HUB_DOMAIN/library/"$image_name";
  set +x
}

echo "
# docker-pull 函数
$(declare -f docker-pull)
" >> ~/.bashrc

#####################################################################
# Install Custom git-clone
#####################################################################

function git-clone() {

  # 检查参数数量
  if [ $# -ne 1 ]; then
    echo "用法: git_clone_with_mirror <仓库地址>"
    return 1
  fi

  # 提取用户名和仓库名
  repo_url="$1"
  username=$(echo "$repo_url" | sed -E 's#https://github.com/([^/]+)/([^/]+).git#\1#')
  repo_name=$(echo "$repo_url" | sed -E 's#https://github.com/([^/]+)/([^/]+).git#\2#')

  # 使用镜像地址克隆仓库
  git clone "https://gh.hotmonitor.top/${username}/${repo_name}.git"

  # 检查克隆是否成功
  if [ $? -ne 0 ]; then
    echo "克隆仓库失败"
    return 1
  fi

  # 进入仓库目录
  cd "$repo_name"

  # 修改远程仓库地址为原始地址
  git remote set-url origin "$repo_url"

  # 检查修改是否成功
  if [ $? -ne 0 ]; then
    echo "修改远程仓库地址失败"
    return 1
  fi

  echo "仓库克隆成功，并已将远程仓库地址修改为原始地址"
  cd -

}

echo "
# git-clone 函数
$(declare -f git-clone)
" >> ~/.bashrc




source ~/.bashrc

