#!/bin/bash

# Enable UART, SPI, I2C
echo "overlays=cpu-clock-1.368GHz-1.3v i2c0 i2c1 i2c2 spi-spidev uart1 uart2 uart3" | tee -a /boot/armbianEnv.txt
echo "param_spidev_spi_bus=0" | tee -a /boot/armbianEnv.txt

# Setup Docker volume
if [ -e /tmp/overlay/docker_volume.tar.gz ]; then
    tar xvf /tmp/overlay/docker_volume.tar.gz -C /
    rm -rf /tmp/overlay/docker_volume.tar.gz
fi

# Install Docker
curl -o /tmp/docker.sh -fsSL get.docker.com
chmod +x /tmp/docker.sh
/tmp/docker.sh --mirror Aliyun
rm -rf /tmp/docker.sh /tmp/docker_volume.tar.gz
