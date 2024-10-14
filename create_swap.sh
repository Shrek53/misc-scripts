#!/usr/bin/env bash
echo "This script creates a swap file for your machine."
echo "swap_size = block_size X number_of_blocks"
read -p "Enter Block size : (i.e. 256M,512M,1G,2G )" bs
read -p "Enter Number of blocks : " cnt
sudo swapoff -a
sudo dd if=/dev/zero of=/swapfile bs=$bs count=$cnt
sudo mkswap /swapfile
sudo chmod 600 /swapfile
sudo swapoff -a
sudo swapon /swapfile
echo "Your swap size : "
grep SwapTotal /proc/meminfo
echo "Making swapfile permanent : "
sudo cp /etc/fstab /etc/fstab.back
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
