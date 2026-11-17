# .bashrc

# if not running interactively, don't do anything
[[ $- != *i* ]] && return

# sync this block with env vars inside ~/.config/xdg-desktop-portal-termfilechooser/sway
nnn-term-file-chooser() {
    if [ -n "$TMUX" ]; then
        command nnn -a "$@"
    else
        tmux -L nnn -f ~/.config/tmux/nnn.conf new-session -- nnn -a "$@"
    fi
}
export NNN_OPTS="eaAc"
export NNN_OPENER=mimeo
export FOOT_PREVIEW_SIZE=72x40        # initial foot window, in cells
export FOOT_PREVIEW_ENGINE=chafa      # or img2sixel
export NNN_PLUG='p:foot-preview'
export NNN_TERMINAL="$TERM --app-id=nnn-preview-tui"
alias fm=nnn-term-file-chooser
alias nnn=nnn-term-file-chooser


#alias
alias ls='ls --color=auto'

#auto cd
shopt -s autocd

#clear history
rm $HOME/.bash_history*.tmp > /dev/null 2>&1

# git 

PS1='[\W] \$ '
PS0='\[\033[0m\]'

PROMPT_COMMAND='printf "\033]7;file://%s%s\033\\" "$HOSTNAME" "$PWD"'
