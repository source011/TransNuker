#!/bin/sh

#SCRIPT_PATH="/var/lib/transmission"
TORRENTLIST=$(transmission-remote -l | sed -e '1d;$d;s/^ *//' | cut -s -d " " -f1)

# for each torrent in the list
for TORRENTID in $TORRENTLIST
do
        # Store torrent's name
        NAME=$(transmission-remote --torrent "$TORRENTID" -i | grep "Name:" | cut -s -d ":" -f2)

        # Check seeding time and ratio
        SEEDING=$(transmission-remote --torrent "$TORRENTID" --info | grep "Seeding Time:" | cut -s -d ":" -f2)
        PERIOD=`echo "$SEEDING" | cut -s -d " " -f2`
        NB_PERIOD=`echo "$SEEDING" | cut -s -d " " -f1`

        # HemmaHack101
        TORRENTSEC=$(transmission-remote --torrent "$TORRENTID" --info | grep "Seeding Time:" | cut -s -d "(" -f2 | cut -s -d " " -f1)
        TORRENTRATIO=$(transmission-remote --torrent "$TORRENTID" --info | grep 'Ratio:' | cut -s -d ':' -f2 | sed -e 's/^[ \t]*//')
        TORRENTSIZE=$(transmission-remote --torrent "$TORRENTID" --info | grep "Total size" | cut -s -d "(" -f2 | cut -s -d "w" -f1)
        TORRENTUPLOADED=$(transmission-remote --torrent "$TORRENTID" --info | grep 'Uploaded:' | cut -s -d ':' -f2 | sed -e 's/^[ \t]*//')
        LIMITRATIO=200
        NAMN="EnterNameHere"

        #HemmaHack Ratio INF-koll
        if [ "$TORRENTRATIO" = "Inf" ] ; then
                TORRENTRATIO=0
        fi

	if [ "$TORRENTRATIO" = "" ] ; then
		TORRENTRATIO=0
	fi

        if [ "$TORRENTRATIO" = " " ] ; then
                TORRENTRATIO=0
        fi

        if [ "$TORRENTSEC" = "" ] ; then
                TORRENTSEC=0
        fi

        if [ "$TORRENTUPLOADED" = "None" ] ; then
                TORRENTUPLOADED="0 KB"
        fi

	INTRATIO=$(echo "$TORRENTRATIO" '*100' | bc -l | awk -F '.' '{ print $1; exit; }')

        #If torrent has been seeded for a week or seeded above a ratio of 2.0, remove it !
        if [ "$INTRATIO" -ge "$LIMITRATIO" ]; then
        transmission-remote -t "$TORRENTID" --remove-and-delete
        echo "$NAME" " has been removed! [ SEED RATIO ]"
        python discord/TransNuke_Send.py "$NAMN" "$NAME" "$TORRENTRATIO" "$SEEDING" "$TORRENTUPLOADED" "$TORRENTSIZE"
        elif [ "$TORRENTSEC" -gt 604800 ]; then
       transmission-remote -t "$TORRENTID" --remove-and-delete
        echo "$NAME" " has been removed! [ SEED DAYS ]"
        python discord/TransNuke_Send.py "$NAMN" "$NAME" "$TORRENTRATIO" "$SEEDING" "$TORRENTUPLOADED" "$TORRENTSIZE"
        fi
done
