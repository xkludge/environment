export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_161.jdk/Contents/Home/

export GOPATH=$HOME/go

# Maximum number of history lines in memory
export HISTSIZE=500000
# Maximum number of history lines on disk
export HISTFILESIZE=500000
# Ignore duplicate lines
export HISTCONTROL=ignoredups:erasedups
# When the shell exits, append to the history file
#  instead of overwriting it
shopt -s histappend

# After each command, append to the history file
#  and reread it
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"


export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

alias ls='ls -GFh'
alias ll='ls -l'

function prompt {
  local BLACK="\[\033[0;30m\]"
  local BLACKBOLD="\[\033[1;30m\]"
  local RED="\[\033[0;31m\]"
  local REDBOLD="\[\033[1;31m\]"
  local GREEN="\[\033[0;32m\]"
  local GREENBOLD="\[\033[1;32m\]"
  local YELLOW="\[\033[0;33m\]"
  local YELLOWBOLD="\[\033[1;33m\]"
  local BLUE="\[\033[0;34m\]"
  local BLUEBOLD="\[\033[1;34m\]"
  local PURPLE="\[\033[0;35m\]"
  local PURPLEBOLD="\[\033[1;35m\]"
  local CYAN="\[\033[0;36m\]"
  local CYANBOLD="\[\033[1;36m\]"
  local WHITE="\[\033[0;37m\]"
  local WHITEBOLD="\[\033[1;37m\]"
  local RESETCOLOR="\[\e[00m\]"

  export PS1="\n$RED\u $PURPLE@ $GREEN\w $RESETCOLOR$GREENBOLD\$(node --version 2> /dev/null) \$(git branch 2> /dev/null | grep \* | head -n1) $CYAN[\#] → $RESETCOLOR"
  export PS2=" | → $RESETCOLOR"
}

function title () {
    export PREV_COMMAND=${@}
    echo -ne "\033]0;${PREV_COMMAND}\007"
    export PREV_COMMAND=${PREV_COMMAND}' | '
}

function flushdns() {
       sudo killall -HUP mDNSResponder;sudo killall mDNSResponderHelper;sudo dscacheutil -flushcache
}

function cvenv27() {
    virtualenv -p /usr/bin/python2.7 venv
    source venv/bin/activate
}

function activate() {
     source venv/bin/activate
}

function cvenv36() {
    virtualenv -p /usr/bin/python3.6 venv
    source venv/bin/activate
}


function movtogif() {
    if [ "$1" == "" ];
    then
        echo "please param a mov"
        exit 1
    fi

    ffmpeg -i $1 -s 1024x768 -pix_fmt rgb24 -r 10 -f gif - | gifsicle --optimize=3 --delay=3 > $1.gif
}

function redText() {
    RED='\033[0;31m'
    NC='\033[0m' # No Color
    echo -e  "${RED}$1${NC}"
}

function install() {
    say 'Setup starting'

    echo "Installing nvm"
    if [ -z ~/.nvm ];
    then
        mkdir -p ~/.nvm
    fi
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

    echo ""
    redText "Note to add ~/.nvm to your \$PATH"
    echo ""

    echo "Installing brew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    echo "nano goodies"
    git clone git@github.com:scopatz/nanorc.git ~/.nano
    echo "set tabsize 4" > ~/.nanorc
    echo "set tabstospaces" >> ~/.nanorc
        
    echo "brew Installing utils and dependencies"
    brew install awscli && brew update awscli
    brew install htop
    brew install iftop
    brew install wget
    brew install watchman
    brew install yarn
    brew install ffmpeg
    brew install gifsicle
}

export JVM_ARGS="-Xms2g -Xmx6g"

export HEAP="-Xms2g -Xmx6g"

prompt

export PATH="/usr/local/bin:/usr/local/sbin:~/bin:~/.nvm:/opt/homebrew/bin/:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
