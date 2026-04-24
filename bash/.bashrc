# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

parse_git_bg() {
    # "\033[0;33m" is ANSI output, so no escaping with \[ or \]
    if ! git diff --cached --quiet --ignore-submodules -- 2>/dev/null; then
        echo -e "\033[0;33m" # Yellow: staged but not committed
    elif [[ -n "$(git status --porcelain --untracked-files=normal)" ]]; then
        echo -e "\033[0;31m" # Red: unstaged changes
    else
        echo -e "\033[0;32m" # Green: clean
    fi
}

get_git_branch() {
    git rev-parse --is-inside-work-tree &>/dev/null || return

    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --exact-match 2>/dev/null)

    echo "$branch"
}

# "" expand values such as variables or functions
# '' literal
COLOR_END='\[\033[0m\]'
CWD='\w'
TIME='\[\e[32m\]\t\[\e[0m\]'
# \\ around function calls keep them dynamic
PS1="${TIME} ${CWD}:\[\$(parse_git_bg)\]\$(get_git_branch)${COLOR_END} \$ "

# export a PATH with system directories, user directories, and custom paths
export PATH=$PATH:/bin
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export PATH=$PATH:/usr/bin
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/usr/local/lua-language-server/bin
export PATH=$PATH:/usr/local/lib/luarocks/rocks-5.1
export PATH=$PATH:/usr/sbin
export PATH=$PATH:$HOME/.cargo/env
export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.local/share/cargo/bin
export PATH=$PATH:$HOME/.nvm/versions/node/v22.15.1/bin
export PATH=$PATH:$HOME/.nvm/versions/node/v22.15.1/bin/npm

# Cargo
. "$HOME/.cargo/env"

# FZF
if [ "$(uname -s)" = "Darwin" ]; then
    eval "$(fzf --bash)"
else
    source "$HOME/.fzf.bash"
fi

# Zoxide
eval "$(zoxide init bash)"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# SDI specific stuff
# Conditional guard to prevent errors when .env.sdi does not exist
[ -f ~/.env.sdi ] && source "$HOME/.env.sdi"

# WARN: Must be at end
# WARN: Must be at end
# WARN: Must be at end
[ -z "$ZELLIJ" ] && zellij
