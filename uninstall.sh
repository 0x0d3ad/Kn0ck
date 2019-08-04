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
echo -e "$OKORANGE +----=[Kn0ck by @Mils]=----+ $RESET"
echo ""

INSTALL_DIR=/usr/share/knock

echo -e "$OKGREEN + -- --=[This script will uninstall knock and remove ALL files under $INSTALL_DIR. Are you sure you want to continue?]=-- --+ $RESET"
read answer 

rm -Rf /usr/share/knock/
rm -f /usr/bin/knock

echo -e "$OKORANGE + -- --=[Done!]=-- --+ $RESET"