#!/bin/bash
BEETSDIR=/home/alarm/
i="$1"
title=$(eyeD3 "$i" | grep "artist" | awk -F": " '{print $2}' | sed '2d')
title="$title $(eyeD3 "$i" | grep "title" | awk -F": " '{print $2}')"
echo check if lyrics exist in target lang
mylyr=$(eyeD3 "$i" 2> /dev/null | grep "^Lyrics.*Lang:.*eng.*")
mylyrc=$(beet info -i 'lyrics' "$i")
if [ -n "$mylyr" ]; then
#there is a lyrics entry in target lang
if [ -n "$mylyrc" ]; then
#there is lyrics text
echo "lyrics present, skipping"
exit 0
else
echo "adding lyrics"
fi
fi
echo fetch lyrics from sources
syncedlyrics "$title" -p lrclib > "$BEETSDIR/mylyrics.txt"
echo resetting lyrics
eyeD3 --remove-all-lyrics "$i" >/dev/null
echo adding lyrics from file if lyrics were found
if [ -z "$(cat $BEETSDIR/mylyrics.txt)" ]; then
echo "no lyrics found, skipping write"
else
eyeD3 --add-lyrics=$BEETSDIR/mylyrics.txt::eng "$i" >/dev/null
fi
echo finish
