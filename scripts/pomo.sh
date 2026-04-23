#!/bin/sh
# pomo.sh start [work_minutes] [break_minutes]   — run in background
# pomo.sh -d [work_minutes] [break_minutes]      — run in foreground (debug)
# pomo.sh stop                                   — kill background instance
# pomo.sh status                                 — print current state (for tmux)
# defaults: 25/5

STATE="/tmp/.pomo_state"
PIDFILE="/tmp/.pomo_pid"

case "$1" in
    stop)
        if [ -f "$PIDFILE" ]; then
            kill "$(cat "$PIDFILE")" 2>/dev/null
            rm -f "$PIDFILE" "$STATE"
            echo "stopped"
        else
            echo "not running"
        fi
        exit 0
        ;;
    status)
        [ -f "$STATE" ] && cat "$STATE" || echo "off"
        exit 0
        ;;
    -d)
        DAEMON=0
        shift
        ;;
    start)
        DAEMON=1
        shift
        ;;
    *)
        echo "usage: pomo.sh start|stop|status|-d [work_min] [break_min]"
        exit 1
        ;;
esac

WORK=${1:-25}
BREAK=${2:-5}

run() {
    n=1
    while true; do
        # work
        total=$((WORK * 60))
        i=0
        while [ $i -lt $total ]; do
            remaining=$((total - i))
            state=$(printf "🖥 %02d:%02d" $((remaining / 60)) $((remaining % 60)))
            echo "$state" > "$STATE"
            [ "$DAEMON" -eq 0 ] && printf "\r%s  " "$state"
            sleep 1
            i=$((i + 1))
        done
        notify-send "Pomodoro" "🖥 Work $n done — take a break"
        [ "$DAEMON" -eq 0 ] && printf "\r🖥 Work $n done!        \n"

        # break
        total=$((BREAK * 60))
        i=0
        while [ $i -lt $total ]; do
            remaining=$((total - i))
            state=$(printf "☕ %02d:%02d" $((remaining / 60)) $((remaining % 60)))
            echo "$state" > "$STATE"
            [ "$DAEMON" -eq 0 ] && printf "\r%s  " "$state"
            sleep 1
            i=$((i + 1))
        done
        notify-send "Pomodoro" "☕ Break $n done — back to work"
        [ "$DAEMON" -eq 0 ] && printf "\r☕ Break $n done!        \n"

        n=$((n + 1))
    done
}

if [ "$DAEMON" -eq 1 ]; then
    run &
    echo $! > "$PIDFILE"
    echo "pomo started (pid $(cat "$PIDFILE"))"
else
    run
fi
