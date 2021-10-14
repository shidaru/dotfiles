# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
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
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

#if [ "$color_prompt" = yes ]; then
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#else
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
# case "$TERM" in
# xterm*|rxvt*)
#     PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#     ;;
# *)
#     ;;
# esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

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

# alias
alias la="ls -a"
alias ll="ls -al"
alias ..="cd .."

function cd {
  if [ -z "$1" ]; then
    test "$PWD" != "HOME" && pushd $HOME > /dev/null
  else
    pushd "$1" > /dev/null
  fi
  ls
}

function cdh {
  local dirnum
  dirs -v | sort -k 2 | uniq -f 1 | sort -n -k 1 | head -n $(( LINES - 3))
  read -p "select number: " dirnum
  if [ -z "$dirnum" ]; then
    echo "$FUNCNAME: Abort." 1>&2
  elif ( echo $dirnum | egrep '[[:digit:]]+$' > /dev/null ); then
    cd "$( echo ${DIRSTACK[$dirnum]} | sed -e "s;^~;$HOME;" )"
  else
    echo "$FUNCNAME: Wrong." 1>&2
  fi
}

function cdb {
  local num=$1 i
  if [ -z "$num" -o "$num" = 1 ]; then
    popd >/dev/null
    return
  elif [[ "$num" =~ ^[0-9]+$ ]]; then
    for (( i=0; i<num; i++ )); do
      popd >/dev/null
    done
    return
  else
    echo "ceback: argument is invalid." >&2
  fi
}

function cdl {
  local -a dirlist opt_f=false
  local i d num=0 dirnum opt opt_f
  while getopts ":f" opt; do
    case $opt in
      f ) opt_f=true ;;
    esac
  done
  shift $(( OPTIND -1 ))
  dirlist[0]=..
  for d in * ; do test -d "$d" && dirlist[$((++num))]="$d" ; done
  for i in $( seq 0 $num ) ; do printf "%3d %s%b\n" $i "$( $opt_f && echo -n "$PWD/" )${dirlist[$i]}" ; done
  read -p "select number: " dirnum
  if [ -z "$dirnum" ]; then
    echo "$FNCNAME: Abort." 1>&2
  elif ( echo $dirnum | egrep '^[[:digit:]]+$' > /dev/null ) ; then
    cd "${dirlist[$dirnum]}"
  else
    echo "$FUNCNAME: Something wrong." 1>&2
  fi
}

# prompt
# export PS1='$(git-ps)\n\[\e[1;32m\]\u\[\e[1;37m\]@\[\e[1;34m\]\h \[\e[1;37m\]\w \d\[\e[m\]\n\\$ '
# Git
if [ -f $HOME/bin/git-completion.bash -a -f $HOME/bin/git-prompt.sh ]; then
  source $HOME/bin/git-completion.bash
  GIT_PS1_SHOWDIRTYSTATE=1
  source $HOME/bin/git-prompt.sh
  PS1='\[\e[1;32m\]\u\[\e[1;37m\]@\[\e[1;34m\]\h \[\e[1;37m\]\w$(__git_ps1 " (%s)")\n\\$ '
fi

#pyenv
export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init -)"

export DISPLAY=:0
export LIBGL_ALWAYS_INDIRECT=1

shopt -s autocd
shopt -s cdspell
shopt -s dotglob
shopt -s extglob
shopt -s globstar
