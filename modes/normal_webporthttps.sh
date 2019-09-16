if [ "$MODE" = "web" ]; then
    if [ "$WEB_BRUTE_COMMONSCAN" == "1" ]; then
        echo -e "${OKGREEN}=======================================${RESET}"
        echo -e "$OKRED RUNNING COMMON FILE/DIRECTORY BRUTE FORCE $RESET"
        echo -e "${OKGREEN}=======================================${RESET}"
        python3 $PLUGINS_DIR/dirsearch/dirsearch.py -b -u https://$TARGET/ -x 400,403,404,405,406,429,502,503,504 -F -e htm,html,asp,aspx,php,jsp,action,do,war,cfm,page,bak,cfg,sql,git,sql,txt,md,zip,jar,tar.gz,conf,swp,xml,ini,yml,cgi,pl,js,json
    fi
    cat $PLUGINS_DIR/dirsearch/reports/$TARGET/* 2> /dev/null
    cat $PLUGINS_DIR/dirsearch/reports/$TARGET/* > $LOOT_DIR/web/dirsearch-$TARGET.txt 2> /dev/null
    wget https://$TARGET/robots.txt -O $LOOT_DIR/web/robots-$TARGET-https.txt 2> /dev/null
    if [ "$NMAP_SCRIPTS" == "1" ]; then
        echo -e "${OKGREEN}=======================================${RESET}"
        echo -e "$OKRED RUNNING NMAP HTTPS SCRIPTS $RESET"
        echo -e "${OKGREEN}=======================================${RESET}"
        nmap -sS -sC -sV -T5 -Pn -A -O -p 443 --script=/usr/share/nmap/scripts/iis-buffer-overflow.nse $TARGET | tee $LOOT_DIR/output/nmap-$TARGET-port443
        sed -r "s/</\&lh\;/g" $LOOT_DIR/output/nmap-$TARGET-port443 2> /dev/null > $LOOT_DIR/output/nmap-$TARGET-port443.txt 2> /dev/null
        rm -f $LOOT_DIR/output/nmap-$TARGET-port443 2> /dev/null
    fi
    if [ "$CLUSTERD" == "1" ]; then
        echo -e "${OKGREEN}=======================================${RESET}"
        echo -e "$OKRED ENUMERATING WEB SOFTWARE $RESET"
        echo -e "${OKGREEN}=======================================${RESET}"
        clusterd --ssl -i $TARGET 2> /dev/null | tee $LOOT_DIR/web/clusterd-$TARGET-https.txt
    fi
    if [ "$CMSMAP" == "1" ]; then
        echo -e "${OKGREEN}=======================================${RESET}"
        echo -e "$OKRED RUNNING CMSMAP $RESET"
        echo -e "${OKGREEN}=======================================${RESET}"
        cmsmap -v https://$TARGET/ | tee $LOOT_DIR/web/cmsmap-$TARGET-httpsa.txt
        echo ""
    fi
    if [ "$WPSCAN" == "1" ]; then
        echo -e "${OKGREEN}=======================================${RESET}"
        echo -e "$OKRED RUNNING WORDPRESS VULNERABILITY SCAN $RESET"
        echo -e "${OKGREEN}=======================================${RESET}"
        wpscan --url https://$TARGET/ --no-update --disable-tls-checks 2> /dev/null | tee $LOOT_DIR/web/cmsmap-$TARGET-httpsa.txt
        echo ""
    fi
    if [ "$SHOCKER" = "1" ]; then
        echo -e "${OKGREEN}=======================================${RESET}"
        echo -e "$OKRED RUNNING SHELLSHOCK EXPLOIT SCAN $RESET"
        echo -e "${OKGREEN}=======================================${RESET}"
        python $PLUGINS_DIR/shocker/shocker.py -H $TARGET --cgilist $PLUGINS_DIR/shocker/shocker-cgi_list --ssl --port 443 | tee $LOOT_DIR/web/shocker-$TARGET-port443.txt
    fi
    if [ "$JEXBOSS" = "1" ]; then
        echo -e "${OKGREEN}=======================================${RESET}"
        echo -e "$OKRED RUNNING JEXBOSS $RESET"
        echo -e "${OKGREEN}=======================================${RESET}"
        cd /tmp/
        python /usr/share/knock/plugins/jexboss/jexboss.py -u https://$TARGET | tee $LOOT_DIR/web/jexboss-$TARGET-port443.raw
        sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" $LOOT_DIR/web/jexboss-$TARGET-port443.raw > $LOOT_DIR/web/jexboss-$TARGET-port443.txt 2> /dev/null
        rm -f $LOOT_DIR/web/jexboss-$TARGET-port443.raw 2> /dev/null
        cd $INSTALL_DIR
    fi
    cd $INSTALL_DIR
    if [ "$METASPLOIT_EXPLOIT" == "1" ]; then
        PORT="443"
        SSL="true"
        source modes/web_autopwn.sh
    fi
fi