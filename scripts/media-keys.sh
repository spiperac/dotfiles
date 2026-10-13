#!/bin/sh

case "$(uname -s):$1" in
    Linux:volume-up) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ ;;
    Linux:volume-down) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- ;;
    Linux:mute) wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
    Linux:mic-mute) wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle ;;
    Linux:brightness-up) brightnessctl set +5% ;;
    Linux:brightness-down) brightnessctl set 5%- ;;
    FreeBSD:volume-up) mixer vol=+5% ;;
    FreeBSD:volume-down) mixer vol=-5% ;;
    FreeBSD:mute) mixer vol.mute=toggle ;;
    FreeBSD:brightness-up) backlight incr 5 ;;
    FreeBSD:brightness-down) backlight decr 5 ;;
esac
