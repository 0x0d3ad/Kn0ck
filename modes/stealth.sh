# STEALTH MODE #
if [ "$MODE" = "stealth" ]; then
  if [ "$REPORT" = "1" ]; then
    args="-t $TARGET"
    if [ "$OSINT" = "1" ]; then
      args="$args -o"
    fi
    if [ "$AUTOBRUTE" = "1" ]; then
      args="$args -b"
    fi
    if [ "$FULLNMAPSCAN" = "1" ]; then
      args="$args -fp"
    fi
    if [ "$RECON" = "1" ]; then
      args="$args -re"
    fi
    if [ ! -z "$WORKSPACE" ]; then
      args="$args -w $WORKSPACE"
      LOOT_DIR=$INSTALL_DIR/loot/workspace/$WORKSPACE
      echo -e "$OKBLUE[*] Saving loot to $LOOT_DIR [$RESET${OKGREEN}OK${RESET}$OKBLUE]$RESET"
      mkdir -p $LOOT_DIR 2> /dev/null
      mkdir $LOOT_DIR/domains 2> /dev/null
      mkdir $LOOT_DIR/screenshots 2> /dev/null
      mkdir $LOOT_DIR/nmap 2> /dev/null
      mkdir $LOOT_DIR/reports 2> /dev/null
      mkdir $LOOT_DIR/scans 2> /dev/null
      mkdir $LOOT_DIR/output 2> /dev/null
    fi
    args="$args --noreport -m stealth"
    echo "knock -t $TARGET -m $MODE --noreport $args" >> $LOOT_DIR/scans/$TARGET-$MODE.txt
    knock $args | tee $LOOT_DIR/output/knock-$TARGET-$MODE-`date +%Y%m%d%H%M`.txt 2>&1
    exit
  fi
  echo ""
  echo -e "$OKORANGE +----=[knock by @Mils]=----+ $RESET"
  echo ""
  echo -e "$OKRED          "
  echo -e "$OKRED   ____ /\\"
  echo -e "$OKRED        \ \\"
  echo -e "$OKRED         \ \\"
  echo -e "$OKRED     ___ /  \\"
  echo -e "$OKRED         \   \\"
  echo -e "$OKRED      === > [ \\"
  echo -e "$OKRED         /   \ \\"
  echo -e "$OKRED         \   / /"
  echo -e "$OKRED      === > [ /"
  echo -e "$OKRED         /   /"
  echo -e "$OKRED     ___ \  /"
  echo -e "$OKRED         / /"
  echo -e "$OKRED   ____ / /"
  echo -e "$OKRED        \/$RESET"
  echo -e "$RESET"
  echo -e "$OKORANGE + -- --=[Launching stealth scan: $TARGET $RESET"
  echo -e "$OKGREEN $RESET"
  
  echo "$TARGET" >> $LOOT_DIR/domains/targets.txt

  echo -e "${OKGREEN}=======================================${RESET}"
  echo -e "$OKRED GATHERING DNS INFO $RESET"
  echo -e "${OKGREEN}=======================================${RESET}"
  if [ "$VERBOSE" == "1" ]; then
    echo -e "$OKBLUE[$RESET${OKRED}i${RESET}$OKBLUE]$OKGREEN dig all +short $TARGET > $LOOT_DIR/nmap/dns-$TARGET.txt 2> /dev/null"
    echo -e "$OKBLUE[$RESET${OKRED}i${RESET}$OKBLUE]$OKGREEN dig all +short -x $TARGET >> $LOOT_DIR/nmap/dns-$TARGET.txt 2> /dev/null"
    echo -e "$OKBLUE[$RESET${OKRED}i${RESET}$OKBLUE]$OKGREEN dnsenum $TARGET 2> /dev/null | tee $LOOT_DIR/output/dnsenum-$TARGET.txt 2> /dev/null$RESET"
  fi
  dig all +short $TARGET > $LOOT_DIR/nmap/dns-$TARGET.txt 2> /dev/null
  dig all +short -x $TARGET >> $LOOT_DIR/nmap/dns-$TARGET.txt 2> /dev/null
  dig A $TARGET 2> /dev/null >> $LOOT_DIR/ips/ips-all-unsorted.txt 2> /dev/null
  dnsenum $TARGET 2> /dev/null | tee $LOOT_DIR/output/dnsenum-$TARGET.txt 2> /dev/null
  mv -f *_ips.txt $LOOT_DIR/domains/ 2>/dev/null

  if [ $SCAN_TYPE == "DOMAIN" ];
  then
    echo -e "${OKGREEN}=======================================${RESET}"
    echo -e "$OKRED CHECKING FOR SUBDOMAIN HIJACKING $RESET"
    echo -e "${OKGREEN}=======================================${RESET}"
    if [ "$VERBOSE" == "1" ]; then
      echo -e "$OKBLUE[$RESET${OKRED}i${RESET}$OKBLUE]$OKGREEN cat $LOOT_DIR/nmap/dns-$TARGET.txt 2> /dev/null | egrep -i \"wordpress|instapage|heroku|github|bitbucket|squarespace|fastly|feed|fresh|ghost|helpscout|helpjuice|instapage|pingdom|surveygizmo|teamwork|tictail|shopify|desk|teamwork|unbounce|helpjuice|helpscout|pingdom|tictail|campaign|monitor|cargocollective|statuspage|tumblr|amazon|hubspot|cloudfront|modulus|unbounce|uservoice|wpengine|cloudapp\" | tee $LOOT_DIR/nmap/takeovers-$TARGET.txt 2>/dev/null$RESET"
    fi
    cat $LOOT_DIR/nmap/dns-$TARGET.txt 2> /dev/null | egrep -i "wordpress|instapage|heroku|github|bitbucket|squarespace|fastly|feed|fresh|ghost|helpscout|helpjuice|instapage|pingdom|surveygizmo|teamwork|tictail|shopify|desk|teamwork|unbounce|helpjuice|helpscout|pingdom|tictail|campaign|monitor|cargocollective|statuspage|tumblr|amazon|hubspot|cloudfront|modulus|unbounce|uservoice|wpengine|cloudapp" | tee $LOOT_DIR/nmap/takeovers-$TARGET.txt 2>/dev/null

    source modes/osint.sh
    source modes/recon.sh

    cd $INSTALL_DIR
    echo ""
  fi
  echo ""
  echo -e "${OKGREEN}=======================================${RESET}"
  echo -e "$OKRED RUNNING TCP PORT SCAN $RESET"
  echo -e "${OKGREEN}=======================================${RESET}"
  if [ "$VERBOSE" == "1" ]; then
      echo -e "$OKBLUE[$RESET${OKRED}i${RESET}$OKBLUE]$OKGREEN nmap -sS -T5 --open -Pn -p $DEFAULT_PORTS $TARGET -oX $LOOT_DIR/nmap/nmap-$TARGET.xml | tee $LOOT_DIR/nmap/nmap-$TARGET.txt$RESET"
  fi
  nmap -sS -T5 --open -Pn -p $DEFAULT_PORTS $TARGET -oX $LOOT_DIR/nmap/nmap-$TARGET.xml | tee $LOOT_DIR/nmap/nmap-$TARGET.txt
 
  port_80=`grep 'portid="80"' $LOOT_DIR/nmap/nmap-$TARGET.xml | grep open`
  port_443=`grep 'portid="443"' $LOOT_DIR/nmap/nmap-$TARGET.xml | grep open`
 
  if [ -z "$port_80" ];
  then
    echo -e "$OKRED + -- --=[Port 80 closed... skipping.$RESET"
  else
    echo -e "$OKORANGE + -- --=[Port 80 opened... running tests...$RESET"
    if [ "$WAFWOOF" == "1" ]; then
      echo -e "${OKGREEN}=======================================${RESET}"
      echo -e "$OKRED CHECKING FOR WAF $RESET"
      echo -e "${OKGREEN}=======================================${RESET}"
      if [ "$VERBOSE" == "1" ]; then
        echo -e "$OKBLUE[$RESET${OKRED}i${RESET}$OKBLUE]$OKGREEN wafw00f http://$TARGET | tee $LOOT_DIR/web/waf-$TARGET-http 2> /dev/null$RESET"
      fi
      wafw00f http://$TARGET | tee $LOOT_DIR/web/waf-$TARGET-http.raw 2> /dev/null
      sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" $LOOT_DIR/web/waf-$TARGET-http.raw > $LOOT_DIR/web/waf-$TARGET-http.txt 2> /dev/null
      rm -f tee $LOOT_DIR/web/waf-$TARGET-http.raw 2> /dev/null
    fi
    if [ "$WHATWEB" == "1" ]; then
      echo -e "${OKGREEN}=======================================${RESET}"
      echo -e "$OKRED GATHERING HTTP INFO $RESET"
      echo -e "${OKGREEN}=======================================${RESET}"
      if [ "$VERBOSE" == "1" ]; then
        echo -e "$OKBLUE[$RESET${OKRED}i${RESET}$OKBLUE]$OKGREEN whatweb -a 3 http://$TARGET | tee $LOOT_DIR/web/whatweb-$TARGET-http 2> /dev/null$RESET"
      fi
      whatweb -a 3 http://$TARGET | tee $LOOT_DIR/web/whatweb-$TARGET-http.raw 2> /dev/null
      sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" $LOOT_DIR/web/whatweb-$TARGET-http.raw > $LOOT_DIR/web/whatweb-$TARGET-http.txt 2> /dev/null
      rm -f $LOOT_DIR/web/whatweb-$TARGET-http.raw 2> /dev/null 
    fi
    echo -e "${OKGREEN}=======================================${RESET}"
    echo -e "$OKRED CHECKING HTTP HEADERS AND METHODS $RESET"
    echo -e "${OKGREEN}=======================================${RESET}"
    if [ "$VERBOSE" == "1" ]; then
      echo -e "$OKBLUE[$RESET${OKRED}i${RESET}$OKBLUE]$OKGREEN wget -qO- -T 1 --connect-timeout=3 --read-timeout=3 --tries=1 http://$TARGET |  perl -l -0777 -ne 'print $1 if /<title.*?>\s*(.*?)\s*<\/title/si' >> $LOOT_DIR/web/title-http-$TARGET.txt 2> /dev/null$RESET"
      echo -e "$OKBLUE[$RESET${OKRED}i${RESET}$OKBLUE]$OKGREEN curl --connect-timeout=5 --max-time 3 -I -s -R http://$TARGET | tee $LOOT_DIR/web/headers-http-$TARGET.txt 2> /dev/null$RESET"
    fi
    wget -qO- -T 1 --connect-timeout=5 --read-timeout=5 --tries=1 http://$TARGET |  perl -l -0777 -ne 'print $1 if /<title.*?>\s*(.*?)\s*<\/title/si' >> $LOOT_DIR/web/title-http-$TARGET.txt 2> /dev/null
    curl --connect-timeout 5 --max-time 5 -I -s -R http://$TARGET | tee $LOOT_DIR/web/headers-http-$TARGET.txt 2> /dev/null
    curl --connect-timeout 5 -s -R -L http://$TARGET > $LOOT_DIR/web/websource-http-$TARGET.txt 2> /dev/null
    if [ "$WEBTECH" = "1" ]; then
      echo -e "${OKGREEN}=======================================${RESET}"
      echo -e "$OKRED GATHERING WEB FINGERPRINT $RESET"
      echo -e "${OKGREEN}=======================================${RESET}"
      webtech -u http://$TARGET | grep \- | cut -d- -f2- | tee $LOOT_DIR/web/webtech-$TARGET-http.txt
    fi
    echo -e "${OKGREEN}=======================================${RESET}"
    echo -e "$OKRED DISPLAYING META GENERATOR TAGS $RESET"
    echo -e "${OKGREEN}=======================================${RESET}"
    cat $LOOT_DIR/web/websource-http-$TARGET.txt 2> /dev/null | grep generator | cut -d\" -f4 2> /dev/null | tee $LOOT_DIR/web/webgenerator-http-$TARGET.txt 2> /dev/null
    echo -e "${OKGREEN}=======================================${RESET}"
    echo -e "$OKRED DISPLAYING COMMENTS $RESET"
    echo -e "${OKGREEN}=======================================${RESET}"
    cat $LOOT_DIR/web/websource-http-$TARGET.txt 2> /dev/null | grep "<\!\-\-" 2> /dev/null | tee $LOOT_DIR/web/webcomments-http-$TARGET 2> /dev/null
    sed -r "s/</\&lh\;/g" $LOOT_DIR/web/webcomments-http-$TARGET 2> /dev/null > $LOOT_DIR/web/webcomments-http-$TARGET.txt 2> /dev/null
    rm -f $LOOT_DIR/web/webcomments-http-$TARGET 2> /dev/null
    echo -e "${OKGREEN}=======================================${RESET}"
    echo -e "$OKRED DISPLAYING SITE LINKS $RESET"
    echo -e "${OKGREEN}=======================================${RESET}"
    cat $LOOT_DIR/web/websource-http-$TARGET.txt 2> /dev/null | egrep "\"" | cut -d\" -f2 | grep  \/ | sort -u 2> /dev/null | tee $LOOT_DIR/web/weblinks-http-$TARGET.txt 2> /dev/null
    if [ "$WEB_BRUTE" == "1" ]; then
      echo -e "${OKGREEN}=======================================${RESET}"
      echo -e "$OKRED RUNNING FILE/DIRECTORY BRUTE FORCE $RESET"
      echo -e "${OKGREEN}=======================================${RESET}"
      if [ "$VERBOSE" == "1" ]; then
        echo -e "$OKBLUE[$RESET${OKRED}i${RESET}$OKBLUE]$OKGREEN python3 $PLUGINS_DIR/dirsearch/dirsearch.py -u http://$TARGET -w $WEB_BRUTE_STEALTH -x 400,403,404,405,406,429,502,503,504 -F -e php,asp,aspx,bak,zip,tar.gz,html,htm $RESET"
      fi
      python3 $PLUGINS_DIR/dirsearch/dirsearch.py -u http://$TARGET -w $WEB_BRUTE_STEALTH -x 400,403,404,405,406,429,502,503,504 -F -e php,asp,aspx,bak,zip,tar.gz,html,htm 
      cat $PLUGINS_DIR/dirsearch/reports/$TARGET/* 2> /dev/null
      cat $PLUGINS_DIR/dirsearch/reports/$TARGET/* > $LOOT_DIR/web/dirsearch-$TARGET.txt 2> /dev/null
      wget http://$TARGET/robots.txt -O $LOOT_DIR/web/robots-$TARGET-http.txt 2> /dev/null
    fi
    echo -e "${OKGREEN}=======================================${RESET}"
    echo -e "$OKRED SAVING SCREENSHOTS $RESET"
    echo -e "${OKGREEN}=======================================${RESET}"
    if [ ${DISTRO} == "blackarch"  ]; then
      /bin/CutyCapt --url=http://$TARGET --out=$LOOT_DIR/screenshots/$TARGET-port80.jpg --insecure --max-wait=5000 2> /dev/null
    else
      if [ "$VERBOSE" == "1" ]; then
        echo -e "$OKBLUE[$RESET${OKRED}i${RESET}$OKBLUE]$OKGREEN cutycapt --url=http://$TARGET --out=$LOOT_DIR/screenshots/$TARGET-port80.jpg --insecure --max-wait=5000 2> /dev/null$RESET"
      fi
      cutycapt --url=http://$TARGET --out=$LOOT_DIR/screenshots/$TARGET-port80.jpg --insecure --max-wait=5000 2> /dev/null
    fi
  fi
 
  if [ -z "$port_443" ];
  then
    echo -e "$OKRED + -- --=[Port 443 closed... skipping.$RESET"
  else
    echo -e "$OKORANGE + -- --=[Port 443 opened... running tests...$RESET"
    if [ $WAFWOOF == "1" ]; then
      echo -e "${OKGREEN}=======================================${RESET}"
      echo -e "$OKRED CHECKING FOR WAF $RESET"
      echo -e "${OKGREEN}=======================================${RESET}"
      if [ "$VERBOSE" == "1" ]; then
        echo -e "$OKBLUE[$RESET${OKRED}i${RESET}$OKBLUE]$OKGREEN wafw00f https://$TARGET | tee $LOOT_DIR/web/waf-$TARGET-https 2> /dev/null$RESET"
      fi
      wafw00f https://$TARGET | tee $LOOT_DIR/web/waf-$TARGET-https.raw 2> /dev/null
      sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" $LOOT_DIR/web/waf-$TARGET-https.raw > $LOOT_DIR/web/waf-$TARGET-https.txt 2> /dev/null
      rm -f tee $LOOT_DIR/web/waf-$TARGET-https.raw 2> /dev/null
    fi
    if [ $WHATWEB == "1" ]; then
      echo -e "${OKGREEN}=======================================${RESET}"
      echo -e "$OKRED GATHERING HTTP INFO $RESET"
      echo -e "${OKGREEN}=======================================${RESET}"
      if [ "$VERBOSE" == "1" ]; then
        echo -e "$OKBLUE[$RESET${OKRED}i${RESET}$OKBLUE]$OKGREEN whatweb -a 3 https://$TARGET | tee $LOOT_DIR/web/whatweb-$TARGET-https  2> /dev/null$RESET"
      fi
      whatweb -a 3 https://$TARGET | tee $LOOT_DIR/web/whatweb-$TARGET-https  2> /dev/null
      sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" $LOOT_DIR/web/whatweb-$TARGET-https > $LOOT_DIR/web/whatweb-$TARGET-https.txt 2> /dev/null
    fi
    echo -e "${OKGREEN}=======================================${RESET}"
    echo -e "$OKRED CHECKING HTTP HEADERS AND METHODS $RESET"
    echo -e "${OKGREEN}=======================================${RESET}"
    if [ "$VERBOSE" == "1" ]; then
      echo -e "$OKBLUE[$RESET${OKRED}i${RESET}$OKBLUE]$OKGREEN wget -qO- -T 1 --connect-timeout=3 --read-timeout=3 --tries=1 https://$TARGET |  perl -l -0777 -ne 'print $1 if /<title.*?>\s*(.*?)\s*<\/title/si' >> $LOOT_DIR/web/title-https-$TARGET.txt 2> /dev/null$RESET"
      echo -e "$OKBLUE[$RESET${OKRED}i${RESET}$OKBLUE]$OKGREEN curl --connect-timeout=5 --max-time 3 -I -s -R https://$TARGET | tee $LOOT_DIR/web/headers-https-$TARGET.txt 2> /dev/null$RESET"
    fi
    wget -qO- -T 1 --connect-timeout=5 --read-timeout=5 --tries=1 https://$TARGET |  perl -l -0777 -ne 'print $1 if /<title.*?>\s*(.*?)\s*<\/title/si' >> $LOOT_DIR/web/title-https-$TARGET.txt 2> /dev/null
    curl --connect-timeout 5 --max-time 5 -I -s -R https://$TARGET | tee $LOOT_DIR/web/headers-https-$TARGET.txt 2> /dev/null
    curl --connect-timeout 5 -s -R -L https://$TARGET > $LOOT_DIR/web/websource-https-$TARGET.txt 2> /dev/null
    if [ "$WEBTECH" = "1" ]; then
      echo -e "${OKGREEN}=======================================${RESET}"
      echo -e "$OKRED GATHERING WEB FINGERPRINT $RESET"
      echo -e "${OKGREEN}=======================================${RESET}"
      webtech -u https://$TARGET | grep \- | cut -d- -f2- | tee $LOOT_DIR/web/webtech-$TARGET-https.txt
    fi
    echo -e "${OKGREEN}=======================================${RESET}"
    echo -e "$OKRED DISPLAYING META GENERATOR TAGS $RESET"
    echo -e "${OKGREEN}=======================================${RESET}"
    cat $LOOT_DIR/web/websource-https-$TARGET.txt 2> /dev/null | grep generator | cut -d\" -f4 2> /dev/null | tee $LOOT_DIR/web/webgenerator-https-$TARGET.txt 2> /dev/null
    echo -e "${OKGREEN}=======================================${RESET}"
    echo -e "$OKRED DISPLAYING COMMENTS $RESET"
    echo -e "${OKGREEN}=======================================${RESET}"
    cat $LOOT_DIR/web/websource-https-$TARGET.txt 2> /dev/null | grep "<\!\-\-" 2> /dev/null | tee $LOOT_DIR/web/webcomments-https-$TARGET 2> /dev/null
    sed -r "s/</\&lh\;/g" $LOOT_DIR/web/webcomments-https-$TARGET 2> /dev/null > $LOOT_DIR/web/webcomments-https-$TARGET.txt 2> /dev/null
    rm -f $LOOT_DIR/web/webcomments-https-$TARGET 2> /dev/null
    echo -e "${OKGREEN}=======================================${RESET}"
    echo -e "$OKRED DISPLAYING SITE LINKS $RESET"
    echo -e "${OKGREEN}=======================================${RESET}"
    cat $LOOT_DIR/web/websource-https-$TARGET.txt 2> /dev/null | egrep "\"" | cut -d\" -f2 | grep  \/ | sort -u 2> /dev/null | tee $LOOT_DIR/web/weblinks-https-$TARGET.txt 2> /dev/null
    if [ "$PASSIVE_SPIDER" = "1" ]; then
      echo -e "${OKGREEN}=======================================${RESET}"
      echo -e "$OKRED RUNNING PASSIVE WEB SPIDER $RESET"
      echo -e "${OKGREEN}=======================================${RESET}"
      if [ "$VERBOSE" == "1" ]; then
        echo -e "$OKBLUE[$RESET${OKRED}i${RESET}$OKBLUE]$OKGREEN curl -sX GET "http://index.commoncrawl.org/CC-MAIN-2018-22-index?url=*.$TARGET&output=json" | jq -r .url | tee $LOOT_DIR/web/spider-$TARGET.txt 2> /dev/null$RESET"
      fi
      curl -sX GET "http://index.commoncrawl.org/CC-MAIN-2018-22-index?url=*.$TARGET&output=json" | jq -r .url | tee $LOOT_DIR/web/spider-$TARGET.txt 2> /dev/null
    fi

    if [ "$BLACKWIDOW" == "1" ]; then
      echo -e "${OKGREEN}=======================================${RESET}"
      echo -e "$OKRED RUNNING ACTIVE WEB SPIDER $RESET"
      echo -e "${OKGREEN}=======================================${RESET}"
      if [ "$VERBOSE" == "1" ]; then
        echo -e "$OKBLUE[$RESET${OKRED}i${RESET}$OKBLUE]$OKGREEN blackwidow -u https://$TARGET:443 -l 3$RESET"
      fi
      blackwidow -u https://$TARGET:443 -l 2 -v n
      cat /usr/share/blackwidow/$TARGET*/* >> $LOOT_DIR/web/spider-$TARGET.txt 2>/dev/null
    fi
    if [ $WEB_BRUTE_STEALTHSCAN == "1" ]; then
      echo -e "${OKGREEN}=======================================${RESET}"
      echo -e "$OKRED RUNNING FILE/DIRECTORY BRUTE FORCE $RESET"
      echo -e "${OKGREEN}=======================================${RESET}"
      if [ "$VERBOSE" == "1" ]; then
        echo -e "$OKBLUE[$RESET${OKRED}i${RESET}$OKBLUE]$OKGREEN python3 $PLUGINS_DIR/dirsearch/dirsearch.py -u https://$TARGET -w $WEB_BRUTE_STEALTH -x 400,403,404,405,406,429,502,503,504 -F -e php,asp,aspx,bak,zip,tar.gz,html,htm $RESET"
      fi
      python3 $PLUGINS_DIR/dirsearch/dirsearch.py -u https://$TARGET -w $WEB_BRUTE_STEALTH -x 400,403,404,405,406,429,502,503,504 -F -e php,asp,aspx,bak,zip,tar.gz,html,htm 
      cat $PLUGINS_DIR/dirsearch/reports/$TARGET/* 2> /dev/null
      cat $PLUGINS_DIR/dirsearch/reports/$TARGET/* > $LOOT_DIR/web/dirsearch-$TARGET.txt 2> /dev/null
      if [ "$VERBOSE" == "1" ]; then
        echo -e "$OKBLUE[$RESET${OKRED}i${RESET}$OKBLUE]$OKGREEN wget https://$TARGET/robots.txt -O $LOOT_DIR/web/robots-$TARGET-https.txt 2> /dev/null$RESET"
      fi
      wget https://$TARGET/robots.txt -O $LOOT_DIR/web/robots-$TARGET-https.txt 2> /dev/null
    fi
    if [ "$SSL" = "1" ]; then
      echo -e "${OKGREEN}=======================================${RESET}"
      echo -e "$OKRED GATHERING SSL/TLS INFO $RESET"
      echo -e "${OKGREEN}=======================================${RESET}"
      if [ "$VERBOSE" == "1" ]; then
        echo -e "$OKBLUE[$RESET${OKRED}i${RESET}$OKBLUE]$OKGREEN sslscan --no-failed $TARGET | tee $LOOT_DIR/web/sslscan-$TARGET.raw 2> /dev/null$RESET"
      fi
      sslscan --no-failed $TARGET | tee $LOOT_DIR/web/sslscan-$TARGET.raw 2> /dev/null
      sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" $LOOT_DIR/web/sslscan-$TARGET.raw > $LOOT_DIR/web/sslscan-$TARGET.txt 2> /dev/null
      rm -f $LOOT_DIR/web/sslscan-$TARGET.raw 2> /dev/null
    fi
    echo -e "${OKGREEN}=======================================${RESET}"
    echo -e "$OKRED SAVING SCREENSHOTS $RESET"
    echo -e "${OKGREEN}=======================================${RESET}"
    if [ ${DISTRO} == "blackarch"  ]; then
      /bin/CutyCapt --url=https://$TARGET --out=$LOOT_DIR/screenshots/$TARGET-port443.jpg --insecure --max-wait=5000 2> /dev/null
    else
      if [ "$VERBOSE" == "1" ]; then
        echo -e "$OKBLUE[$RESET${OKRED}i${RESET}$OKBLUE]$OKGREEN cutycapt --url=https://$TARGET --out=$LOOT_DIR/screenshots/$TARGET-port443.jpg --insecure --max-wait=5000 2> /dev/null$RESET"
      fi
      cutycapt --url=https://$TARGET --out=$LOOT_DIR/screenshots/$TARGET-port443.jpg --insecure --max-wait=5000 2> /dev/null
    fi
    echo -e "$OKRED[+]$RESET Screenshot saved to $LOOT_DIR/screenshots/$TARGET-port443.jpg"
  fi
  echo -e "${OKGREEN}=======================================${RESET}"
  echo -e "$OKRED SCAN COMPLETE! $RESET"
  echo -e "${OKGREEN}=======================================${RESET}"
  echo -e ""
  echo -e ""
  echo -e ""
  echo "$TARGET" >> $LOOT_DIR/scans/updated.txt
  rm -f $INSTALL_DIR/.fuse_* 2> /dev/null
  sort -u $LOOT_DIR/ips/ips-all-unsorted.txt 2> /dev/null > $LOOT_DIR/ips/ips-all-sorted.txt 2> /dev/null
  if [ "$LOOT" = "1" ]; then
    loot
  fi
  exit
fi