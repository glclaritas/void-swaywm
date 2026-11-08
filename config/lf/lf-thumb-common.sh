# Shared by lf-gen-thumb.sh and previewer.sh (source it, do not execute).
# Single source of truth so generator and previewer can never disagree.

CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
THUMB_SIZE="lf"
THUMB_DIMENSION=256
THUMB_ROOT="$CACHE_HOME/thumbnails/$THUMB_SIZE"

# Sets REPLY to the thumbnail path (XDG spec: md5 of percent-encoded file:// URI).
# $1 must be an absolute path WITHOUT symlink resolution or trailing slash.
thumb_path() {
    local LC_ALL=C s=$1 enc="" c i hash
    for (( i = 0; i < ${#s}; i++ )); do
        c=${s:i:1}
        case $c in
            [a-zA-Z0-9/_.~-]) enc+=$c ;;
            *) printf -v c '%%%02X' "'$c"; enc+=$c ;;
        esac
    done
    hash=$(printf '%s' "file://$enc" | md5sum)
    REPLY="$THUMB_ROOT/${hash%% *}.png"
}
