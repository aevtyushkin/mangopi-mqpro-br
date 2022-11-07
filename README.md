# Buildroot external tree for MangoPi MQ-Pro

The task is to make a working distribution(boilerplate) to quickly prototype devices using this board.

- Uses original buildroot 'master' branch
- Uses some modified scripts from ya-streams
- Tested on board revision v1.4 (pink) with TL8723DS wireless chip and 1Gb RAM

## Default configuration

* GCC 12.2
* Binutils 2.39
* Uboot, OpenSBI and Kernel 5.19 with patches from smaeul
* Busybox init
* Bluetooth
* Wireless LAN
* Sound enabled on headphone output (R, L, GND on board)
* SSH

Inspired with ya-streams buildroot_external example and seeed-linux-buildroot project

## Build instructions

### Prepare build environment

> Ubuntu 18.04, Ubuntu 22.04: 
```
sudo apt-get install -y build-essential unzip libssl-dev
```
> Debian 11.5
```
apt-get install -y build-essential unzip rsync bc libssl-dev
```

- Download this project and navigate to project directory
```
git clone --recursive https://github.com/aevtyushkin/mangopi-mqpro-br.git
cd mangopi-mqpro-br
```

- Init environment
```
source br-external/envsetup.sh
```

- Select target
```
set_target mqpro
```

- (optional) Customize image
```
m menuconfig
```

- Build
```
m all
```

*On successful build, image will be ready at **output/mqpro/images/sdcard.img***
- Flash image on SD card
```
dd if=output/mqpro/images/sdcard.img of=/dev/YYY bs=1M conv=fsync
```
*/dev/YYY is your SD card device, be careful here*

- On Windows-based hosts you can use Balena Etcher to flash image


## Boot sequence

Boot0 -> OpenSBI -> Uboot -> Kernel

Kernel uses FDT from uboot, so dts compilation with kernel is not required. Boot0 set memory size in device tree on boot.

## Additional configuration

All board-specific files are located at "br-external" directory, you can easily customize it. And its so easy to update buildroot tree at any time or check out specific branch

## After first boot

Edit file /etc/wpa_supplicant.conf to setup your wireless network and reboot.

## Testing

### Testing sound channels

```
speaker-test -twav -c2 -l2
```

### Testing Bluetooth

```
bluetoothctl scan on
```
This will show nearby devices


### Testing WLAN

```
ifconfig
```
There should be *wlan0* interface and IP address if you specified correct wlan settings at /etc/wpa_supplicant.conf

## Known issues

At this moment tty console on HDMI appears only if monitor cable is connected when board already started, ~20 seconds after power on.
