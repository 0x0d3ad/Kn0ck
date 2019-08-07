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

INSTALL_DIR=/usr/share/knock
LOOT_DIR=/usr/share/knock/loot
PLUGINS_DIR=/usr/share/knock/plugins
GO_DIR=~/go/bin

echo ""
echo -e "$OKGREEN + -- --=[This script will install Kn0ck under $INSTALL_DIR. Are you sure you want to continue? (Hit Ctrl+C to exit)]=-- --+ $RESET"
read answer

mkdir -p $INSTALL_DIR 2> /dev/null
mkdir -p $LOOT_DIR 2> /dev/null
mkdir $LOOT_DIR/domains 2> /dev/null
mkdir $LOOT_DIR/screenshots 2> /dev/null
mkdir $LOOT_DIR/nmap 2> /dev/null
mkdir $LOOT_DIR/reports 2> /dev/null
mkdir $LOOT_DIR/output 2> /dev/null
mkdir $LOOT_DIR/osint 2> /dev/null
cp -Rf * $INSTALL_DIR 2> /dev/null
cd $INSTALL_DIR

echo ""
echo -e "$OKORANGE + -- --=[Installing package dependencies...]=-- --+ $RESET"
apt-get update
apt-get install -y python3-uritools python3-paramiko nfs-common eyewitness nodejs wafw00f xdg-utils metagoofil clusterd ruby rubygems python dos2unix sslyze arachni aha libxml2-utils rpcbind cutycapt host whois dnsrecon curl nmap php php-curl hydra wpscan sqlmap nbtscan enum4linux cisco-torch metasploit-framework theharvester dnsenum nikto smtp-user-enum whatweb sslscan amap jq golang adb xsltproc
apt-get install -y waffit 2> /dev/null
apt-get install -y libssl-dev 2> /dev/null
apt-get install -y snapd
apt-get install -y python3-pip
pip install dnspython colorama tldextract urllib3 ipaddress requests
apt-get autoremove -y
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash

echo ""
echo -e "$OKORANGE + -- --=[Installing gem dependencies...]=-- --+ $RESET"
gem install rake
gem install ruby-nmap net-http-persistent mechanize text-table
gem install public_suffix

echo ""
echo -e "$OKORANGE + -- --=[Setting up Ruby...]=-- --+ $RESET"
dpkg-reconfigure ruby

echo ""
echo -e "$OKORANGE + -- --=[Cleaning up old extensions...]=-- --+ $RESET"
rm -Rf $PLUGINS_DIR 2> /dev/null
mkdir $PLUGINS_DIR 2> /dev/null
cd $PLUGINS_DIR
mkdir -p $PLUGINS_DIR/nmap_scripts/ 2> /dev/null
mkdir -p $GO_DIR 2> /dev/null

echo ""
echo -e "$OKORANGE + -- --=[Downloading extensions...]=-- --+ $RESET"
git clone https://github.com/1N3/BruteX.git 
git clone https://github.com/1N3/Goohak.git  
cp /usr/share/knock/plugins/BlackWidow/injectx.py /usr/bin/injectx.py
pip install -r /usr/share/knock/plugins/BlackWidow/requirements.txt
git clone https://github.com/Dionach/CMSmap.git 
git clone https://github.com/0xsauby/yasuo.git 
git clone https://github.com/aboul3la/Sublist3r.git 
git clone https://github.com/nccgroup/shocker.git 
git clone https://github.com/BishopFox/spoofcheck.git
git clone https://github.com/arthepsy/ssh-audit 
git clone https://github.com/1N3/jexboss.git
git clone https://github.com/telnet22/dirsearch
git clone https://github.com/jekyc/wig.git
git clone https://github.com/rbsec/dnscan.git
git clone https://github.com/christophetd/censys-subdomain-finder.git
pip install -r $PLUGINS_DIR/censys-subdomain-finder/requirements.txt
pip3 install -r $PLUGINS_DIR/dnscan/requirements.txt 
pip3 install webtech
pip install webtech
mv $INSTALL_DIR/bin/slurp.zip $PLUGINS_DIR
unzip slurp.zip

cd ~/go/bin/; go get github.com/haccer/subjack; cp subjack /usr/local/bin/
cd ~/go/bin/; go get -u github.com/tomnomnom/meg; cp meg /usr/bin/
cd ~/go/bin/; go get -u github.com/tomnomnom/httprobe; cp httprobe /usr/local/bin/
cd ~/go/bin/; go get -u github.com/Ice3man543/SubOver; cp SubOver /usr/local/bin/subover
cd ~/go/bin; go get -u github.com/OWASP/Amass/cmd/amass; cp amass /usr/local/bin/
cd ~/go/bin; go get -u github.com/subfinder/subfinder; cp subfinder /usr/local/bin/subfinder
cd $PLUGINS_DIR

echo ""
echo -e "$OKORANGE + -- --=[Setting up environment...]=-- -- + $RESET"
mv ~/.knock.conf ~/.knock.conf.old 2> /dev/null
cp $INSTALL_DIR/knock.conf ~/.knock.conf 2> /dev/null
cd $PLUGINS_DIR/BruteX/ && bash install.sh 2> /dev/null
cd $PLUGINS_DIR/spoofcheck/ && pip install -r requirements.txt 2> /dev/null
cd $PLUGINS_DIR/CMSmap/ && pip3 install . && python3 setup.py install
cd $INSTALL_DIR 
mkdir $LOOT_DIR 2> /dev/null
mkdir $LOOT_DIR/screenshots/ -p 2> /dev/null
mkdir $LOOT_DIR/nmap -p 2> /dev/null
mkdir $LOOT_DIR/domains -p 2> /dev/null
mkdir $LOOT_DIR/output -p 2> /dev/null
mkdir $LOOT_DIR/reports -p 2> /dev/null
chmod +x $INSTALL_DIR/knock
chmod +x $PLUGINS_DIR/Goohak/goohak
rm -f /usr/bin/knock
rm -f /usr/bin/goohak
rm -f /usr/bin/dirsearch
ln -s $INSTALL_DIR/knock /usr/bin/knock
ln -s $PLUGINS_DIR/Goohak/goohak /usr/bin/goohak
ln -s $PLUGINS_DIR/dirsearch/dirsearch.py /usr/bin/dirsearch
msfdb init 
chmod +x $INSTALL_DIR/bin/*
echo -e "$OKORANGE + -- --=[Done!]=-- -- + $RESET"
echo -e "$OKORANGE + -- --=[To run, type 'knock'!]=-- -- + $RESET"
