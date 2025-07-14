#!/bin/bash

# Minimal /system/etc/bashrc for Android using busybox or shell X
set +o nohup
clear
cat /system/etc/logo
echo '
         Welcome, Enjoy this Recovery.
                     ;D
'

# Default HOSTNAME if not provided by system
: ${HOSTNAME:=$(getprop ro.product.device)}
: ${HOSTNAME:=android}
export HOSTNAME

# HOME
export HOME=/sdcard/Fox
[ ! -d "$HOME" ] && mkdir -p "$HOME"
[ ! -d "$HOME" ] && export HOME=/sdcard

# shell
export HISTFILE=$HOME/.bash_history
export PS1='\s-\v \w > '

# Default TMPDIR
: ${TMPDIR:=/tmp}
export TMPDIR

InitRecovery() {
    export TERM="screen"
    alias dir="ls -all --color=auto"
    alias la='ls -a'
    alias ll='ls -a -l'
    alias lo='ls -a -l'
    alias l='find "$@" -maxdepth 1 -exec ls --color=auto -lh {} +'
    alias grep='grep -n --color=auto'
    alias fgrep='fgrep -n --color=auto'
    alias egrep='egrep -n --color=auto'
    alias python=python3
    alias python3=python_cli
    alias nano='nano "$@"'
    alias cls="clear"
    alias seek='find . -type d -path ./proc -prune -o -name "$@"'
    alias dirp="ls -all --color=auto -t | more"
    alias dirt="ls -all --color=auto -t"
    alias dirs="ls -all --color=auto -S"
    alias rd="rmdir"
    alias md="mkdir"
    alias del="rm -i"
    alias ren="mv -i"
    alias copy="cp -i"
    alias q="exit"
    alias diskfree="df -Ph"
    alias path="echo $PATH"
    alias mem="cat /proc/meminfo && free"
    alias ver="cat /proc/version"
    alias makediff="diff -u -d -w -B"
    alias makediff_recurse="diff -U3 -d -w -rN"

    if [ -f /sdcard/Fox/fox.bashrc ]; then
       . /sdcard/Fox/fox.bashrc
    elif [ -f $HOME/.bashrc ]; then
       . $HOME/.bashrc
    elif [ -f /sdcard/.bashrc ]; then
       . /sdcard/.bashrc
    elif [ -f /FFiles/.bashrc ]; then
       . /FFiles/.bashrc
    elif [ -f /data/recovery/.bashrc ]; then
       . /data/recovery/.bashrc
    elif [ -f /sdcard1/.bashrc ]; then
       . /sdcard1/.bashrc
    fi
    
    [ -z "$HOME" ] && export HOME=/sdcard
    [ -z "$TERM" ] && export TERM=pcansi
    [ -z "$SHELL" ] && export SHELL=/sbin/bash
    [ -z "$IS_ORANGEFOX_USER_TERM" ] && export IS_ORANGEFOX_USER_TERM=true
    
    red=$'\x1b[01;31m'
    green=$'\x1b[01;32m'
    blue=$'\x1b[01;34m'
    purple='\033[35m'
    NC=$'\x1b[0m'
    
    if [ "$(id -u)" -eq 0 ]; then
        PS1='#'
    else
        PS1='$'
    fi
    
    export PS4='[$(date +%s.%N)]'

    e=$?
    new_ps1=''
    [ $e -ne 0 ] && new_ps1="${red}${e}${NC}|"

    new_ps1+="${green}[ ${HOSTNAME} | $(whoami) ]${NC} : ${blue}\${PWD}${NC}"
    if [ -n "$VIRTUAL_ENV" ]; then
        new_ps1+="${purple} (venv:$(basename $VIRTUAL_ENV))${NC}"
    fi

    new_ps1+=" 
$PS1> "
    PS1="$new_ps1"
    return $e
}

InitRecovery

if [ -f /sbin/from_fox_sd.sh ]; then
   source /sbin/from_fox_sd.sh >/dev/null 2>&1 || echo "Failed to source /sbin/from_fox_sd.sh"
fi

tmux() {
echo "Do you want to synchronize the use of temrux binaries in recovery (Y/N) ?"
read -rsn1 answer
if [ "$answer"="Y" ]; then
    if [ -f /system/bin/termux-sync.sh ]; then
       source /system/bin/termux-sync.sh >/dev/null 2>&1 || echo "Failed to source /system/bin/termux-sync.sh"
    fi
fi
}

export TERM=pcansi