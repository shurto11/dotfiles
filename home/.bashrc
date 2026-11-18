
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
# 色(エスケープシーケンスそのもの)。PS1 に直接書くときは \[ \] で、
# 1行目を組み立てるときは \001 \002 で囲んで、readline に幅として数えさせない
C_RESET=$'\e[0m'
C_FG_NAVY=$'\e[38;5;17m'
C_FG_BLACK=$'\e[38;5;16m'
C_FG_WHITE=$'\e[38;5;255m'
C_FG_GREEN=$'\e[38;5;72m'
C_FG_ORANGE=$'\e[38;5;209m'
C_BG_NAVY=$'\e[48;5;17m'
C_BG_WHITE=$'\e[48;5;255m'
C_BG_GREEN=$'\e[48;5;72m'
C_BG_ORANGE=$'\e[48;5;209m'
# Powerline の矢印 (U+E0B0)。ロケールに依存しないよう UTF-8 のバイト列で書く
ARROW=$'\xee\x82\xb0'
# アクティブでないペインで使う矢印 ❱ (U+2771)。Cica で半角幅なので fbterm でも欠けない
# (Powerline の細い矢印 U+E0B1 は全角幅でデザインされていて右半分が切れる)
ANGLE=$'\xe2\x9d\xb1'
# アイコン。fbterm は全角幅でデザインされた Cica のアイコンを1マスで切ってしまうため、
# 左右に分割した「Cica Split Icons」フォント(~/.local/share/fonts, fbtermrc で Cica の次に指定)
# の半角2文字を並べて全角1個分として出す
ICON_FOLDER=$'\xee\x80\x90\xee\x80\x91'   # nf-fa-folder  (U+F07B) -> U+E010 U+E011
ICON_LAPTOP=$'\xee\x80\xa0\xee\x80\xa1'   # nf-fa-laptop  (U+F109) -> U+E020 U+E021
ICON_CLOCK=$'\xee\x80\xae\xee\x80\xaf'    # nf-fa-clock_o (U+F017) -> U+E02E U+E02F

# プロンプトは出すたびに __ps1_status が組み立てる(1行目 __PS1_L1、2行目 __PS1_L2)。
# シングルクォートで書き、プロンプトを出すたびに変数を展開させる
PS1='${__PS1_L1}\n${__PS1_L2}'
# tmux でアクティブでないペイン(__PS1_ACTIVE=0)では、背景色を付けず、文字・アイコン・矢印を
# 各セグメントの色で描く。矢印は ❱ にして、前のセグメントの色と次のセグメントの色の2つを並べる
__PS1_ACTIVE=1

# 文字の表示幅を __CW に入れる(全角は2、それ以外は1)。
# アイコンと矢印(PUA)は fbterm も tmux も1マスとして扱うので1
__ps1_charw() {
    local n
    printf -v n '%d' "'$1"
    if (( n >= 0x1100 && (n <= 0x115F || (n >= 0x2E80 && n <= 0xA4CF) ||
          (n >= 0xAC00 && n <= 0xD7A3) || (n >= 0xF900 && n <= 0xFAFF) ||
          (n >= 0xFE30 && n <= 0xFE4F) || (n >= 0xFF00 && n <= 0xFF60) ||
          (n >= 0xFFE0 && n <= 0xFFE6) || n >= 0x1F300) )); then
        __CW=2
    else
        __CW=1
    fi
}

