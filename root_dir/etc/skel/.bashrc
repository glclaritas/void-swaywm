# .bashrc

# if not running interactively, don't do anything
[[ $- != *i* ]] && return

#alias
alias ls='ls --color=auto'

#auto cd
shopt -s autocd

#clear history
clear-history(){
    rm -r ~/.bash_history*.tmp > /dev/null 2&>1
}

PS1='[\W] \$ '
PS0='\[\033[0m\]'

PROMPT_COMMAND='printf "\033]7;file://%s%s\033\\" "$HOSTNAME" "$PWD"'
