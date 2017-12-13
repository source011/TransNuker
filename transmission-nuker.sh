#!/bin/sh

#SCRIPT_PATH="/var/lib/transmission"
TORRENTLIST=`transmission-remote -l | sed -e '1d;$d;s/^ *//' | cut -s -d " " -f1`

# for each torrent in the list
for TORRENTID in $TORRENTLIST 
do
	# Store torrent's name
	NAME=`transmission-remote --torrent $TORRENTID -i | grep "Name:" | cut -s -d ":" -f2`

	# Check seeding time and ratio
	SEEDING=`transmission-remote --torrent $TORRENTID --info | grep "Seeding Time:" | cut -s -d ":" -f2`
	PERIOD=`echo $SEEDING | cut -s -d " " -f2`
	NB_PERIOD=`echo $SEEDING | cut -s -d " " -f1`

	# HemmaHack101
	TORRENTSEC=`transmission-remote --torrent $TORRENTID --info | grep "Seeding Time:" | cut -s -d "(" -f2 | cut -s -d " " -f1`
	TORRENTRATIO=`transmission-remote --torrent $TORRENTID --info | grep 'Ratio:' | cut -s -d ':' -f2 | sed -e 's/^[ \t]*//'`
	LIMITRATIO=1.1
	NAMN="CHANGEME"

	#HemmaHack Ratio INF-koll
	if [ "$TORRENTRATIO" = "Inf" ] ; then
		TORRENTRATIO=0
	fi

	if [ "$TORRENTSEC" = "" ] ; then
		TORRENTSEC=0
	fi

	FIXRATIO=$(echo "($TORRENTRATIO - $LIMITRATIO)^2 > 1.1^2" | bc)

	#If torrent has been seeded for a week or seeded above a ratio of 1.1, remove it !
	if [ "$FIXRATIO" -gt 0 ] < /dev/null > /dev/null 2>&1 ; then
        transmission-remote -t $TORRENTID #--remove-and-delete
        echo $NAME " has been removed! [ SEED RATIO ]"
	python discord/TransNuke_Send.py "$NAMN" "$NAME" "$TORRENTRATIO" "$SEEDING" | > /dev/null
	elif [ "$TORRENTSEC" -gt 259200 ]; then
        transmission-remote -t $TORRENTID #--remove-and-delete
        echo $NAME " has been removed! [ SEED DAYS ]"
	python discord/TransNuke_Send.py "$NAMN" "$NAME" "$TORRENTRATIO" "$SEEDING" | > /dev/null
	fi
done
