# zshrc
# emacs 風キーバインドにする
bindkey -e

# 色を使用
autoload -Uz colors
colors

# プロンプトを2行で表示、時刻を表示
PROMPT=$'%{\e[38;5;082m%}%n%{\e[0m%}@%{\e[38;5;045m%}%m%{\e[0m%} [%w %T] %~
>>> '

# Ctrl+Dでログアウトしてしまうことを防ぐ
setopt IGNOREEOF

# 日本語を使用
export LANG=ja_JP.UTF-8

# 補完
autoload -Uz compinit
compinit

eval "$(dircolors .dircolors)"

# 補完候補もLS_COLORSに合わせて色が付くようにする
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups
# 同時に起動したzshの間でヒストリを共有する
setopt share_history

# cdコマンドを省略して、ディレクトリ名のみの入力で移動
setopt auto_cd

# コマンドミスを修正
setopt correct

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# Ctrl+rでヒストリーのインクリメンタルサーチ、Ctrl+sで逆順
bindkey '^r' history-incremental-pattern-search-backward
bindkey '^s' history-incremental-pattern-search-forward

# コマンドを途中まで入力後、historyから絞り込み
# 例 ls まで打ってCtrl+pでlsコマンドをさかのぼる、Ctrl+bで逆順
autoload -Uz history-search-end

# git設定
#RPROMPT="%{${fg[blue]}%}[%~]%{${reset_color}%}"
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () { vcs_info }
RPROMPT=$RPROMPT'${vcs_info_msg_0_}'

# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt prompt_subst

# オプション
# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# beep を無効にする
setopt no_beep

#cdしたあとで、自動的に ls する
function chpwd() { ls --color=auto }

# alias
alias la="ls -a --color=auto"
alias ll="ls -l --color=auto"
alias ls="ls --color=auto"
alias lal="ls -al --color=auto"
alias gls="gls --color=auto"
alias mkdir="mkdir -p"
alias rm="rm -i"
alias cp='cp -i'
alias mv='mv -i'
alias cdh='cdr -l'
alias setproxy='source proxy.sh s'
alias unsetproxy='source proxy.sh u'
alias cdo='cd /mnt/c/Users/miton/OneDrive/'

function ktc() {
    before=$1
    after=`echo $1 | rev | cut -c 4- | rev`
    `kotlinc $before -include-runtime -d $after.jar`
}
alias ktc='ktc $1'

function cless() {
	column -s, -t < $1 | less -#2 -N -S
}


# 環境変数
# bin
export PATH=$HOME/bin:$PATH

# pyenv
export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init -)"

export LESS='-g -i -M -R -S -W -z-4 -x4'
export LESSOPEN='| /usr/share/source-highlight/src-hilite-lesspipe.sh %s'

export GOROOT=$HOME/local/go
export GOPATH=$HOME/.go
export PATH=$GOROOT/bin:$PATH

export BROWSER=$HOME/local/firefox/firefox

alias re="$HOME/local/remacs/bin/remacs"
#alias emacs="/mnt/d/local/emacs/bin/emacs"

# wsl用Xサーバ設定
export DISPLAY=:0.0
export LIBGL_ALWAYS_INDIRECT=1

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/haruka/.sdkman"
[[ -s "/home/haruka/.sdkman/bin/sdkman-init.sh" ]] && source "/home/haruka/.sdkman/bin/sdkman-init.sh"

export LANG=ja_JP.UTF-8

export PATH=$HOME/.nimble/bin:$PATH

