#!/bin/bash
#
# Create character spritesheet and join all the rendered images
#
set -e
if [ "$#" -ne 1 ]; then
    echo "Usage: make_spritesheet.sh body"
    exit 1
fi

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  BLENDER=blender
else
  # macos
  BLENDER=/Applications/blender.app/Contents/MacOS/blender
fi
INFILE=$1/src.blend
# Render separate body parts (in collections)
parts=(legs upper)
# Render separate actions
actions_legs=(idle run)
actions_upper=(idle idle_handgun run run_handgun)
idle_frames=1
run_frames=80
len_i=${#parts[*]}
for (( i=0; i<len_i; i++ ))
do
    part=${parts[$i]}
    collections=base
    if [[ $part == *"legs"* ]]
    then
      actions=${actions_legs[@]}
      collections=$collections,legs
    else
      actions=${actions_upper[@]}
      collections=$collections,upper
    fi
    for action in $actions
    do
      if [[ $action == *"run"* ]]
      then
        frames=$run_frames
      else
        frames=$idle_frames
      fi
      # Include right hand collection if the part is "upper" and action doesn't have
      # "handgun"
      if [[ $part == *"upper"* ]] && [[ $action != *"handgun"* ]]
      then
        collections=$collections,hand_right
      fi
      "$BLENDER" -noaudio -b "$INFILE" -P render.py -- "$collections" "$action" "$frames" "$part"

      DIMENSIONS=`identify -format "%wx%h" "out/${part}_${action}_0_00.png"`
      OUTFILE=$1/${part}_${action}_${DIMENSIONS}.png
      rm "$OUTFILE"
      montage -geometry +0+0 -background none -tile x8 "out/${part}_${action}_*.png" -channel A tmpimage
      convert tmpimage -dither None -colors 32 -level 25%,60% "$OUTFILE"
      rm tmpimage
      chmod 644 "$OUTFILE"
      echo "Created $OUTFILE"
    done
done

rm -rf out/
