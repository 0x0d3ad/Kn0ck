# DISCOVER MODE #
if [ "$MODE" = "discover" ]; then
  if [ "$REPORT" = "1" ]; then
    if [ ! -z "$WORKSPACE" ]; then
      args="$args -w $WORKSPACE"
      LOOT_DIR=$INSTALL_DIR/loot/workspace/$WORKSPACE
      echo -e "$OKBLUE[*] Saving loot to $LOOT_DIR [$RESET${OKGREEN}OK${RESET}$OKBLUE]$RESET"
      mkdir -p $LOOT_DIR 2> /dev/null
      mkdir $LOOT_DIR/ips 2> /dev/null
      mkdir $LOOT_DIR/screenshots 2> /dev/null
      mkdir $LOOT_DIR/nmap 2> /dev/null
      mkdir $LOOT_DIR/reports 2> /dev/null
      mkdir $LOOT_DIR/output 2> /dev/null
      mkdir $LOOT_DIR/scans 2> /dev/null
    fi
    OUT_FILE=$(echo "$TARGET" | tr / -)
    echo "knock -t $TARGET -m $MODE --noreport $args" >> $LOOT_DIR/scans/$OUTFILE-$MODE.txt 2> /dev/null
    knock -t $TARGET -m $MODE --noreport $args | tee $LOOT_DIR/output/knock-$MODE-`date +%Y%m%d%H%M`.txt 2>&1
    exit
  fi
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
  echo ""
  OUT_FILE=$(echo "$TARGET" | tr / -)
  echo -e "${OKGREEN}=======================================${RESET}"
  echo -e "$OKRED RUNNING PING DISCOVERY SCAN $RESET"
  echo -e "${OKGREEN}=======================================${RESET}"
  nmap -sP $TARGET | tee $LOOT_DIR/ips/knock-$OUT_FILE-ping.txt
  cat $LOOT_DIR/ips/knock-$OUT_FILE-ping.txt 2> /dev/null | grep "scan report" | awk '{print $5}' > $LOOT_DIR/ips/knock-$OUT_FILE-ping-sorted.txt
  echo -e "${OKGREEN}=======================================${RESET}"
  echo -e "$OKRED RUNNING TCP PORT SCAN $RESET"
  echo -e "${OKGREEN}=======================================${RESET}"
  #nmap -T4 -v -sC -sA -sV -F $TARGET 2>/dev/null | tee $LOOT_DIR/ips/knock-$OUT_FILE-tcp.txt 2>/dev/null 
  nmap -T4 -v -p $QUICK_PORTS -sS $TARGET 2> /dev/null | tee $LOOT_DIR/ips/knock-$OUT_FILE-tcp.txt 2>/dev/null 
  cat $LOOT_DIR/ips/knock-$OUT_FILE-tcp.txt | grep open | grep on | awk '{print $6}' > $LOOT_DIR/ips/knock-$OUT_FILE-tcpips.txt
  echo -e "${OKGREEN}=======================================${RESET}"
  echo -e "$OKRED CURRENT TARGETS $RESET"
  echo -e "${OKGREEN}=======================================${RESET}"
  cat $LOOT_DIR/ips/knock-$OUT_FILE-ping-sorted.txt $LOOT_DIR/ips/knock-$OUT_FILE-tcpips.txt 2> /dev/null > $LOOT_DIR/ips/knock-$OUT_FILE-ips-unsorted.txt
  sort -u $LOOT_DIR/ips/knock-$OUT_FILE-ips-unsorted.txt > $LOOT_DIR/ips/discover-$OUT_FILE-sorted.txt
  cat $LOOT_DIR/ips/discover-$OUT_FILE-sorted.txt
  echo ""
  echo -e "$OKRED[+]$RESET Target list saved to $LOOT_DIR/ips/discover-$OUT_FILE-sorted.txt "
  echo -e "$OKRED[i] To scan all IP's, use knock -f $LOOT_DIR/ips/discover-$OUT_FILE-sorted.txt -m flyover -w $WORKSPACE $RESET"
  echo -e "${OKGREEN}=======================================${RESET}"
  echo -e "$OKRED SCAN COMPLETE! $RESET"
  echo -e "${OKGREEN}=======================================${RESET}"
  #loot
  knock -f $LOOT_DIR/ips/discover-$OUT_FILE-sorted.txt -m flyover -w $WORKSPACE
  exit
fi