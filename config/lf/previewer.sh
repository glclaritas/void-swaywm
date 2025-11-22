#!/bin/sh

# see https://github.com/gokcehan/lf/blob/master/doc.md#previewer-string-default--not-filtered-if-empty
# $1 = filename
# $2 = preview pane width
# $3 = preview pane height
# $4 = horizontal position
# $5 = vertical position
# $6 = mode (preview | preload)

case "$(file -Lb --mime-type -- "$1")" in
  application/gzip | application/x-tar) tar tf "$1";;
  application/zip) unzip -l "$1";;
  application/vnd.rar | application/x-rar-compressed) unrar l "$1";;
  application/x-7z-compressed) 7z l "$1";;
  application/pdf) echo "This is pdf file. Open it manually";;
  image/*)
      WIDTH=$(( $2 * 90 / 100 ))
      HEIGHT=$(( $3 * 90 / 100 ))
    chafa "$1" -f sixel -s "${WIDTH}x${HEIGHT}" --animate false --polite on
    exit 1;;
  video/*)
    WIDTH=$(( $2 * 90 / 100 ))
    HEIGHT=$(( $3 * 90 / 100 ))
    ffmpegthumbnailer -i "$1" -m -c png -s 512 -o - | chafa -f sixel -s "${WIDTH}x${HEIGHT}" --animate false --polite on
    ;;
  text/*)head -n "$3" "$1";;
esac
