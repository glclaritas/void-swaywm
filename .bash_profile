# .bash_profile

# Get the aliases and functions
[ -f $HOME/.bashrc ] && . $HOME/.bashrc

export MANPAGER='nvim +Man!'

if [[ "$(tty)" == "/dev/tty1" ]]; then
    [ -f $HOME/.config/sway/scripts/startsway.sh ] &&
        $HOME/.config/sway/scripts/startsway.sh &&
        clear &&
        logout
fi
