#!/bin/bash

# Enable UART, SPI, I2C
echo "overlays=spi-spidev uart1 uart2 uart3" | tee -a /boot/armbianEnv.txt
echo "param_spidev_spi_bus=0" | tee -a /boot/armbianEnv.txt

# Install Docker
curl -o /tmp/docker.sh -fsSL get.docker.com
chmod +x /tmp/docker.sh
/tmp/docker.sh --mirror Aliyun
rm -rf /tmp/docker.sh /var/lib/apt/lists/*
apt-get clean

# Setup Docker volume
if [ -e /tmp/overlay/docker_volume.tar.gz ]; then
    rm -rf /var/lib/docker
    tar xvf /tmp/overlay/docker_volume.tar.gz -C /
    rm -rf /tmp/overlay/docker_volume.tar.gz
fi

# Create a new user and set password
rm /root/.not_logged_in_yet
echo "root:flycat-sdr" | chpasswd
useradd -m -s /bin/bash -G sudo flycat
echo "flycat:flycat-sdr" | chpasswd
usermod -aG docker flycat
