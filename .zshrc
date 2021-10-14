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

# --------------
# cdr関連
# --------------
# cdしたら自動でディレクトリスタックする
setopt AUTO_PUSHD
# 同じディレクトリは追加しない
setopt pushd_ignore_dups
# スタックサイズ
DIRSTACKSIZE=100
# cdr, add-zsh-hook を有効にする
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

# --------------
# 履歴関連
# --------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
# 過去に同じ履歴が存在する場合、古い履歴を削除し重複しない
setopt hist_ignore_all_dups
# 同時に起動したzshの間でヒストリを共有する
setopt share_history
# コマンド先頭スペースの場合保存しない
setopt hist_ignore_space
# ヒストリを呼び出してから実行する間に一旦編集できる状態になる
setopt hist_verify
#余分なスペースを削除してヒストリに記録する
setopt hist_reduce_blanks
# histryコマンドは残さない
setopt hist_save_no_dups
# 古い履歴を削除する必要がある場合、まず重複しているものから削除
setopt hist_expire_dups_first
# 補完時にヒストリを自動的に展開する
setopt hist_expand
# 履歴をインクリメンタルに追加
setopt inc_append_history

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
export PATH=$HOME/dotfiles/bin:$PATH

export LESS='-g -i -M -R -S -W -z-4 -x4'
export LESSOPEN='| /usr/share/source-highlight/src-hilite-lesspipe.sh %s'

# wsl用Xサーバ設定
export DISPLAY=`grep -oP "(?<=nameserver ).+" /etc/resolv.conf`:0.0
export LIBGL_ALWAYS_INDIRECT=1
# 日本語
export LANG=ja_JP.UTF-8

setopt NO_BG_NICE
umask 022
#  Couldn't connect to accessibility bus:
# Failed to connect to socket /tmp/dbus-xxfluS2Izg: Connection refused
# みたいなwarningがでた場合の処置
export NO_AT_BRIDGE=1
