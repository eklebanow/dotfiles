##feh -bg-max /home/eklebanow/1490216094496.jpg &
xbindkeys &

#path to qutebrowser
#export PATH=$PATH:/home/eklebanow/qutebrowser
/usr/bin/dwmstatusbar &
#export PATH=$PATH:~/dmengle

xmodmap xmodmap.conf

export XDG_RUNTIME_DIR = /var/run/user/1000

#wal -R &
#automatically start the GPG agent
##if [ -x /usr/bin/gpg-agent ]; then
## eval "$(/usr/bin/gpg-agent --daemon)"
##fi

#automatically shut down the gpg agent
##if [ -n "${GPG_AGENT_INFO}" ]; then
##  kill $(echo ${GPG_AGENT_INFO} | cut -d':' -f 2) >/dev/null 2>&1
##fi
exec dwm
