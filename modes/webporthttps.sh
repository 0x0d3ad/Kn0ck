# WEBPORTHTTPS MODE #
if [ "$MODE" = "webporthttps" ]; then
  if [ "$REPORT" = "1" ]; then
    if [ ! -z "$WORKSPACE" ]; then
      args="$args -w $WORKSPACE"
      LOOT_DIR=$INSTALL_DIR/loot/workspace/$WORKSPACE
      echo -e "$OKBLUE[*] Saving loot to $LOOT_DIR [$RESET${OKGREEN}OK${RESET}$OKBLUE]$RESET"
      mkdir -p $LOOT_DIR 2> /dev/null
      mkdir $LOOT_DIR/domains 2> /dev/null
      mkdir $LOOT_DIR/screenshots 2> /dev/null
      mkdir $LOOT_DIR/nmap 2> /dev/null
      mkdir $LOOT_DIR/notes 2> /dev/null
      mkdir $LOOT_DIR/reports 2> /dev/null
      mkdir $LOOT_DIR/scans 2> /dev/null
      mkdir $LOOT_DIR/output 2> /dev/null
    fi
    echo "knock -t $TARGET -m $MODE -p $PORT --noreport $args" >> $LOOT_DIR/scans/$TARGET-$MODE.txt
    knock -t $TARGET -m $MODE -p $PORT --noreport $args | tee $LOOT_DIR/output/knock-$TARGET-$MODE-$PORT-`date +%Y%m%d%H%M`.txt 2>&1
    exit
  fi
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
  echo -e ""
  echo -e ""
  echo -e "               ;               ,           "
  echo -e "             ,;                 '.         "
  echo -e "            ;:                   :;        "
  echo -e "           ::                     ::       "
  echo -e "           ::                     ::       "
  echo -e "           ':                     :        "
  echo -e "            :.                    :        "
  echo -e "         ;' ::                   ::  '     "
  echo -e "        .'  ';                   ;'  '.    "
  echo -e "       ::    :;                 ;:    ::   "
  echo -e "       ;      :;.             ,;:     ::   "
  echo -e "       :;      :;:           ,;\"      ::   "
  echo -e "       ::.      ':;  ..,.;  ;:'     ,.;:   "
  echo -e "        \"'\"...   '::,::::: ;:   .;.;\"\"'    "
  echo -e "            '\"\"\"....;:::::;,;.;\"\"\"         "
  echo -e "        .:::.....'\"':::::::'\",...;::::;.   "
  echo -e "       ;:' '\"\"'\"\";.,;:::::;.'\"\"\"\"\"\"  ':;   "
  echo -e "      ::'         ;::;:::;::..         :;  "
  echo -e "     ::         ,;:::::::::::;:..       :: "
  echo -e "     ;'     ,;;:;::::::::::::::;\";..    ':."
  echo -e "    ::     ;:\"  ::::::\"\"\"'::::::  \":     ::"
  echo -e "     :.    ::   ::::::;  :::::::   :     ; "
  echo -e "      ;    ::   :::::::  :::::::   :    ;  "
  echo -e "       '   ::   ::::::....:::::'  ,:   '   "
  echo -e "        '  ::    :::::::::::::\"   ::       "
  echo -e "           ::     ':::::::::\"'    ::       "
  echo -e "           ':       \"\"\"\"\"\"\"'      ::       "
  echo -e "            ::                   ;:        "
  echo -e "            ':;                 ;:\"        "
  echo -e "    -hrr-     ';              ,;'          "
  echo -e "                \"'           '\"            "
  echo -e "                  ''''$RESET"
  echo ""
  echo "$TARGET" >> $LOOT_DIR/domains/targets.txt
  echo -e "${OKGREEN}=======================================${RESET}"
  echo -e "$OKRED RUNNING TCP PORT SCAN $RESET"
  echo -e "${OKGREEN}=======================================${RESET}"
  nmap -sV -Pn -p $PORT --open $TARGET -oX $LOOT_DIR/nmap/nmap-https-$TARGET.xml
  port_https=`grep 'portid="'$PORT'"' $LOOT_DIR/nmap/nmap-https-$TARGET.xml | grep open`
  if [ -z "$port_https" ];
  then
    echo -e "$OKRED + -- --=[Port $PORT closed... skipping.$RESET"
  else
    echo -e "$OKORANGE + -- --=[Port $PORT opened... running tests...$RESET"
    if [ "$WAFWOOF" == "1" ]; then
      echo -e "${OKGREEN}=======================================${RESET}"
      echo -e "$OKRED CHECKING FOR WAF $RESET"
      echo -e "${OKGREEN}=======================================${RESET}"
      wafw00f https://$TARGET:$PORT | tee $LOOT_DIR/web/waf-$TARGET-https-port$PORT.txt 2> /dev/null
      echo ""
    fi
    if [ "$WHATWEB" == "1" ]; then
      echo -e "${OKGREEN}=======================================${RESET}"
      echo -e "$OKRED GATHERING HTTP INFO $RESET"
      echo -e "${OKGREEN}=======================================${RESET}"
      whatweb -a 3 https://$TARGET:$PORT | tee $LOOT_DIR/web/whatweb-$TARGET-https-port$PORT.raw  2> /dev/null
      sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" $LOOT_DIR/web/whatweb-$TARGET-https-port$PORT.raw > $LOOT_DIR/web/whatweb-$TARGET-https-port$PORT.txt 2> /dev/null
      rm -f $LOOT_DIR/web/whatweb-$TARGET-https-port$PORT.raw 2> /dev/null
      echo ""
    fi
    if [ "$WIG" == "1" ]; then
      echo -e "${OKGREEN}=======================================${RESET}"
      echo -e "$OKRED GATHERING SERVER INFO $RESET"
      echo -e "${OKGREEN}=======================================${RESET}"
      python3 $PLUGINS_DIR/wig/wig.py -d -q https://$TARGET:$PORT | tee $LOOT_DIR/web/wig-$TARGET-https-$PORT
      sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" $LOOT_DIR/web/wig-$TARGET-https-$PORT > $LOOT_DIR/web/wig-$TARGET-https-$PORT.txt 2> /dev/null
    fi
    echo -e "${OKGREEN}=======================================${RESET}"
    echo -e "$OKRED CHECKING HTTP HEADERS AND METHODS $RESET"
    echo -e "${OKGREEN}=======================================${RESET}"
    wget -qO- -T 1 --connect-timeout=5 --read-timeout=5 --tries=1 https://$TARGET:$PORT |  perl -l -0777 -ne 'print $1 if /<title.*?>\s*(.*?)\s*<\/title/si' >> $LOOT_DIR/web/title-https-$TARGET-$PORT.txt 2> /dev/null
    curl --connect-timeout 5 -I -s -R https://$TARGET:$PORT | tee $LOOT_DIR/web/headers-https-$TARGET-$PORT.txt 2> /dev/null
    curl --connect-timeout 5 -I -s -R -L https://$TARGET:$PORT | tee $LOOT_DIR/web/websource-https-$TARGET-$PORT.txt 2> /dev/null
    if [ "$WEBTECH" = "1" ]; then
      echo -e "${OKGREEN}=======================================${RESET}"
      echo -e "$OKRED GATHERING WEB FINGERPRINT $RESET"
      echo -e "${OKGREEN}=======================================${RESET}"
      webtech -u https://$TARGET:$PORT | grep \- | cut -d- -f2- | tee $LOOT_DIR/web/webtech-$TARGET-https-port$PORT.txt
    fi
    echo -e "${OKGREEN}=======================================${RESET}"
    echo -e "$OKRED DISPLAYING META GENERATOR TAGS $RESET"
    echo -e "${OKGREEN}=======================================${RESET}"
    cat $LOOT_DIR/web/websource-https-$TARGET-$PORT.txt 2> /dev/null | grep generator | cut -d\" -f4 2> /dev/null | tee $LOOT_DIR/web/webgenerator-https-$TARGET-$PORT.txt 2> /dev/null
    echo -e "${OKGREEN}=======================================${RESET}"
    echo -e "$OKRED DISPLAYING COMMENTS $RESET"
    echo -e "${OKGREEN}=======================================${RESET}"
    cat $LOOT_DIR/web/websource-https-$TARGET-$PORT.txt 2> /dev/null | grep "<\!\-\-" 2> /dev/null | tee $LOOT_DIR/web/webcomments-https-$TARGET-$PORT.txt 2> /dev/null
    echo -e "${OKGREEN}=======================================${RESET}"
    echo -e "$OKRED DISPLAYING SITE LINKS $RESET"
    echo -e "${OKGREEN}=======================================${RESET}"
    cat $LOOT_DIR/web/websource-https-$TARGET-$PORT.txt 2> /dev/null | egrep "\"" | cut -d\" -f2 | grep  \/ | sort -u 2> /dev/null | tee $LOOT_DIR/web/weblinks-https-$TARGET-$PORT.txt 2> /dev/null
    if [ "$SSL" = "1" ]; then
      echo -e "${OKGREEN}=======================================${RESET}"
      echo -e "$OKRED GATHERING SSL/TLS INFO $RESET"
      echo -e "${OKGREEN}=======================================${RESET}"
      sslscan --no-failed $TARGET:$PORT | tee $LOOT_DIR/web/sslscan-$TARGET-$PORT.raw 2> /dev/null
      sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" $LOOT_DIR/web/sslscan-$TARGET-$PORT.raw > $LOOT_DIR/web/sslscan-$TARGET-$PORT.txt 2> /dev/null
      rm -f $LOOT_DIR/web/sslscan-$TARGET-$PORT.raw 2> /dev/null
      echo ""
    fi
    echo -e "${OKGREEN}=======================================${RESET}"
    echo -e "$OKRED SAVING SCREENSHOTS $RESET"
    echo -e "${OKGREEN}=======================================${RESET}"
    if [ ${DISTRO} == "blackarch"  ]; then
      /bin/CutyCapt --url=https://$TARGET:$PORT --out=$LOOT_DIR/screenshots/$TARGET-port$PORT.jpg --insecure --max-wait=5000 2> /dev/null
    else
      cutycapt --url=https://$TARGET:$PORT --out=$LOOT_DIR/screenshots/$TARGET-port$PORT.jpg --insecure --max-wait=5000 2> /dev/null
    fi
    echo -e "$OKRED[+]$RESET Screenshot saved to $LOOT_DIR/screenshots/$TARGET-port$PORT.jpg"
    if [ "$BURP_SCAN" == "1" ]; then
        echo -e "${OKGREEN}=======================================${RESET}"
        echo -e "$OKRED RUNNING BURPSUITE SCAN $RESET"
        echo -e "${OKGREEN}=======================================${RESET}"
        if [ "$VERBOSE" == "1" ]; then
          echo -e "$OKBLUE[$RESET${OKRED}i${RESET}$OKBLUE]$OKGREEN curl -X POST \"http://$BURP_HOST:$BURP_PORT/v0.1/scan\" -d \"{\"scope\":{\"include\":[{\"rule\":\"https://$TARGET:$PORT\"}],\"type\":\"SimpleScope\"},\"urls\":[\"https://$TARGET:$PORT\"]}\"$RESET"
        fi
        curl -s -X POST "http://$BURP_HOST:$BURP_PORT/v0.1/scan" -d "{\"scope\":{\"include\":[{\"rule\":\"https://$TARGET:$PORT\"}],\"type\":\"SimpleScope\"},\"urls\":[\"https://$TARGET:$PORT\"]}"
        echo ""
    fi
    if [ "$NMAP_SCRIPTS" == "1" ]; then
      echo -e "${OKGREEN}=======================================${RESET}"
      echo -e "$OKRED RUNNING NMAP SCRIPTS $RESET"
      echo -e "${OKGREEN}=======================================${RESET}"
      nmap -A -Pn -T5 -p $PORT -sV --script=/usr/share/nmap/scripts/iis-buffer-overflow.nse --script=http-vuln* $TARGET | tee $LOOT_DIR/output/nmap-$TARGET-port$PORT
      sed -r "s/</\&lh\;/g" $LOOT_DIR/output/nmap-$TARGET-port$PORT 2> /dev/null > $LOOT_DIR/output/nmap-$TARGET-port$PORT.txt 2> /dev/null
      rm -f $LOOT_DIR/output/nmap-$TARGET-port$PORT 2> /dev/null
    fi
    if [ "$PASSIVE_SPIDER" == "1" ]; then
      echo -e "${OKGREEN}=======================================${RESET}"
      echo -e "$OKRED RUNNING PASSIVE WEB SPIDER $RESET"
      echo -e "${OKGREEN}=======================================${RESET}"
      curl -sX GET "http://index.commoncrawl.org/CC-MAIN-2018-22-index?url=*.$TARGET&output=json" | jq -r .url | tee $LOOT_DIR/web/passivespider-$TARGET.txt 2> /dev/null
    fi
    if [ "$WAYBACKMACHINE" == "1" ]; then
      echo -e "${OKGREEN}=======================================${RESET}"
      echo -e "$OKRED FETCHING WAYBACK MACHINE URLS $RESET"
      echo -e "${OKGREEN}=======================================${RESET}"
      curl -sX GET "http://web.archive.org/cdx/search/cdx?url=*.$TARGET/*&output=text&fl=original&collapse=urlkey" | tee $LOOT_DIR/web/waybackurls-$TARGET.txt 2> /dev/null
    fi
    if [ "$BLACKWIDOW" == "1" ]; then
      echo -e "${OKGREEN}=======================================${RESET}"
      echo -e "$OKRED RUNNING ACTIVE WEB SPIDER & APPLICATION SCAN $RESET"
      echo -e "${OKGREEN}=======================================${RESET}"
      blackwidow -u https://$TARGET:$PORT -l 3 -s y -v n 2> /dev/null
      cat /usr/share/blackwidow/$TARGET*/* 2> /dev/null > $LOOT_DIR/web/spider-$TARGET.txt 2>/dev/null
      cat $LOOT_DIR/web/waybackurls-$TARGET.txt 2> /dev/null >> $LOOT_DIR/web/spider-$TARGET.txt 2>/dev/null
      cat $LOOT_DIR/web/passivespider-$TARGET.txt 2> /dev/null >> $LOOT_DIR/web/spider-$TARGET.txt 2>/dev/null
    fi
    if [ "$WEB_BRUTE_COMMON" == "1" ]; then
      echo -e "${OKGREEN}=======================================${RESET}"
      echo -e "$OKRED RUNNING COMMON FILE/DIRECTORY BRUTE FORCE $RESET"
      echo -e "${OKGREEN}=======================================${RESET}"
      python3 $PLUGINS_DIR/dirsearch/dirsearch.py -u https://$TARGET:$PORT -w $WEB_BRUTE_COMMON -x 400,403,404,405,406,429,502,503,504 -F -e htm,html,asp,aspx,php,jsp,action,do,war,cfm,page,bak,cfg,sql,git,sql,txt,md,zip,jar,tar.gz,conf,swp,xml,ini,yml,cgi,pl,js,json
    fi
    if [ "$WEB_BRUTE_FULLSCAN" == "1" ]; then
      echo -e "${OKGREEN}=======================================${RESET}"
      echo -e "$OKRED RUNNING FULL FILE/DIRECTORY BRUTE FORCE $RESET"
      echo -e "${OKGREEN}=======================================${RESET}"
      python3 $PLUGINS_DIR/dirsearch/dirsearch.py -u https://$TARGET:$PORT -w $WEB_BRUTE_FULL -x 400,403,404,405,406,429,502,503,504 -F -e htm,html,asp,aspx,php,jsp,action,do,war,cfm,page,bak,cfg,sql,git,sql,txt,md,zip,jar,tar.gz,conf,swp,xml,ini,yml,cgi,pl,js,json
    fi
    if [ "$WEB_BRUTE_EXPLOITSCAN" == "1" ]; then
        echo -e "${OKGREEN}=======================================${RESET}"
        echo -e "$OKRED RUNNING FILE/DIRECTORY BRUTE FORCE FOR VULNERABILITIES $RESET"
        echo -e "${OKGREEN}=======================================${RESET}"
        python3 $PLUGINS_DIR/dirsearch/dirsearch.py -u https://$TARGET:$PORT -w $WEB_BRUTE_EXPLOITS -x 400,403,404,405,406,429,502,503,504 -F -e htm,html,asp,aspx,php,jsp,action,do,war,cfm,page,bak,cfg,sql,git,sql,txt,md,zip,jar,tar.gz,conf,swp,xml,ini,yml,cgi,pl,js,json 
    fi
    cat $PLUGINS_DIR/dirsearch/reports/$TARGET/* 2> /dev/null
    cat $PLUGINS_DIR/dirsearch/reports/$TARGET/* > $LOOT_DIR/web/dirsearch-$TARGET.txt 2> /dev/null
    wget https://$TARGET:$PORT/robots.txt -O $LOOT_DIR/web/robots-$TARGET:$PORT-https.txt 2> /dev/null
    if [ "$CLUSTERD" == "1" ]; then
      echo -e "${OKGREEN}=======================================${RESET}"
      echo -e "$OKRED ENUMERATING WEB SOFTWARE $RESET"
      echo -e "${OKGREEN}=======================================${RESET}"
      clusterd --ssl -i $TARGET -p $PORT 2> /dev/null | tee $LOOT_DIR/web/clusterd-$TARGET-port$PORT.txt
    fi
    if [ "$CMSMAP" == "1" ]; then
      echo -e "${OKGREEN}=======================================${RESET}"
      echo -e "$OKRED RUNNING CMSMAP $RESET"
      echo -e "${OKGREEN}=======================================${RESET}"
      cmsmap https://$TARGET:$PORT | tee $LOOT_DIR/web/cmsmap-$TARGET-http-port$PORTa.txt
      echo ""
      cmsmap https://$TARGET:$PORT/wordpress/ | tee $LOOT_DIR/web/cmsmap-$TARGET-http-port$PORTb.txt
      echo ""
    fi
    if [ "$WPSCAN" == "1" ]; then
      echo -e "${OKGREEN}=======================================${RESET}"
      echo -e "$OKRED RUNNING WORDPRESS VULNERABILITY SCAN $RESET"
      echo -e "${OKGREEN}=======================================${RESET}"
      wpscan --url https://$TARGET:$PORT --no-update --disable-tls-checks 2> /dev/null | tee $LOOT_DIR/web/wpscan-$TARGET-http-port$PORTa.txt
      echo ""
      wpscan --url https://$TARGET:$PORT/wordpress/ --no-update --disable-tls-checks 2> /dev/null | tee $LOOT_DIR/web/wpscan-$TARGET-http-port$PORTb.txt
    fi
    if [ "$NIKTO" == "1" ]; then
      echo -e "${OKGREEN}=======================================${RESET}"
      echo -e "$OKRED RUNNING WEB VULNERABILITY SCAN $RESET"
      echo -e "${OKGREEN}=======================================${RESET}"
      nikto -h https://$TARGET:$PORT -output $LOOT_DIR/web/nikto-$TARGET-https-port$PORT.txt
    fi
    if [ "$SHOCKER" == "1" ]; then
      echo -e "${OKGREEN}=======================================${RESET}"
      echo -e "$OKRED RUNNING SHELLSHOCK EXPLOIT SCAN $RESET"
      echo -e "${OKGREEN}=======================================${RESET}"
      python $PLUGINS_DIR/shocker/shocker.py -H $TARGET --cgilist $PLUGINS_DIR/shocker/shocker-cgi_list --ssl --port $PORT | tee $LOOT_DIR/web/shocker-$TARGET-port$PORT.txt
    fi
    if [ "$JEXBOSS" == "1" ]; then
      echo -e "${OKGREEN}=======================================${RESET}"
      echo -e "$OKRED RUNNING JEXBOSS $RESET"
      echo -e "${OKGREEN}=======================================${RESET}"
      cd /tmp/
      python /usr/share/knock/plugins/jexboss/jexboss.py -u https://$TARGET:$PORT | tee $LOOT_DIR/web/jexboss-$TARGET-port$PORT.raw
      sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" $LOOT_DIR/web/jexboss-$TARGET-port$PORT.raw > $LOOT_DIR/web/jexboss-$TARGET-port$PORT.txt 2> /dev/null
      rm -f $LOOT_DIR/web/jexboss-$TARGET-port$PORT.raw 2> /dev/null
      cd $INSTALL_DIR
    fi
    cd $INSTALL_DIR
    if [ "$METASPLOIT_EXPLOIT" == "1" ]; then
      SSL="true"
      source modes/web_autopwn.sh 
    fi
    source modes/osint_stage_2.sh
  fi
  echo -e "${OKGREEN}=======================================${RESET}"
  echo -e "$OKRED SCAN COMPLETE! $RESET"
  echo -e "${OKGREEN}=======================================${RESET}"
  echo "$TARGET" >> $LOOT_DIR/scans/updated.txt
  rm -f $INSTALL_DIR/.fuse_* 2> /dev/null
  if [ "$LOOT" = "1" ]; then
    loot
  fi
  exit
fi 