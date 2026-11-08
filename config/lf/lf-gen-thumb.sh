#!/bin/bash
# lf-gen-thumb.sh <path>
# Pre-generate XDG-style thumbnails. Current dir first, then subdirs level by level.

[ $# -eq 1 ] || exit 1
target="$(realpath -ms -- "$1")"

# shellcheck source=lf-thumb-common.sh
. "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/lf-thumb-common.sh" || exit 1

# restrictions at top level
case "$target" in
    "$CACHE_HOME" | "$CACHE_HOME"/* | "$HOME" | "$HOME"/.*)
        echo "Restricted directory"
        exit 1
        ;;
esac

mkdir -p -- "$THUMB_ROOT" || exit 1
shopt -s nullglob

# $1 = file, $2 = mime, $3 = output thumbnail
make_thumb() {
    case $2 in
        image/x-aseprite)
            aseprite-thumbnailer "$1" "$3" "$THUMB_DIMENSION"
            ;;
        image/*)
            vipsthumbnail "$1" \
                --size "$THUMB_DIMENSION" \
                --output-profile srgb \
                --path "$3[compression=9,palette=true,Q=80,keep=none]" \
                --delete
            ;;
        video/*)
            ffmpegthumbnailer -i "$1" -o "$3" -s "$THUMB_DIMENSION" -c png -m -q 8
            ;;
    esac
}

# args = files. Skips files that already have a valid thumbnail,
# detects mime types for the rest in ONE `file` call.
process_files() {
    local -a todo=() thumbs=() mimes=()
    local f i mime
    for f; do
        thumb_path "$f"
        [[ -s $REPLY ]] && continue
        rm -f -- "$REPLY"                  # drop empty/broken leftovers
        todo+=("$f"); thumbs+=("$REPLY")
    done
    ((${#todo[@]})) || return 0

    mapfile -t mimes < <(file -Lb --mime-type -- "${todo[@]}")
    for i in "${!todo[@]}"; do
        f=${todo[i]}; mime=${mimes[i]}
        case ${f,,} in *.ase | *.aseprite) mime=image/x-aseprite ;; esac
        make_thumb "$f" "$mime" "${thumbs[i]}" || rm -f -- "${thumbs[i]}"
    done
}

# single file
if [[ -f $target ]]; then
    process_files "$target"
    exit 0
fi
[[ -d $target ]] || exit 1

# breadth-first: files of a dir first, its subdirs go to the queue
queue=("$target")
for (( q = 0; q < ${#queue[@]}; q++ )); do
    files=()
    for f in "${queue[q]}"/*; do
        if [[ -d $f && ! -L $f ]]; then
            queue+=("$f")
        elif [[ -f $f ]]; then
            files+=("$f")
        fi
    done
    process_files "${files[@]}"
done
exit 0
