#!/bin/sh

# see https://github.com/gokcehan/lf/blob/master/doc.md#previewer-string-default--not-filtered-if-empty
# $1 = filename
# $2 = preview pane width
# $3 = preview pane height
# $4 = horizontal position
# $5 = vertical position
# $6 = mode (preview | preload)

[ "$6" = "preload" ] && exit 0

# match terminal bg
bg="#24273a"

CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
THUMB_DIR="$CACHE_HOME/thumbnails"
THUMB_SIZE="lf"         # sync this with THUMB_SIZE from lf-gen-thumb.sh
get_xdg_thumb_hash() {
    python3 -c '
    import sys, urllib.parse, hashlib, os
    path = os.path.abspath(sys.argv[1])
    uri = pathlib_uri = "file://" + urllib.parse.quote(path, safe="/")
    print(hashlib.md5(uri.encode("utf-8")).hexdigest())
    ' "$1"
}
case "$1" in
    *.ase | *.aseprite)
        mime="image/x-aseprite"
        ;;
    *)
        mime="$(file -Lb --mime-type -- "$1")"
        ;;
esac
case "$mime" in
  application/gzip | application/x-tar) tar tf "$1";;
  application/zip) unzip -l "$1";;
  application/vnd.rar | application/x-rar-compressed) unrar l "$1";;
  application/x-7z-compressed) 7z l "$1";;
  application/pdf) echo "This is pdf file. Open it manually";;
  image/* | video/*)
      case "$1" in 
          "$THUMB_DIR"/*) exit 1;;
      esac
      thumb_path="${THUMB_DIR}/${THUMB_SIZE}/$(get_xdg_thumb_hash "$1").png"
      if [ ! -f "$thumb_path" ]; then
          echo "Thumbnail is not generated yet. Generate thumbnail with :lf-gen-thumb"
          exit 1
      fi

    chafa -f sixel --size "${2}x${3}" --clear --animate false --bg $bg -t 1 -O 9 --polite on "$thumb_path"
    ;;
  text/*)head -n "$3" "$1";;
esac
