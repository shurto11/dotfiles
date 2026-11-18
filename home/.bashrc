
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
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    linux) [ "$FBTERM" ] && export TERM=fbterm && color_prompt=yes;;
    fbterm) color_prompt=yes;;
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

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
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

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

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

# Created by `pipx` on 2025-12-13 09:49:01
export PATH="$PATH:/home/shurto11/.local/bin"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# カスタマイズTerminal
# 配色: OKLCH で明るさ L=0.78・鮮やかさ C=0.12 をそろえ、色相だけを変えて統一感を出す。
# (L を 0.80 以上にすると水色と赤が sRGB の範囲を超えて色が崩れる)
# 濃紺と白も水色と同じ系統の色相(235〜255°)にしてある。文字は読みやすさを優先して黒にした(コントラスト比 10.0 以上)。
#   番号 色      役割                 OKLCH                 (パレットの元の色)
#   17   #142539 濃紺: 区切りの矢印     L=0.26 C=0.045 H=255 (#00005F)
#   16   #000000 黒:   文字              (元から同じ色なので書き換えない。色0と違い透けない)
#   75   #61C3F9 水色: 2行目(成功)       L=0.78 C=0.12  H=235 (#5FAFFF)
#   72   #7CCD8E 緑:   user@host         L=0.78 C=0.12  H=150 (#5FAF87)
#   209  #F2A26A オレンジ: 時刻          L=0.78 C=0.12  H=55  (#FF875F)
#   210  #FB9890 赤:   2行目(失敗)       L=0.78 C=0.12  H=25  (#FF8787)
#   255  #EEF7FC 白:   パス              L=0.97 C=0.012 H=235 (#EEEEEE)
# fbterm は 24bit カラーを出せず 256 色パレットしか使えないので、上の番号を fbterm 独自の
# シーケンス ESC[3;n;r;g;b} でこの色に書き換えて使う。番号は元の色が近く、tmux.conf と
# vim(habamax) が使っていないものを選んである(fbterm 以外の端末では元の色で近似される)。
# 色0(黒)は fbterm の壁紙モードで背景が透けるので使わない。
# tmux はこのシーケンスを外へ通さないため、tmux の外(fbterm 直下のシェル)で送る。
# パレットは fbterm を再起動すると元に戻るが、再起動後は必ずここを通って tmux に入る。
if [ "$TERM" = "fbterm" ] && [ -z "$TMUX" ]; then
    printf '\e[3;17;20;37;57}\e[3;75;97;195;249}\e[3;72;124;205;142}\e[3;209;242;162;106}\e[3;210;251;152;144}\e[3;255;238;247;252}'
fi
FMT_RESET='\[\e[0m\]'
FG_NAVY='\[\e[38;5;17m\]'
FG_BLACK='\[\e[38;5;16m\]'
FG_WHITE='\[\e[38;5;255m\]'
FG_GREEN='\[\e[38;5;72m\]'
FG_ORANGE='\[\e[38;5;209m\]'
BG_NAVY='\[\e[48;5;17m\]'
BG_WHITE='\[\e[48;5;255m\]'
BG_GREEN='\[\e[48;5;72m\]'
BG_ORANGE='\[\e[48;5;209m\]'
# Powerline の矢印 (U+E0B0)。ロケールに依存しないよう UTF-8 のバイト列で書く
ARROW=$'\xee\x82\xb0'
# アイコン。fbterm は全角幅でデザインされた Cica のアイコンを1マスで切ってしまうため、
# 左右に分割した「Cica Split Icons」フォント(~/.local/share/fonts, fbtermrc で Cica の次に指定)
# の半角2文字を並べて全角1個分として出す
ICON_FOLDER=$'\xee\x80\x90\xee\x80\x91'   # nf-fa-folder  (U+F07B) -> U+E010 U+E011
ICON_LAPTOP=$'\xee\x80\xa0\xee\x80\xa1'   # nf-fa-laptop  (U+F109) -> U+E020 U+E021
ICON_CLOCK=$'\xee\x80\xae\xee\x80\xaf'    # nf-fa-clock_o (U+F017) -> U+E02E U+E02F

