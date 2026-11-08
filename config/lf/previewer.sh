#!/bin/bash
# lf previewer. args: $1 file, $2 width, $3 height, $4 x, $5 y, $6 mode
[ "$6" = "preload" ] && exit 0

# shellcheck source=lf-thumb-common.sh
. "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/lf-thumb-common.sh" || exit 1

bg="#24273a"   # match terminal bg

case "$1" in
    *.ase | *.aseprite) mime="image/x-aseprite" ;;
    *) mime="$(file -Lb --mime-type -- "$1")" ;;
esac

case "$mime" in
    application/gzip | application/x-tar) tar tf "$1" ;;
    application/zip) unzip -l "$1" ;;
    application/vnd.rar | application/x-rar-compressed) unrar l "$1" ;;
    application/x-7z-compressed) 7z l "$1" ;;
    application/pdf) echo "This is pdf file. Open it manually" ;;
    image/* | video/*)
        case "$1" in "$CACHE_HOME/thumbnails"/*) exit 1 ;; esac
        thumb_path "$1"
        if [ ! -s "$REPLY" ]; then
            echo "Thumbnail is not generated yet. Generate thumbnail with :lf-gen-thumb"
            exit 1
        fi
        chafa -f sixel --size "${2}x${3}" --clear --animate false --bg "$bg" \
            -t 1 -O 9 --polite on "$REPLY"
        ;;
    text/*) head -n "$3" "$1" ;;
esac
