#!/bin/bash
sudo mkdir ~/temp

sudo apt update 1>> ~/temp/install_out 2>> ~/temp/install_err
sudo apt upgrade -y 1>> ~/temp/install_out 2>> ~/temp/install_err
sudo apt install -y ansible 1>> ~/temp/install_out 2>> ~/temp/install_err
sudo apt install -y git 1>> ~/temp/install_out 2>> ~/temp/install_err

sudo mkdir /etc/ansible 1>> ~/temp/install_out 2>> ~/temp/install_err
sudo git clone -b ansible https://github.com/DAChirkov/DevOps_Project.git /etc/ansible/ 1>> ~/temp/install_out 2>> ~/temp/install_err