# 文字列の表示幅を __SW に入れる
__ps1_strw() {
    local s=$1 i
    __SW=0
    if [[ $s != *[![:ascii:]]* ]]; then __SW=${#s}; return; fi   # ASCII だけなら文字数そのまま
    for (( i = 0; i < ${#s}; i++ )); do
        __ps1_charw "${s:i:1}"
        (( __SW += __CW ))
    done
}

# 1行目を組み立てて __PS1_L1 に入れる。$1 = パス、$2 = 時刻、$3 = 端末の幅。
# 過去のプロンプトを描き直すときに同じものを組み立て直せるよう、値は引数で受け取る。
# 幅は「端末の幅 - 1」まで
# (最後の列まで埋めると readline が折り返したものとして数え、表示がずれることがあるため)。
#   全部入る             : そのまま
#   入らない             : 右から1文字ずつ切り捨てる
#   パスだけでも入らない : パスを複数行に折り返す(他のセグメントは出さない)
# 矢印は「前のセグメントの色を文字色、次のセグメントの色を背景色」にして繋ぐ。
# 色の切り替わりでは 前の色→濃紺→次の色 と矢印を2つ重ね、濃紺の矢印の縁取りを作る
__ps1_line1() {
    local path=$1 now=$2 max=$(( $3 - 1 ))
    local s=$'\001' e=$'\002'   # readline に「幅に数えない」と伝える印(\[ \] と同じ)
    local uh="$USER@${HOSTNAME%%.*}"

    __ps1_strw "$path"
    local pw=$__SW
    # パスのセグメント(" アイコン パス ")だけでも入らなければ折り返す。極端に狭いときは切り捨てる
    if (( pw + 5 > max && max >= 8 )); then
        __ps1_wrap_path "$path" "$max"
        return
    fi

    # (スタイル, 文字列) を左から順に並べる
    local -a st
    if (( __PS1_ACTIVE )); then
        st=(
            "$C_BG_WHITE$C_FG_BLACK"  " $ICON_FOLDER $path "
            "$C_BG_NAVY$C_FG_WHITE"   "$ARROW"
            "$C_BG_GREEN$C_FG_NAVY"   "$ARROW"
            "$C_FG_BLACK"             " $ICON_LAPTOP $uh "
            "$C_BG_NAVY$C_FG_GREEN"   "$ARROW"
            "$C_BG_ORANGE$C_FG_NAVY"  "$ARROW"
            "$C_FG_BLACK"             " $ICON_CLOCK $now "
            "$C_RESET$C_FG_ORANGE"    "$ARROW"   # 行末の矢印(端末の背景色の上にオレンジで描く)
        )
    else
        st=(
            "$C_RESET$C_FG_WHITE"     " $ICON_FOLDER $path "
            "$C_FG_WHITE"             "$ANGLE"
            "$C_FG_GREEN"             "$ANGLE"
            "$C_FG_GREEN"             " $ICON_LAPTOP $uh "
            "$C_FG_GREEN"             "$ANGLE"
            "$C_FG_ORANGE"            "$ANGLE"
            "$C_FG_ORANGE"            " $ICON_CLOCK $now "
            "$C_FG_ORANGE"            "$ANGLE"
        )
    fi
    local out= j t i c
    # 全体の幅: パス(pw+5) + 矢印2 + user@host(+5) + 矢印2 + 時刻(+5) + 行末の矢印1
    if (( pw + 5 + 2 + ${#uh} + 5 + 2 + ${#now} + 5 + 1 <= max )); then
        for (( j = 0; j < ${#st[@]}; j += 2 )); do out+=$s${st[j]}$e${st[j+1]}; done
        __PS1_L1_W=( $(( pw + 5 + 2 + ${#uh} + 5 + 2 + ${#now} + 5 + 1 )) )
    else
        # 入らないので、幅の上限に達するまで左から1文字ずつ出す
        local used=0
        for (( j = 0; j < ${#st[@]}; j += 2 )); do
            out+=$s${st[j]}$e
            t=${st[j+1]}
            for (( i = 0; i < ${#t}; i++ )); do
                c=${t:i:1}
                __ps1_charw "$c"
                (( used + __CW > max )) && break 2
                out+=$c
                (( used += __CW ))
            done
        done
        __PS1_L1_W=( "$used" )
    fi
    __PS1_L1=$out$s$C_RESET$e
}

# パスを幅 max に収まるよう複数行に折り返して __PS1_L1 に入れる。
# できるだけ「/」の直後で折り、1つの名前が1行に入らないときだけ途中で切る。
# 各行は同じ幅にそろえて白い長方形にし、入るなら最後の行の右に矢印を付ける。
__ps1_wrap_path() {
    local path=$1 max=$2 s=$'\001' e=$'\002'
    local lim=$(( max - 5 ))   # 行頭の " アイコン " (4) と行末の空白 (1) を除いた、パスに使える幅
    local -a lines=() widths=()
    local line= lw=0 rest=$path tok tw i c
    while [[ -n $rest ]]; do
        # 「/」までをひとかたまりにして詰めていく
        if [[ $rest == */* ]]; then tok=${rest%%/*}/; else tok=$rest; fi
        rest=${rest:${#tok}}
        __ps1_strw "$tok"
        tw=$__SW
        if (( lw + tw <= lim )); then
            line+=$tok; (( lw += tw )); continue
        fi
        if (( lw > 0 )); then
            lines+=("$line"); widths+=("$lw"); line= lw=0
        fi
        if (( tw <= lim )); then
            line=$tok; lw=$tw; continue
        fi
        # 1行に入らない長い名前は文字単位で切る
        for (( i = 0; i < ${#tok}; i++ )); do
            c=${tok:i:1}
            __ps1_charw "$c"
            if (( lw + __CW > lim )); then
                lines+=("$line"); widths+=("$lw"); line= lw=0
            fi
            line+=$c; (( lw += __CW ))
        done
    done
    (( lw > 0 )) && { lines+=("$line"); widths+=("$lw"); }

    local bw=0 w k pad out= sty arrow
    for w in "${widths[@]}"; do (( w > bw )) && bw=$w; done
    if (( __PS1_ACTIVE )); then
        sty=$C_BG_WHITE$C_FG_BLACK arrow=$ARROW
    else
        sty=$C_RESET$C_FG_WHITE arrow=$ANGLE
    fi
    __PS1_L1_W=()
    for (( k = 0; k < ${#lines[@]}; k++ )); do
        printf -v pad '%*s' $(( bw - widths[k] )) ''
        (( k > 0 )) && out+=$'\n'
        if (( k == 0 )); then
            out+="$s$sty$e $ICON_FOLDER ${lines[k]}$pad "
        else
            out+="$s$sty$e    ${lines[k]}$pad "   # 2行目以降はパスの頭にそろえる
        fi
        out+=$s$C_RESET$e
        __PS1_L1_W+=( $(( bw + 5 )) )
    done
    # 長方形の幅は bw+5。矢印の1マスが残っていれば最後の行に付ける
    if (( bw + 5 < max )); then
        out+="$s$C_FG_WHITE$e$arrow$s$C_RESET$e"
        (( __PS1_L1_W[-1] += 1 ))
    fi
    __PS1_L1=$out
}

# 2行目を組み立てて __PS1_L2 に入れる。$1 = 直前のコマンドの終了ステータス。
# 成功なら水色、失敗なら赤のブロック。頭の矢印は1行目の区切りと同じ濃紺
__ps1_line2() {
    local s=$'\001' e=$'\002' bg fg
    if (( $1 == 0 )); then
        bg=$'\e[48;5;75m' fg=$'\e[38;5;75m'     # 成功: 水色 #61C3F9
    else
        bg=$'\e[48;5;210m' fg=$'\e[38;5;210m'   # 失敗: 赤 #FB9890
    fi
    if (( __PS1_ACTIVE )); then
        __PS1_L2="$s$bg$C_FG_NAVY$e$ARROW$s$C_FG_BLACK$e \$ $s$C_RESET$fg$e$ARROW$s$C_RESET$e "
    else
        __PS1_L2="$s$C_RESET$fg$e$ANGLE \$ $ANGLE$s$C_RESET$e "
    fi
}

# ---- ペインの幅が変わったら、表示中のプロンプトをその場で描き直す(tmux の中だけ) ----
# readline は入力待ちの最初に展開したプロンプトを持ち続けるので、変数を変えても描き直されない。
# そこで、幅が変わったら(SIGWINCH)次の手順で新しいプロンプトを出し直す:
#   1. trap が tmux send-keys で、普段は打たないキー列 \e[9999~ を自分のペインへ送る
#   2. そのキー列のマクロが「入力中の行とカーソル位置を退避して空にする → 空のまま Enter →
#      退避した行を戻す」を実行する
#   3. 空の Enter で PROMPT_COMMAND が走るので、古いプロンプトを消してから新しい幅で組み立てる
__ps1_redraw_save() {
    __PS1_SAVED_LINE=$READLINE_LINE __PS1_SAVED_POINT=$READLINE_POINT
    READLINE_LINE= READLINE_POINT=0
    __PS1_REDRAW=1 __PS1_FOCUS_OFF=
}
__ps1_redraw_restore() {
    READLINE_LINE=$__PS1_SAVED_LINE READLINE_POINT=$__PS1_SAVED_POINT
}
bind -x '"\e[9998~": __ps1_redraw_save'
bind -x '"\e[9997~": __ps1_redraw_restore'
bind '"\e[9999~": "\e[9998~\C-j\e[9997~"'

__ps1_request_redraw() {
    # 入力待ちのときだけ(コマンド実行中はシェルに SIGWINCH が来ないが、念のため)。
    # コピーモード中に送るとキーがコピーモードの操作として解釈されるので送らない
    [[ -n $TMUX && -n $TMUX_PANE && $__PS1_AT_PROMPT == 1 ]] || return
    [[ $(tmux display -p -t "$TMUX_PANE" '#{pane_in_mode}') == 0 ]] || return
    tmux send-keys -t "$TMUX_PANE" -H 1b 5b 39 39 39 39 7e   # \e[9999~
}
trap __ps1_request_redraw WINCH
# コマンドを実行する直前に「入力待ちではない」印を付ける(PS0 は実行直前に展開される。
# 長さ 0 の部分文字列にして何も表示せず、算術式の代入だけを効かせる)
PS0='${PS1:0:$((__PS1_AT_PROMPT=0))}'

# ---- ペインのフォーカスが変わったら、アクティブかどうかに合わせて描き直す(tmux の中だけ) ----
# フォーカス通知(\e[?1004h)を有効にしたペインには、tmux がフォーカスが外れたら \e[O、
# 来たら \e[I を送ってくる。これを readline で受けて、変わっていたら上と同じ手順で描き直す。
# 通知は入力待ちの間だけ有効にする(コマンド実行中のプログラムに \e[I が入力されないよう、
# 実行直前に PS0 で __PS1_FOCUS_OFF を出して止める。描き直しの空の Enter では空にして止めない)。
# 止めていた間の変化は届かず、有効にしても今の状態は送られてこないので、
# コマンドの後は tmux に問い合わせる(__ps1_tmux_sync)
__ps1_focus() {
    [[ $1 == "$__PS1_ACTIVE" ]] && return
    __PS1_ACTIVE=$1
    __ps1_request_redraw
}
__ps1_tmux_sync() {
    printf '\e[?1004h'
    local r
    r=$(tmux display -p -t "$TMUX_PANE" '#{pane_active}#{window_active} #{pane_width}')
    case ${r%% *} in
        11 | '') __PS1_ACTIVE=1 ;;   # 問い合わせに失敗したときもアクティブとして描く
        *) __PS1_ACTIVE=0 ;;
    esac
    # ついでに幅も合わせる。シェルの起動中にペインの幅が変わると、COLUMNS は次に
    # 外部コマンドを実行するまで古いまま残り、1行目がはみ出してしまうため
    [[ ${r##* } =~ ^[0-9]+$ ]] && COLUMNS=${r##* }
}
if [[ -n $TMUX && -n $TMUX_PANE ]]; then
    # \e[I / \e[O に直接 bind -x すると、Ctrl+R の検索中に届いたとき
    # 「cannot find keymap for command」のエラーになるので、マクロで別のキー列に置き換えてから受ける
    bind -x '"\e[9996~": __ps1_focus 1'
    bind -x '"\e[9995~": __ps1_focus 0'
    bind '"\e[I": "\e[9996~"'
    bind '"\e[O": "\e[9995~"'
    PS0+='${__PS1_FOCUS_OFF}'
    trap 'printf "\e[?1004l"' EXIT
fi

# 古いプロンプト(1行目 + 2行目)を消す。カーソルは空の Enter で2行目の次の行にいる。
# 1行目の各行は tmux が今の幅で折り返し直している(リフロー)ので、その行数で数える
__ps1_erase_old() {
    local cols=${COLUMNS:-80} rows=1 w   # 1 = 2行目
    for w in "${__PS1_L1_W[@]}"; do (( rows += w > cols ? (w + cols - 1) / cols : 1 )); done
    # 画面の左上から \e[J で消すと、tmux(scroll-on-clear)は消さずに履歴へ押し出してしまう。
    # 2列目から \e[J で消し、残った1列目は \e[K で消す
    printf '\e[%dA\e[2G\e[J\r\e[K' "$rows"
}

# ---- 画面に残っている過去のプロンプトも、今の見た目に描き直す(tmux の中だけ) ----
# readline が描き直せるのは今のプロンプトだけなので、過去のものは自分で上書きする。
# プロンプトを出すたびに組み立てに使った値(パス・時刻・終了ステータス・幅)を覚えておき、
# 見た目が変わったら次の手順で描き直す:
#   1. tmux から画面の文字(色なし)を取り、覚えているプロンプトと文字が一致する場所を探す。
#      矢印 ▶ と ❱ は同じ文字とみなす(見た目が違っても文字の並びと幅は同じ)
#   2. 一致した場所に、今の見た目で組み立て直したものを上書きし、カーソルを元に戻す
# 文字が一致しないもの(clear で消えた、ほかの出力で上書きされた)には何も描かない。
# スクロールして画面の外(tmux の履歴)に出たものは書き換えられない。
# ペインの幅が変わって tmux が折り返し直している(リフロー)ものは、今の幅で折り返して比べる
__PS1_PAINTED=1                                    # 過去のプロンプトが今どちらの見た目か
__PS1_HP=() __PS1_HN=() __PS1_HS=() __PS1_HC=()    # 覚えているプロンプト: パス、時刻、ステータス、幅
__PS1_HMAX=50                                      # 覚えておく数(1画面に収まる数より多めに)

# プロンプトを覚える。$1..$4 = パス、時刻、ステータス、幅。$5 が 1 なら一番新しいものを置き換える
__ps1_hist_put() {
    local i=${#__PS1_HP[@]}
    (( $5 && i > 0 )) && (( i-- ))
    __PS1_HP[i]=$1 __PS1_HN[i]=$2 __PS1_HS[i]=$3 __PS1_HC[i]=$4
    if (( ${#__PS1_HP[@]} > __PS1_HMAX )); then
        __PS1_HP=("${__PS1_HP[@]:1}") __PS1_HN=("${__PS1_HN[@]:1}")
        __PS1_HS=("${__PS1_HS[@]:1}") __PS1_HC=("${__PS1_HC[@]:1}")
    fi
}

# 文字列 $1 から \001..\002 で囲んだ部分(色)を除き、▶ を ❱ にそろえて、行末の空白を落としたものを __PT に入れる
__ps1_plain() {
    local rest=$1
    __PT=
    while [[ $rest == *$'\001'* ]]; do
        __PT+=${rest%%$'\001'*}
        rest=${rest#*$'\002'}
    done
    __PT+=$rest
    __PT=${__PT//"$ARROW"/"$ANGLE"}
    __PT=${__PT%"${__PT##*[! ]}"}
}

# 表示幅 $2 の文字列 $1(色付き)を、tmux と同じく幅 $3 で折り返して、1行ずつ __ROWS に足す
# (全角の文字が行末に入りきらないときは次の行に送る)。
# 2行目以降の頭には、それまでの色をすべて付け直して、その行だけで描けるようにする
__ps1_split_rows() {
    local str=$1 w=$2 cols=$3 row= esc= used=0 i c
    if (( w <= cols )); then __ROWS+=("$str"); return; fi
    for (( i = 0; i < ${#str}; i++ )); do
        c=${str:i:1}
        if [[ $c == $'\001' ]]; then   # 色(\001..\002)は幅に数えない
            c=${str:i}; c=${c%%$'\002'*}$'\002'
            esc+=$c row+=$c
            (( i += ${#c} - 1 ))
            continue
        fi
        __ps1_charw "$c"
        if (( used + __CW > cols )); then __ROWS+=("$row"); row=$esc used=0; fi
        row+=$c; (( used += __CW ))
    done
    __ROWS+=("$row")
}

# 画面に残っている過去のプロンプトを今の見た目(__PS1_ACTIVE)で描き直す。
# $1 が 1 なら一番新しいもの(描き直し中の今のプロンプト)は除く
__ps1_repaint_past() {
    local last=$(( ${#__PS1_HP[@]} - 1 - $1 ))
    (( last >= 0 )) || return

    # 画面を取る前に、ここまでに書いた出力を tmux が全部処理し終えるのを待つ
    # (コマンドの出力が残っていると、取った後で画面がスクロールして位置がずれる)。
    # 挿入モード(\e[4h)を立て、tmux 側で立ったのが見えたら、それより前の出力は処理済み。
    # 挿入モードは文字を書く前に戻す
    local -a scr
    local i
    printf '\e[4h'
    for (( i = 0; i < 50; i++ )); do
        mapfile -t scr < <(tmux display -p -t "$TMUX_PANE" \
            '#{insert_flag} #{alternate_on} #{cursor_y} #{pane_width}' \; capture-pane -p -t "$TMUX_PANE")
        [[ ${scr[0]} == 1\ * ]] && break
        sleep 0.01
    done
    printf '\e[4l'
    local flag alt cy cols
    read -r flag alt cy cols <<< "${scr[0]}"
    [[ $flag == 1 && $alt == 0 ]] || return
    scr=("${scr[@]:1}")

    # 2行目の頭(「▶ $ ▶」か「❱ $ ❱」)がある行を、下から順に集める
    local -a cand=()
    local r t l2head="$ANGLE \$ $ANGLE"
    for (( r = cy; r >= 0; r-- )); do
        t=${scr[r]//"$ARROW"/"$ANGLE"}
        [[ $t == "$l2head"* ]] && cand+=("$r")
    done

    # 新しいプロンプトから順に、まだ使っていない 2行目の候補の上に 1行目が一致するところを探す。
    # 画面の上端で 1行目が一部だけ見えているものは、見えている行が一致すれば、その行だけ描く
    local __PS1_L1 __PS1_L1_W __PS1_L2   # 今のプロンプトの値を壊さないように
    local -a lines __ROWS
    local ci=0 k j q n top ok out=$'\e7' rest
    for (( k = last; k >= 0 && ci < ${#cand[@]}; k-- )); do
        __ps1_line1 "${__PS1_HP[k]}" "${__PS1_HN[k]}" "${__PS1_HC[k]}"
        __ps1_line2 "${__PS1_HS[k]}"
        # 1行目を改行で分ける(パスを折り返したときは複数行)
        lines=() rest=$__PS1_L1
        while [[ $rest == *$'\n'* ]]; do lines+=("${rest%%$'\n'*}"); rest=${rest#*$'\n'}; done
        lines+=("$rest")
        __ROWS=()   # 1行目を、今の画面での行に分けたもの
        for (( q = 0; q < ${#lines[@]}; q++ )); do
            __ps1_split_rows "${lines[q]}" "${__PS1_L1_W[q]}" "$cols"
        done
        n=${#__ROWS[@]}
        for (( j = ci; j < ${#cand[@]}; j++ )); do
            top=$(( cand[j] - n ))
            (( top + n - 1 >= 0 )) || continue   # 1行目が1行も見えていない
            ok=1
            for (( q = 0; q < n; q++ )); do
                (( top + q < 0 )) && continue
                t=${scr[top + q]//"$ARROW"/"$ANGLE"}
                t=${t%"${t##*[! ]}"}
                __ps1_plain "${__ROWS[q]}"
                [[ $t == "$__PT" ]] || { ok=0; break; }
            done
            (( ok )) || continue
            for (( q = 0; q < n; q++ )); do
                (( top + q >= 0 )) && out+=$'\e['$(( top + q + 1 ))';1H'${__ROWS[q]//[$'\001\002']/}
            done
            out+=$'\e['$(( cand[j] + 1 ))';1H'${__PS1_L2//[$'\001\002']/}
            ci=$(( j + 1 ))
            break
        done
    done
    # 画面の一番上に 2行目だけが残っている(1行目が画面の外に出た)ものは、どのプロンプトか
    # 確かめられないので、成功か失敗かを画面の色(赤 = 210 を使っているか)から読み取って描く
    if (( ${#cand[@]} > ci && cand[-1] == 0 )); then
        local st=0 re='[34]8;5;210[;m]'
        [[ $(tmux capture-pane -p -e -t "$TMUX_PANE" -S 0 -E 0) =~ $re ]] && st=1
        __ps1_line2 "$st"
        out+=$'\e[1;1H'${__PS1_L2//[$'\001\002']/}
    fi
    printf '%s' "$out"$'\e[0m\e8'
}

# プロンプトの1行目と2行目を組み立てる。
# $? を他の処理に上書きされる前に受け取るため、PROMPT_COMMAND の先頭で呼ぶ。
# 描き直しのときは空の Enter なので、前回のステータスを使い、古いプロンプトを消す
__ps1_status() {
    local st=$? redraw=0 path now
    if [[ $__PS1_REDRAW ]]; then
        st=$__PS1_LAST_ST redraw=1
        __ps1_erase_old
        __PS1_REDRAW=
    else
        __PS1_LAST_ST=$st
        [[ -n $TMUX && -n $TMUX_PANE ]] && __ps1_tmux_sync
    fi
    # 見た目が変わっていたら(フォーカスが変わった、コマンドの実行中に変わっていた)、過去のものも描き直す
    if [[ -n $TMUX && -n $TMUX_PANE ]] && (( __PS1_PAINTED != __PS1_ACTIVE )); then
        __ps1_repaint_past "$redraw"
        __PS1_PAINTED=$__PS1_ACTIVE
    fi
    case $PWD in   # \w と同じく、ホーム以下は ~ で表す
        "$HOME" | "$HOME"/*) path="~${PWD#"$HOME"}" ;;
        *) path=$PWD ;;
    esac
    printf -v now '%(%H:%M:%S)T' -1
    __ps1_line1 "$path" "$now" "${COLUMNS:-80}"
    __ps1_line2 "$st"
    [[ -n $TMUX && -n $TMUX_PANE ]] && __ps1_hist_put "$path" "$now" "$st" "${COLUMNS:-80}" "$redraw"
    __PS1_AT_PROMPT=1 __PS1_FOCUS_OFF=$'\e[?1004l'
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
