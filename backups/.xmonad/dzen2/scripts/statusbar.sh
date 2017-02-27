#!/bin/bash

UPDATE_INTERVAL=5
ICONDIR="$HOME/.xmonad/dzen2/icons"
SEP="^fg(#161616)|"

function printBatt () {
    color="^fg($COLOR6)"
    PERC=`acpi -b | awk -F'[\ %]' '{print $4}'`
    if [ -z $PERC ]; then
        ICON="ac_01.xbm"
        PERC="AC"
    else
        if [ $PERC -ge 75 ]; then
            ICON="bat_6.xbm"
        elif [ $PERC -ge 50 ]; then
            ICON="bat_4.xbm"
        elif [ $PERC -ge 20 ]; then
            ICON="bat_3.xbm"
        else
            ICON="bat_1.xbm"
        fi
    fi

    ICON="^i($ICONDIR/$ICON)"
    echo -n "$color$ICON ^fg()$PERC $SEP "
    return
}

function printAudio () {
    color="^fg($COLOR6)"
    PERC=`amixer get "Master" | grep -m 1 "%" | sed -r "s;.*\[([0-9]*)%\].*;\1;"`

    if [ $PERC -ge 60 ]; then
        ICON="vol_100.xbm"
    elif [ $PERC -gt 0 ]; then
        ICON="vol_50.xbm"
    else
        ICON="vol_0.xbm"
    fi

    ICON="^i($ICONDIR/$ICON)"
    echo -n "$color$ICON ^fg()$PERC $SEP "
    return
}

function printNet () {
    WIRE=`ifconfig eth0 | grep "inet"`
    if [ -z "$WIRE" ]; then 
        PERC=`iwconfig wlan0 | grep "Link Quality" | awk -F'[/=S]' '{print int(100*$2/$3)}'`
        if [ -z "$PERC" ]; then
            color="^fg(#060606)"
            ICON="wifi_100.xbm"
            PERC="0"
        else
            color="^fg($COLOR6)"
            PERC=`echo $PERC | bc`

            if [ $PERC -ge 80 ]; then
                ICON="wifi_100.xbm"
            elif [ $PERC -ge 50 ]; then
                ICON="wifi_60.xbm"
            elif [ $PERC -gt 20 ]; then
                ICON="wifi_20.xbm"
            else
                ICON="wifi_0.xbm"
            fi
        fi
        OUT=$PERC
    else
        color="^fg($COLOR6)"
        ICON="net_wired.xbm"
        OUT="eth0"
    fi
    ICON="^i($ICONDIR/$ICON)"
    echo -n "$color$ICON ^fg()$OUT $SEP "
    return
}

function printDateTime () {
echo -n "^fg($COLOR6)^i($ICONDIR/clock.xbm) ^fg()$(date +%R) $SEP" \
        "^fg($COLOR6)^i($ICONDIR/calendar.xbm) ^fg()$(date +%m/%d) $SEP"
    return
}

function main () {
    while true; do
        source ~/.colors
        printNet
        printAudio
        printBatt
        printDateTime
        echo
        sleep $UPDATE_INTERVAL
    done
    return
}   

main
