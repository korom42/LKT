UNSELECTED_MODE=-1
PROFILE_MODE=$UNSELECTED_MODE

$ZIP_FILE = $(basename $ZIP)
case $ZIP_FILE in
  *Battery*|*BATTERY*|*battery*)
    PROFILE_MODE=0
    ;;
  *BALANC*|*Balanc*|*balanc*)
    PROFILE_MODE=1
    ;;
esac

# Keycheck binary by someone755 @Github, idea for code below by Zappo @xda-developers
chmod 755 $INSTALLER/common/keycheck

keytest() {
  ui_print "** Volume button Test **"
  ui_print " "
  ui_print "   Press Vol UP"
  (/system/bin/getevent -lc 1 2>&1 | /system/bin/grep VOLUME | /system/bin/grep " DOWN" > $INSTALLER/events) || return 1
  return 0
}

chooseport() {
  #note from chainfire @xda-developers: getevent behaves weird when piped, and busybox grep likes that even less than toolbox/toybox grep
  while (true); do
    /system/bin/getevent -lc 1 2>&1 | /system/bin/grep VOLUME | /system/bin/grep " DOWN" > $INSTALLER/events
    if (`cat $INSTALLER/events 2>/dev/null | /system/bin/grep VOLUME >/dev/null`); then
      break
    fi
  done
  if (`cat $INSTALLER/events 2>/dev/null | /system/bin/grep VOLUMEUP >/dev/null`); then
    return 0
  else
    return 1
  fi
}

chooseportold() {
  # Calling it first time detects previous input. Calling it second time will do what we want
  $INSTALLER/common/keycheck
  $INSTALLER/common/keycheck
  SEL=$?
  if [ "$1" == "UP" ]; then
    UP=$SEL
  elif [ "$1" == "DOWN" ]; then
    DOWN=$SEL
  elif [ $SEL -eq $UP ]; then
    return 0
  elif [ $SEL -eq $DOWN ]; then
    return 1
  else
    ui_print "   Volume button is not detected !"
    ui_print " "
    abort "   Use rename method in TWRP"
  fi
}

if [ $PROFILE_MODE == $UNSELECTED_MODE ]; then
  if keytest; then
    FUNCTION=chooseport
  else
    FUNCTION=chooseportold
    ui_print "   ! Legacy device detected! Using old keycheck method"
    ui_print " "
    ui_print "** Volume button programming **"
    ui_print " "
    ui_print "   Press Vol UP again :"
    $FUNCTION "UP"
    ui_print "   Press Vol Down"
    $FUNCTION "DOWN"
  fi
  
  ui_print "** Please choose tweaks mode **"
  ui_print " "
  ui_print "   Vol+ = Balanced"
  ui_print "   Vol- = Battery"
  ui_print " "

  if $FUNCTION; then
    PROFILE_MODE=1
    ui_print "   Balanced profile selected."
    ui_print " "

  else
    PROFILE_MODE=0
    ui_print "   Battery profile selected."
    ui_print " "
  fi
else
  ui_print "Profile mode specified in zip filename : $ZIP_FILE"
  ui_print " "

fi

sed -i "s/<PROFILE_MODE>/$PROFILE_MODE/g" $INSTALLER/common/service.sh
