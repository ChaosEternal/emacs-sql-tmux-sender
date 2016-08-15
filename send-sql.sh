#!/bin/bash
GPCONNECT=~/gpenv.sh


tmux set-window-option mouse-select-pane on
PANEID=`tmux list-pane -F '#{pane_index}:#{?pane_dead,dead,running}'|grep dead|cut -d : -f 1|head -1`
if [ -n "$PANEID" ] 
then
    true
else
    tmux splitw -d -h "true" \; set-option remain-on-exit yes
    sleep 0.001
    PANEID=`tmux list-pane -F '#{pane_index}:#{?pane_dead,dead,running}'|grep dead|cut -d : -f 1|head -1`
fi

WINDOWID=`tmux list-window -F '#{window_id} #{window_active}'|sed -n '/ 1$/ {s/[@ ]/_/gp;}'`
LASTCMD=/tmp/lastsqlcmd-${WINDOWID}_${PANEID}.sql
case "$1" in
    reset|RESET)
	echo "set application_name to 'send-sql';" > $LASTCMD
	cat >> $LASTCMD
	echo >> $LASTCMD
	;;
    explain)
	echo "explain" >>  $LASTCMD
	cat >> $LASTCMD
	tmux respawn-pane -t $PANEID ". $GPCONNECT; psql -f $LASTCMD 2>&1 |`dirname $0`/hlplan.sh "
	;;
    analyze)
	echo "explain analyze" >> $LASTCMD
	cat >> $LASTCMD
	tmux respawn-pane -t $PANEID ". $GPCONNECT; psql -f $LASTCMD 2>&1 |`dirname $0`/hlplan.sh "
	;;

    *)
	cat >> $LASTCMD

	if [ -n "$PANEID" ] 
	then
	    tmux respawn-pane -t $PANEID ". $GPCONNECT; psql -f $LASTCMD 2>&1 |(head -c 40000;echo -e \\\n\\\n ......;tail -n 3) "
	else
	    tmux splitw -d -h ". $GPCONNECT; psql -f $LASTCMD 2>&1|(head -c 40000;echo -e \\\n\\\n ......;tail -n 3) " \; set-option remain-on-exit yes
	fi
esac
      
