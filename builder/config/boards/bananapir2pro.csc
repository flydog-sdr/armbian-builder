# Rockchip RK3568 quad core 2GB-4GB 5GBE eMMC SATA USB3 Mini PCIE M.2 key-e
BOARD_NAME="Banana Pi R2 Pro"
BOARDFAMILY="media"
BOARD_MAINTAINER=""
BOOTCONFIG="bpi-r2pro-rk3568_defconfig"
KERNEL_TARGET="current,edge"
FULL_DESKTOP="yes"
BOOT_LOGO="desktop"
BOOT_FDT_FILE="rockchip/rk3568-bpi-r2-pro.dtb"
SRC_EXTLINUX="yes"
SRC_CMDLINE="console=ttyS02,1500000 console=tty0"
ASOUND_STATE="asound.state.station-p2"
IMAGE_PARTITION_TABLE="gpt"
