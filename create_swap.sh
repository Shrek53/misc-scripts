#!/usr/bin/env bash
echo "swap_size = block_size X number_of_blocks"
read -p "Block size : (i.e. 256M,512M,1G,2G )" bs
read -p "Number of blocks : " cnt
sudo swapoff -a
sudo dd if=/dev/zero of=/swapfile bs=$bs count=$cnt
sudo mkswap /swapfile
sudo chmod 600 /swapfile
sudo swapoff -a
sudo swapon /swapfile
echo "Your swap_size = "
grep SwapTotal /proc/meminfo
