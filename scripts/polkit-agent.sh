#!/usr/bin/env bash
# Start the polkit authentication agent from whichever path the
# distribution provides. Arch ships polkit-gnome under /usr/lib/polkit-gnome,
# Gentoo under /usr/libexec; Debian dropped polkit-gnome and uses mate-polkit.
for _agent in \
    /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 \
    /usr/libexec/polkit-gnome-authentication-agent-1 \
    /usr/libexec/polkit-mate-authentication-agent-1
do
    if [ -x "${_agent}" ]; then
        exec "${_agent}"
    fi
done
exit 1
