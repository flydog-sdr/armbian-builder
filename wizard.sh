#!/usr/bin/env bash

# This Bash script to build the latest Raspbian release of FlyCat SDR:
# https://github.com/flydog-sdr/FlyCat_SDR_GPS

# The URL of the script project is:
# https://github.com/flydog-sdr/armbian-builder

# The URL of the script is:
# https://raw.githubusercontent.com/flydog-sdr/armbian-builder/master/wizard.sh

# Define basic variables
BASE_PATH=$(cd `dirname $0`; pwd)
DOCKER_ARCHIVE="${BASE_PATH}/builder/userpatches/overlay/docker_volume.tar.gz"
BUILD_DEPENDS="binfmt-support git curl"

initialise_environment() {
  sudo modprobe binfmt_misc
  sudo apt-get update
  sudo apt-get install -y ${BUILD_DEPENDS}
  sudo curl https://get.docker.com | sed "s/20/1/g" > /tmp/docker.sh
  sudo chmod +x /tmp/docker.sh
  sudo sh /tmp/docker.sh --mirror Aliyun
  sudo /etc/init.d/docker restart
  sudo rm -rf /tmp/docker.sh \
         /var/lib/docker/* \
         ${DOCKER_ARCHIVE}
  echo y | sudo docker system prune
  sudo /etc/init.d/docker restart
  sleep 3s
}

deploy_apps() {
  sudo docker run -d \
             --name flycat-sdr \
             --network host \
             --privileged \
             --restart always \
             --volume kiwi.config:/root/kiwi.config \
             flydog-sdr/flycat-sdr:latest
  sudo /etc/init.d/docker stop
}

archive_docker_volume() {
  sudo tar -czf ${DOCKER_ARCHIVE} /var/lib/docker
  username=$(whoami)
  sudo chown ${username}:${username} ${DOCKER_ARCHIVE}
  sudo rm -rf /var/lib/docker/*
  echo y | sudo docker system prune
  sudo /etc/init.d/docker restart
}

execute_build() {
  cd ${BASE_PATH}/builder
  chmod +x compile.sh
  bash -c "./compile.sh BUILD_MINIMAL=yes BOARD=orangepione USE_CCACHE=yes BUILD_DESKTOP=no RELEASE=bullseye BRANCH=current KERNEL_CONFIGURE=no"
}

main() {
  initialise_environment
  deploy_apps
  archive_docker_volume
  execute_build
}
main "$@"; exit
