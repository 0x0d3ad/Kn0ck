# WEB MODE #
if [ "$MODE" = "web" ]; then
  if [ "$REPORT" = "1" ]; then
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
    echo "knock -t $TARGET -m $MODE --noreport $args" >> $LOOT_DIR/scans/$TARGET-$MODE.txt
    knock -t $TARGET -m $MODE --noreport $args | tee $LOOT_DIR/output/knock-$TARGET-$MODE-`date +%Y%m%d%H%M`.txt 2>&1
    exit
  fi
fi