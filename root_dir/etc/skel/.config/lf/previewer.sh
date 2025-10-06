#!/bin/sh
# Max preview dimensions
MAX_WIDTH=80
MAX_HEIGHT=40

# Clamp function
clamp() {
  local val=$1 max=$2
  if [ "$val" -gt "$max" ]; then
    echo "$max"
  else
    echo "$val"
  fi
}

case "$1" in
  *.tar* | *.tgz) tar tf "$1";;
  *.zip) unzip -l "$1";;
  *.rar) unrar l "$1";;
  *.7z) 7z l "$1";;
  *.pdf) echo "This is pdf file. Open it manually";;
  *.png | *.jpg | *.svg | *.gif | *.webp)
    WIDTH=$(clamp "${2:-40}" "$MAX_WIDTH")
    HEIGHT=$(clamp "${3:-20}" "$MAX_HEIGHT")
    chafa "$1" -f sixel -s "${WIDTH}x${HEIGHT}" --animate false --polite on
    exit 1;;
  *) cat "$1";;
esac

