#!/bin/bash

# $1 = full path of target dir
[ $# -ne 1 ] && exit 1
dir="$1"

bg="#24273a"
CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
THUMB_DIR="$CACHE_HOME/thumbnails"
THUMB_SIZE="lf"         # sync this with THUMB_SIZE from previewer.sh. this can use xdg specs sizes like large, normal but but ...
THUMB_DIMENSION="256"

# restrictions at top level
case "$dir" in
    "$CACHE_HOME"* | "$HOME" | "$HOME"/.*)
        echo "Restricted directory"
        exit 1
        ;;
esac

get_xdg_thumb_hash() {
    python3 -c '
    import sys, urllib.parse, hashlib, os
    path = os.path.abspath(sys.argv[1])
    uri = "file://" + urllib.parse.quote(path, safe="/")
    print(hashlib.md5(uri.encode("utf-8")).hexdigest())
    ' "$1"
}

gen_thumb() {
    subdirs=""
    for file in "$1"/*; do
        if [ -d "$file" ]; then
            subdirs+=" ${file}"
            continue
        fi

        # manually handle uncaught types
        case "$file" in
            *.ase | *.aseprite)
                mime="image/x-aseprite"
                ;;
            *)
                mime="$(file -Lb --mime-type -- "$file")"
                ;;
        esac

        file_hash="$(get_xdg_thumb_hash "$file")"
        thumb_path="${THUMB_DIR}/${THUMB_SIZE}/${file_hash}.png"

        case "$mime" in
            image/x-aseprite)
                aseprite-thumbnailer "$file" "$thumb_path" "$THUMB_DIMENSION"
                ;;
            image/* | video/*)

                [ -f "$thumb_path" ] || [ ! -s "$thumb_path" ] && rm -f "$thumb_path"
            
                mkdir -p "${THUMB_DIR}/${THUMB_SIZE}" 2>/dev/null || :
                case "$mime" in
                    image/*)
                        convert "$file" -thumbnail "${THUMB_DIMENSION}x${THUMB_DIMENSION}" -background "$bg" -alpha remove -alpha off "$thumb_path"
                        ;;
                    video/*)
                        ffmpegthumbnailer -i "$file" -o "$thumb_path" -s "${THUMB_DIMENSION}" -c png -m -q 8
                        ;;
                esac
                ;;
        esac
    done
    for subdir in $subdirs; do
        gen_thumb "$subdir"
    done
}

gen_thumb "$dir"
exit 0
