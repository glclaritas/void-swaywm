# .bashrc

# if not running interactively, don't do anything
[[ $- != *i* ]] && return

export NNN_OPENER=mimeo
export NNN_FIFO=/tmp/nnn.fifo
export NNN_PLUG='p:preview-tui;'
export NNN_TERMINAL="$TERM --app-id=nnn-preview-tui"

#alias
alias ls='ls --color=auto'
alias fm='nnn -e'

#auto cd
shopt -s autocd

#clear history
rm $HOME/.bash_history*.tmp > /dev/null 2>&1

PS1='[\W] \$ '
PS0='\[\033[0m\]'

PROMPT_COMMAND='printf "\033]7;file://%s%s\033\\" "$HOSTNAME" "$PWD"'
