#!/bin/bash
echo "started"
i=$1
folder=/var/lib/navidrome/music
pushd $folder
echo "starting spotdl"
./spotdl $i
./all_lyrics "$folder"
popd
