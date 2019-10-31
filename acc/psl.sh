# Advanced Charging Controller Power Supply Logger
# Copyright (c) 2019, VR25 @ xda-developers
# License: GPLv3+

gather_ps_data() {
  local target="" target2=""
  for target in $(ls -1 $1 | grep -Ev '^[0-9]|^block$|^dev$|^fs$|^ram$'); do
    if [ -f $1/$target ]; then
      if echo $1/$target | grep -Ev 'logg|(/|_|-)log' | grep -Eq 'batt|charg|power_supply'; then
        echo $1/$target
        sed 's/^/  /' $1/$target 2>/dev/null
        echo
      fi
    elif [ -d $1/$target ]; then
      for target2 in $(find $1/$target \( \( -type f -o -type d \) \
        -a \( -ipath '*batt*' -o -ipath '*charg*' -o -ipath '*power_supply*' \) \) \
        -print 2>/dev/null | grep -Ev 'logg|(/|_|-)log')
      do
        if [ -f $target2 ]; then
          echo $target2
          sed 's/^/  /' $target2 2>/dev/null
          echo
        fi
      done
    fi
  done
}

umask 077
log=/sbin/.acc/acc-power_supply-$(getprop ro.product.device | grep .. || getprop ro.build.product).log

{
  date
  echo versionCode=$1
  echo
  echo
  getprop | grep product
  echo
  getprop | grep version
  echo
  echo
  gather_ps_data /sys
  echo
  gather_ps_data /proc
} > $log

exit 0
