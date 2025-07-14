#!/bin/sh

resetprop -n external_storage.projid.enabled ""
resetprop -n external_storage.casefold.enabled ""
resetprop -n external_storage.sdcardfs.enabled ""

resetprop --delete external_storage.projid.enabled
resetprop --delete external_storage.casefold.enabled
resetprop --delete external_storage.sdcardfs.enabled

is_screen_on() {
    brightness=$(cat /sys/class/backlight/*/brightness)
    [ "$brightness" -gt 0 ]
}

screentouchfix() {
    echo check_connection > /sys/class/sec/tsp/cmd && cat /sys/class/sec/tsp/cmd_result
}

previous_screen_state=1

monitor_events() {
    getevent | while read event2
    do
        if [[ "$event2" == *"/dev/input/event2: 0001 0074 00000000"* ]]; then
            if is_screen_on; then
                current_screen_state=0
            else
                current_screen_state=1
            fi

            if [ "$previous_screen_state" -eq 1 ] && [ "$current_screen_state" -eq 0 ]; then
                screentouchfix
            fi
            
            previous_screen_state=$current_screen_state
        fi
    done
}

if is_screen_on; then
    previous_screen_state=0
else
    previous_screen_state=1
fi

export TERM="screen"

if [ -f /sbin/from_fox_sd.sh ]; then
   source /sbin/from_fox_sd.sh >/dev/null 2>&1
fi
if [ -f /system/bin/termux-sync.sh ]; then
   source /system/bin/termux-sync.sh >/dev/null 2>&1
fi
if [ -f /system/etc/bash.bashrc ]; then
   source /system/etc/bash.bashrc >/dev/null 2>&1
fi

monitor_events &
