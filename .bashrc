#  _               _              
# | |__   __ _ ___| |__  _ __ ___ 
# | '_ \ / _` / __| '_ \| '__/ __|
# | |_) | (_| \__ \ | | | | | (__ 
# |_.__/ \__,_|___/_| |_|_|  \___|
#                                 

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# FZF
. /usr/share/fzf/key-bindings.bash # CTRL-T to navigate files, CTRL-R to navigate history
. /usr/share/fzf/completion.bash
export FZF_DEFAULT_OPTS='--color bw --reverse --border'
export FZF_DEFAULT_COMMAND='find . 2>/dev/null'
export FZF_CTRL_T_OPTS="--select-1 --exit-0 --preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
export FZF_CTRL_T_COMMAND="find . 2>/dev/null"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
export FZF_ALT_C_COMMAND="find . -type d 2>/dev/null"

# command-not-found
source /usr/share/doc/pkgfile/command-not-found.bash

# colors
alias grep="grep --color=auto"
alias ls="ls --color=auto -F"


# Replace ls with lsd (an improoved version of ls with icons)
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias ll='ls -la'
alias lt='ls --tree'

PS1='[\u@\h \W]\$ '

PATH=$PATH:~/.local/bin
PATH=$PATH:~/.node_modules/bin




