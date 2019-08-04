if [ "$RECON" = "1" ]; then
  echo -e "${OKGREEN}=======================================${RESET}"
  echo -e "$OKRED GATHERING DNS SUBDOMAINS VIA SUBLIST3R $RESET"
  echo -e "${OKGREEN}=======================================${RESET}"
  if [ "$SUBLIST3R" = "1" ]; then
    python $PLUGINS_DIR/Sublist3r/sublist3r.py -d $TARGET -vvv -o $LOOT_DIR/domains/domains-$TARGET.txt 2>/dev/null
    cat $LOOT_DIR/domains/domains-$TARGET.txt | httprobe | tee $LOOT_DIR/domains/hosts-$TARGET.txt
  fi
  
  if [ "$AMASS" = "1" ]; then
    echo -e "${OKGREEN}=======================================${RESET}"
    echo -e "$OKRED GATHERING DNS SUBDOMAINS VIA AMASS $RESET"
    echo -e "${OKGREEN}=======================================${RESET}"
    amass -ip -brute -active -o $LOOT_DIR/domains/domains-$TARGET-amass.txt -min-for-recursive 3 -d $TARGET 2>/dev/null
    cut -d, -f1 $LOOT_DIR/domains/domains-$TARGET-amass.txt 2>/dev/null | grep $TARGET > $LOOT_DIR/domains/domains-$TARGET-amass-sorted.txt
    cut -d, -f2 $LOOT_DIR/domains/domains-$TARGET-amass.txt 2>/dev/null > $LOOT_DIR/domains/domains-$TARGET-amass-ips-sorted.txt
  fi

  if [ "$SUBFINDER" = "1" ]; then
    echo -e "${OKGREEN}=======================================${RESET}"
    echo -e "$OKRED GATHERING DNS SUBDOMAINS VIA SUBFINDER (THIS COULD TAKE A WHILE...) $RESET"
    echo -e "${OKGREEN}=======================================${RESET}"
    subfinder -o $LOOT_DIR/domains/domains-$TARGET-subfinder.txt -b -d $TARGET -w $DOMAINS_DEFAULT -t 100 2>/dev/null
  fi
  echo -e "${OKGREEN}=======================================${RESET}"
  echo -e "$OKRED BRUTE FORCING DNS SUBDOMAINS VIA DNSCAN (THIS COULD TAKE A WHILE...) $RESET"
  echo -e "${OKGREEN}=======================================${RESET}"
  if [ "$DNSCAN" = "1" ]; then
    python $PLUGINS_DIR/dnscan/dnscan.py -d $TARGET -w $DOMAINS_QUICK -o $LOOT_DIR/domains/domains-dnscan-$TARGET.txt -i $LOOT_DIR/domains/domains-ips-$TARGET.txt
    cat $LOOT_DIR/domains/domains-dnscan-$TARGET.txt 2>/dev/null | grep $TARGET| awk '{print $3}' | sort -u >> $LOOT_DIR/domains/domains-$TARGET.txt 2> /dev/null
    dos2unix $LOOT_DIR/domains/domains-$TARGET.txt 2>/dev/null
  fi
  echo ""
  if [ "$CRTSH" = "1" ]; then
    echo -e "${OKGREEN}=======================================${RESET}"
    echo -e "$OKRED GATHERING CERTIFICATE SUBDOMAINS $RESET"
    echo -e "${OKGREEN}=======================================${RESET}"
    echo -e "$OKBLUE"
    curl -s https://crt.sh/?q=%25.$TARGET > /tmp/curl.out && cat /tmp/curl.out | grep $TARGET | grep TD | sed -e 's/<//g' | sed -e 's/>//g' | sed -e 's/TD//g' | sed -e 's/\///g' | sed -e 's/ //g' | sed -n '1!p' | sort -u > $LOOT_DIR/domains/domains-$TARGET-crt.txt && cat $LOOT_DIR/domains/domains-$TARGET-crt.txt
    echo ""
    echo -e "${OKRED}[+] Domains saved to: $LOOT_DIR/domains/domains-$TARGET-full.txt"
  fi

  if [ "$CENSYS_SUBDOMAINS" = "1" ]; then
    echo -e "${OKGREEN}=======================================${RESET}"
    echo -e "$OKRED GATHERING CENSYS SUBDOMAINS $RESET"
    echo -e "${OKGREEN}=======================================${RESET}"
    python $PLUGINS_DIR/censys-subdomain-finder/censys_subdomain_finder.py --censys-api-id $CENSYS_APP_ID --censys-api-secret $CENSYS_API_SECRET $TARGET | egrep "\-" | awk '{print $2}' | tee $LOOT_DIR/domains/domains-$TARGET-censys.txt 2> /dev/null 
  fi

  if [ "$PROJECT_SONAR" = "1" ]; then
    echo -e "${OKGREEN}=======================================${RESET}"
    echo -e "$OKRED GATHERING PROJECT SONAR SUBDOMAINS $RESET"
    echo -e "${OKGREEN}=======================================${RESET}"
    curl -fsSL "https://dns.bufferover.run/dns?q=.$TARGET" | sed 's/\"//g' | cut -f2 -d "," |sort -u | grep $TARGET | tee $LOOT_DIR/domains/domains-$TARGET-projectsonar.txt 2> /dev/null 
  fi
  cat $LOOT_DIR/domains/domains-$TARGET-crt.txt 2> /dev/null > /tmp/curl.out 2> /dev/null
  cat $LOOT_DIR/domains/domains-$TARGET.txt 2> /dev/null >> /tmp/curl.out 2> /dev/null
  cat $LOOT_DIR/domains/domains-$TARGET-amass-sorted.txt 2> /dev/null >> /tmp/curl.out 2> /dev/null
  cat $LOOT_DIR/domains/domains-$TARGET-subfinder.txt 2> /dev/null >> /tmp/curl.out 2> /dev/null
  cat $LOOT_DIR/domains/domains-$TARGET-projectsonar.txt 2> /dev/null >> /tmp/curl.out 2> /dev/null
  cat $LOOT_DIR/domains/domains-$TARGET-censys.txt 2> /dev/null >> /tmp/curl.out 2> /dev/null
  cat $LOOT_DIR/domains/targets.txt 2> /dev/null >> /tmp/curl.out 2> /dev/null
  sort -u /tmp/curl.out 2> /dev/null > $LOOT_DIR/domains/domains-$TARGET-full.txt
  rm -f /tmp/curl.out 2> /dev/null
  echo -e "$RESET"
  if [ "$SPOOF_CHECK" = "1" ]; then
    echo -e "${OKGREEN}=======================================${RESET}"
    echo -e "$OKRED CHECKING FOR EMAIL SECURITY $RESET"
    echo -e "${OKGREEN}=======================================${RESET}"
    python $PLUGINS_DIR/spoofcheck/spoofcheck.py $TARGET | tee $LOOT_DIR/nmap/email-$TARGET.txt 2>/dev/null
    echo ""
  fi

  if [ "$SUBHIJACK_CHECK" = "1" ]; then
    echo -e "${OKGREEN}=======================================${RESET}"
    echo -e "$OKRED CHECKING FOR SUBDOMAIN HIJACKING $RESET"
    echo -e "${OKGREEN}=======================================${RESET}"
    dig $TARGET CNAME | egrep -i "wordpress|instapage|heroku|github|bitbucket|squarespace|fastly|feed|fresh|ghost|helpscout|helpjuice|instapage|pingdom|surveygizmo|teamwork|tictail|shopify|desk|teamwork|unbounce|helpjuice|helpscout|pingdom|tictail|campaign|monitor|cargocollective|statuspage|tumblr|amazon|hubspot|cloudfront|modulus|unbounce|uservoice|wpengine|cloudapp" | tee $LOOT_DIR/nmap/takeovers-$TARGET.txt 2>/dev/null
    for a in `cat $LOOT_DIR/domains/domains-$TARGET-full.txt`; do dig $a CNAME | egrep -i "wordpress|instapage|heroku|github|bitbucket|squarespace|fastly|feed|fresh|ghost|helpscout|helpjuice|instapage|pingdom|surveygizmo|teamwork|tictail|shopify|desk|teamwork|unbounce|helpjuice|helpscout|pingdom|tictail|campaign|monitor|cargocollective|statuspage|tumblr|amazon|hubspot|cloudfront|modulus|unbounce|uservoice|wpengine|cloudapp" | tee $LOOT_DIR/nmap/takeovers-$a.txt 2>/dev/null; done;
  fi

  if [ "$SUBOVER" = "1" ]; then
    subover -l $LOOT_DIR/domains/domains-$TARGET-full.txt | tee $LOOT_DIR/nmap/subover-$TARGET 2>/dev/null
    sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" $LOOT_DIR/nmap/subover-$TARGET > $LOOT_DIR/nmap/subover-$TARGET.txt 2> /dev/null
    rm -f $LOOT_DIR/nmap/takeovers-$TARGET-subover 2> /dev/null
    cd $INSTALL_DIR
  fi

  if [ "$SLURP" = "1" ]; then
    echo -e "${OKGREEN}=======================================${RESET}"
    echo -e "$OKRED STARTING PUBLIC S3 BUCKET SCAN $RESET"
    echo -e "${OKGREEN}=======================================${RESET}"
    cd $PLUGINS_DIR/slurp/
    ./slurp-linux-amd64 domain --domain $TARGET | tee $LOOT_DIR/nmap/takeovers-$TARGET-s3-buckets.txt 2>/dev/null
  fi
fi