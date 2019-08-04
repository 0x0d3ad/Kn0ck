#!/bin/bash

OKBLUE='\033[94m'
OKRED='\033[91m'
OKGREEN='\033[92m'
OKORANGE='\033[93m'
RESET='\e[0m'

echo ""
echo -e "$OKGREEN         ___      ___        $RESET"
echo -e "$OKGREEN            \    /           $RESET"
echo -e "$OKGREEN         ....\||/....        $RESET"
echo -e "$OKGREEN        .    .  .    .       $RESET"
echo -e "$OKGREEN       .      ..      .      $RESET"
echo -e "$OKGREEN       .    0 .. 0    .      $RESET"
echo -e "$OKGREEN    /\/\.    .  .    ./\/\   $RESET"
echo -e "$OKGREEN   / / / .../|  |\... \ \ \  $RESET"
echo -e "$OKGREEN  / / /       \/       \ \ \ $RESET"
echo -e "$RESET"
echo -e "$OKORANGE +----=[Kn0ck By @Mils]=----+ $RESET"
echo ""
echo ""
echo -e "$OKGREEN + -- --=[This script will install Kn0ck for Debian or Ubuntu under $INSTALL_DIR. Are you sure you want to continue? (Hit Ctrl+C to exit)]=-- --+ $RESET"
read answer

if [ ! -f "/etc/apt/sources.list.bak" ]; then
	cp /etc/apt/sources.list /etc/apt/sources.list.bak
	echo "deb http://http.kali.org/kali kali-rolling main non-free contrib" >> /etc/apt/sources.list
	echo "deb-src http://http.kali.org/kali kali-rolling main non-free contrib" >> /etc/apt/sources.list
fi
wget https://http.kali.org/kali/pool/main/k/kali-archive-keyring/kali-archive-keyring_2018.1_all.deb
apt install ./kali-archive-keyring_2018.1_all.deb
apt update
cp /root/.Xauthority /root/.Xauthority.bak 2> /dev/null
cp -a /run/user/1000/gdm/Xauthority /root/.Xauthority 2> /dev/null
cp -a /home/user/.Xauthority /root/.Xauthority 2> /dev/null 
chown root /root/.Xauthority
XAUTHORITY=/root/.Xauthority
git clone https://github.com/telnet22/Kn0ck /tmp/Kn0ck
cd /tmp/Kn0ck
chmod +x install.sh
bash install.sh