# 矢印は「前のセグメントの色を文字色、次のセグメントの色を背景色」にして繋ぐ。
# 色の切り替わりでは 前の色→濃紺→次の色 と矢印を2つ重ね、濃紺の矢印の縁取りを作る
PS1=""
PS1+="${BG_WHITE}${FG_BLACK} ${ICON_FOLDER} \w "
PS1+="${BG_NAVY}${FG_WHITE}${ARROW}"
PS1+="${BG_GREEN}${FG_NAVY}${ARROW}"
PS1+="${FG_BLACK} ${ICON_LAPTOP} \u@\h "
PS1+="${BG_NAVY}${FG_GREEN}${ARROW}"
PS1+="${BG_ORANGE}${FG_NAVY}${ARROW}"
PS1+="${FG_BLACK} ${ICON_CLOCK} \t "
PS1+="${FMT_RESET}${FG_ORANGE}${ARROW}"   # 行末の矢印(端末の背景色の上にオレンジで描く)
PS1+="${FMT_RESET}\n"
# 2行目: 直前のコマンドが成功なら水色、失敗なら赤のブロック。色は __ps1_status が毎回決める
# (色の部分はシングルクォートで書き、プロンプトを出すたびに変数を展開させる)
PS1+='\[${__PS1_BG}\]'"${FG_BLACK} $ ${FMT_RESET}"
PS1+='\[${__PS1_FG}\]'"${ARROW}${FMT_RESET} "

# 直前のコマンドの終了ステータスから2行目の色を決める。
# $? を他の処理に上書きされる前に受け取るため、PROMPT_COMMAND の先頭で呼ぶ
__ps1_status() {
    if [ $? -eq 0 ]; then
        __PS1_BG=$'\e[48;5;75m' __PS1_FG=$'\e[38;5;75m'     # 成功: 水色 #61C3F9
    else
        __PS1_BG=$'\e[48;5;210m' __PS1_FG=$'\e[38;5;210m'   # 失敗: 赤 #FB9890
    fi
}
# .bashrc を読み直しても二重登録しない(二重だと2回目が1回目の成功を拾って常に水色になる)
[[ $PROMPT_COMMAND == *__ps1_status* ]] || PROMPT_COMMAND="__ps1_status${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

# オリジナルコマンド
# duckduckgo検索
sddg () {
    w3m "https://duckduckgo.com"
}

eduroam() {
    sudo wpa_supplicant -i wlp0s12f0 -c ~/eduroam.profile
}

function cd() {
    builtin cd $@ && ls;
}

mkcd() {
    mkdir $* && cd $_
}
alias mkcd="mkcd"

# tmux の自動起動（fbterm 内で、まだ tmux セッション内にいない場合）
# ソケットは ssd 上に置かない（ssd の unmount/remount で tmux に到達できなくなるため）。
# /run/user/<uid> は tmpfs でログイン中ずっと安定し、ssd とは無関係。
export TMUX_TMPDIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
if [ "$TERM" = "fbterm" ] && [ -z "$TMUX" ]; then
    tmux attach 2>/dev/null || tmux   # 既存セッションへ復帰(fbterm再起動時)、無ければ新規
fi
. "$HOME/.cargo/env"

# Claude Code エイリアス
alias cc='claude --dangerously-skip-permissions'

# Go and Discordo
export PATH="$HOME/go-install/go/bin:$HOME/go/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/shurto11/google-cloud-sdk/path.bash.inc' ]; then . '/home/shurto11/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/shurto11/google-cloud-sdk/completion.bash.inc' ]; then . '/home/shurto11/google-cloud-sdk/completion.bash.inc'; fi

# moonbit
export PATH="$HOME/.moon/bin:$PATH"
. "/home/shurto11/.deno/env"

# 実行結果をファイルに
#   run コマンド... >> ファイル      ファイルの末尾に追記
#   run コマンド... >> ファイル N    ファイルの N 行目の後ろに挿入（0 なら先頭）
run() {
    local pid=$BASHPID out
    out=$(readlink "/proc/$pid/fd/1")

    # 出力先がファイルで、最後の引数が数字なら行番号とみなす
    if [ $# -lt 2 ] || [ ! -f "$out" ] || ! [[ "${!#}" =~ ^[0-9]+$ ]]; then
        echo "> \$ $*"; "$@"
        return
    fi

    local line="${!#}"
    set -- "${@:1:$#-1}"
    if [ "$line" -gt "$(wc -l < "$out")" ]; then
        echo "run: $out は $(wc -l < "$out") 行しかありません" >&2; return 1
    fi
    local tmp
    tmp=$(mktemp) || return 1
    { echo "> \$ $*"; "$@"; } > "$tmp"
    sed -i "${line}r $tmp" "$out"
    rm -f "$tmp"
}
