# ~/.bashrc: executed by bash(1) for non-login shells.

# HISTORY
# append to the history file, don't overwrite it
shopt -s autocd checkhash checkwinsize cmdhist globstar histappend
# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
HISTFILE=$HOME/.hist_bash
HISTFILESIZE=
HISTSIZE=
HISTTIMEFORMAT="%F %T "

# END HISTORY

# NAVIGATION
# \e[A arrow up
# \e[B arrow down
# \e[C arrow right
# \e[D arrow left
bind '"\e[A":history-search-backward' 2>/dev/null # suppress interactive shell warnings
bind '"\e[B":history-search-forward' 2>/dev/null

# \e[1;5A Ctrl + arrow up
# \e[1;5B Ctrl + arrow down
# \e[1;5C Ctrl + arrow right
# \e[1;5D Ctrl + arrow left
bind '"\e[1;5A":history-substring-search-forward' 2>/dev/null
bind '"\e[1;5B":history-substring-search-backward' 2>/dev/null
bind '"\e[1;5C":forward-word' 2>/dev/null
bind '"\e[1;5D":backward-word' 2>/dev/null

# \e[1;2A Shift + arrow up
# \e[1;2B Shift + arrow down
# \e[1;2C Shift + arrow right
# \e[1;2D Shift + arrow left
bind '"\e[1;2A":forward-search-history' 2>/dev/null # Ctrl+s
bind '"\e[1;2B":reverse-search-history' 2>/dev/null # Ctrl+r
bind '"\e[1;2C":end-of-line' 2>/dev/null
bind '"\e[1;2D":beginning-of-line' 2>/dev/null

set completion-ignore-case on
set show-all-if-ambiguous on
set completion-query-items 30
set editing-mode emacs
# NAVIGATION END

# COLORS
RED=""
YELLOW=""
GREEN=""
BLUE=""
CYAN=""
PURPLE=""
LIGHT_RED=""
LIGHT_GREEN=""
WHITE=""
LIGHT_GRAY=""
NORMAL=""
# check if stdout is a terminal...
if test -t 1; then
  # see if it supports colors...
  force_color_prompt=yes
  color_prompt=yes
  export TERM="xterm-256color"
  export LS_COLORS=$LS_COLORS:"di=01;35"

  RED="\[\033[0;31m\]"
  YELLOW="\[\033[1;33m\]"
  GREEN="\[\033[0;32m\]"
  BLUE="\[\033[1;34m\]"
  PURPLE="\[\033[0;35m\]"
  CYAN="\[\033[0;36m\]"
  LIGHT_RED="\[\033[1;31m\]"
  LIGHT_GREEN="\[\033[1;32m\]"
  WHITE="\[\033[1;37m\]"
  LIGHT_GRAY="\[\033[0;37m\]"
  NORMAL="\[\e[0m\]"
  # enable color support of ls and also add handy aliases
  bind 'set colored-completion-prefix on'
  bind 'set colored-stats on'
  alias ls='ls --color=auto'
  alias less='less -R'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# ALIASES
export PERS_DIR='/data/work'
alias less="less --LONG-PROMPT --no-init --quit-at-eof --quit-if-one-screen --quit-on-intr"
export PAGER='less -SRXF'

alias arch='uname -m'
alias ll='ls -ahlF --time-style=long-iso --group-directories-first'
alias la='ls -A'
alias home_pr='cd $PERS_DIR/home'
alias compress_jpeg="find ./ -iname '*.jpg' -or -iname '*.jpeg' -type f -size +100k -exec jpeg-recompress --quality high --method ssim --accurate --min 70 {} {} \;"
alias compress_png="find ./ -iname '*.png' -type f -size +100k -exec optipng {} \;"
alias check_adb='adb devices -l'


# CUSTOM FUNCTIONS
command_exists () {
  command -v "$1"  > /dev/null 2>&1;
}

# SUDO
SUDO=''
if [[ $EUID -ne 0 ]] && command_exists sudo ; then
  complete -cf sudo
  SUDO='sudo'
fi
# END SUDO

# COMPLETIONS
if command_exists jira
then
  eval "$(jira --completion-script-bash)"
fi
# END COMPLETIONS

project_folders="$PERS_DIR/projects"
prj () {
  cd $project_folders
  if [ ! -z $1 ]; then
    cd $1
  fi
}
_prj()
{
  local cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "$(ls $project_folders)" -- $cur) )
}
complete -F _prj prj

backup_dir="$PERS_DIR/backup"
backup () {
  cd $backup_dir
  if [ ! -z $1 ]; then
    cd $1
  fi
}
_backup()
{
  local cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "$(ls $backup_dir)" -- $cur) )
}
complete -F _backup backup

## SWAP
soff () {
  eval "$SUDO swapoff $(swapon --noheadings --show=NAME)"
}

son () {
  eval "$SUDO swapon /swapfile"
}
## END SWAP

## ARCHIVES
extract () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)        tar xjf $1        ;;
      *.tar.gz)         tar xzf $1        ;;
      *.bz2)            bunzip2 $1        ;;
      *.rar)            unrar x $1        ;;
      *.gz)             gunzip $1         ;;
      *.tar)            tar xf $1         ;;
      *.tbz2)           tar xjf $1        ;;
      *.tgz)            tar xzf $1        ;;
      *.zip)            unzip $1          ;;
      *.Z)              uncompress $1     ;;
      *.7z)             7zr e $1          ;;
      *)                echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

zipin () {
  for f in $(ls -A);
    do
    if [ -f "$f" ]; then
      case $f in
        *.zip)       echo "$f already zipped"  ;;
        *)           zip -9 $f.zip $f && rm $f ;;
      esac
    fi;
  done
}
## END ARCHIVES

file_replace() {
  for file in $(find . -type f -name "$1*"); do
    mv $file $(echo "$file" | sed "s/$1/$2/");
  done
}

# convert jpg files to single pdf
con_jpg_pdf (){
  convert *.jpg $@.pdf
}

# convert png files to single pdf
con_png_pdf (){
  convert *.png $@.pdf
}

## X11 VS WAYLAND
disable_x11 (){
  systemctl --user disable clipmenud.service
  systemctl --user disable kbdd.service
  systemctl --user disable dunst.service
}

enable_x11 (){
  systemctl --user enable clipmenud.service
  systemctl --user enable kbdd.service
  systemctl --user enable dunst.service
}
## END X11 VS WAYLAND

## TOGGLE HDMI SOUND
hdmi_sound_on (){
  pactl --server "unix:$XDG_RUNTIME_DIR/pulse/native" set-card-profile 0 output:hdmi-stereo+input:analog-stereo
}
hdmi_sound_off (){
  pactl --server "unix:$XDG_RUNTIME_DIR/pulse/native" set-card-profile 0 output:analog-stereo+input:analog-stereo
}

return_root (){
  xhost si:localuser:root
}

mkcd() {
  folder=$@
  mkdir -p $folder
  cd $folder
}
# END CUSTOM FUNCTIONS

# IMPORT ADDITIONAL FILES
## CUSTOM FUNCS
if [ -f ~/.func.bash ]; then
  fpath+=~/.func.bash
  . ~/.func.bash
fi

## CUSTOM ALIASES AND EXPORTS
if [ -f ~/.aliases.bash ]; then
  . ~/.aliases.bash
fi

## USER SPECIFIC BINARIES
LOCAL_BIN=$HOME/.local/bin
if [ -d $LOCAL_BIN ]; then
  export PATH=$PATH:$LOCAL_BIN
fi

if [ -f /etc/profile.d/vte.sh ]; then
  . /etc/profile.d/vte.sh
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
# END IMPORT

# PACKAGE MANAGERS
if command_exists pacman ; then
  paclist() {
    pacman -Qq | fzf --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | less)'
  }

  alias p="$SUDO pacman"
  alias pql='pacman -Ql'
  alias pqs='pacman -Qs'
  alias pas='pacman -Ss'
  alias upg='p -Syu'
  alias pii='pacman -Sii'
  pai() {
    $SUDO pacman -S --needed $@
    rehash
  }
  alias par='p -Rs'
  if command_exists yay ; then
    alias yay='yay --aur --editmenu --builddir $PERS_DIR/bb'
    alias upy='yay -Syua'
    alias yss='yay -Ss'
    alias ya='yay -Sa'
    alias yii='yay -Sii'
  fi

  recovery-pacman() {
    pacman "$@"  \
         --log /dev/null   \
         --noscriptlet     \
         --dbonly          \
         --force           \
         --nodeps          \
         --needed
  }
fi

if command_exists apt ; then
  alias a="$SUDO apt"
  alias pas='apt search'
  alias upd='a update'
  alias upy='a upgrade'
  alias upl='apt list --upgradable'
  alias upg='upd && sleep 2 && upl && sleep 2 && upy'
  alias pai='a install'
  alias par='a remove'
  alias pql="dpkg-query -L"
  alias aar="$SUDO add-apt-repository"
fi

if command_exists yum ; then
  alias y="$SUDO yum"
  alias upg='yum upgrade'
  alias pas='yum search'
  alias pai='yum install'
  alias par='yum remove'
fi
# END PACKAGE MANAGERS

# SYSTEM TOOLS
## VMs
### VAGRANT
if command_exists vagrant ; then
  alias vup='vagrant up'
  alias vh='vagrant halt'
  alias vsus='vagrant suspend'
  alias vre='vagrant reload'
  alias vs='vagrant ssh'
fi

### DOCKER
if command_exists docker ; then
  alias d='docker'
  alias dc='docker-compose'
  alias dl='docker-compose logs --tail 15'
  alias drun='docker-compose stop && docker-compose run --service-ports'
  alias dst='d stop $(d ps -q)'
  alias drm='d rm $(d ps -aq)'
  alias dvrm='d volume rm $(d volume ls -q)'
  drmin () {
    for img in $(d images | rg -i 'none' | awk '{print $3}'); do
      docker rmi $img
    done
  }
  d_exec() {
    docker exec -it $1 sh -c "stty cols $COLUMNS rows $LINES && sh -l";
  }
  export d_exec;
  d_ip() {
    doc_ip=$(ip a show docker0 | grep "inet " | awk '{split($2, a, "/"); print a[1]}')
    export DOCKER_HOST_IP=$doc_ip
  }
  export d_ip
fi

### KUBERNETES
if command_exists kubectl ; then
  alias k='kubectl'
  alias kapr='kubectl api-resources'
  if command_exists kubectx ; then
    alias ktx='kubectx'
  fi
  if command_exists kubens ; then
    alias kns='kubens'
  fi
  # alias k9s_cont_namesp='k9s --context <context> -n <namespace>'
  # pod_pf() {
  #   context=""
  #   namespace=""
  #   pod=$(kubectl get pod -l name=<pod name> \
  #                         --context $context                     \
  #                         -n $namespace                          \
  #                         -o jsonpath="{.items[0].metadata.name}")
  #   echo "pod is $pod"
  #   kubectl port-forward $pod --context $context -n $namespace 8000:8000
  # }
fi

if command_exists aws ; then
  alias aelogin='aws ecr get-login --region eu-central-1'
  if command_exists saml2aws ; then
    export SAML2AWS_SESSION_DURATION=36000
    alias sl='saml2aws login -a default -p default -r eu-central-1 --skip-prompt'
  fi
fi
## END VM's

## MEDIA TOOLS
if command_exists youtube-dl ; then
  alias ytdl='youtube-dl'
  alias ytb='ytdl -f "bestvideo[height<=1080]"+bestaudio' # --external-downloader aria2c --external-downloader-args "-x 10 -s 10"'
  alias ytm='ytdl -f bestaudio -x'
  alias ytlf='ytdl --list-formats'
fi

if command_exists aria2c ; then
  alias a2c='aria2c -x 10 -s 10'
fi

if command_exists ffplay ; then
  alias play='ffplay -nodisp -autoexit'
fi
## END MEDIA TOOLS

## EDITORS
if command_exists vim; then
  alias v='vim'
  export EDITOR='vim'
fi
if command_exists emacs ; then
  alias em='emacs -nw'
  alias e='emacs -nw'
  alias sem="$SUDO emacs -nw"
  export EDITOR='editor-run'
fi
## END EDITORS

## FILE MANAGERS
if command_exists mc ; then
  alias smc="$SUDO mc"
fi

if command_exists vifm ; then
  alias vf="vifm"
  alias svf="$SUDO vifm"
  if [ -n "$INSIDE_VIFM" ]; then
    INSIDE_VIFM="[V]"
  fi
fi

if command_exists nnn ; then
  alias nnn='nnn -d'
  export NNN_USE_EDITOR=1
  export NNN_CONTEXT_COLORS='2745'
  export NNN_COPIER=$(which xsel)
  export NNN_NOTE=/opt/work/backup/notes
  export NNN_OPS_PROG=1
fi
## END FILE MANAGERS

if command_exists systemctl ; then
  alias ssystemctl="$SUDO systemctl"
fi

if command_exists git ; then
  alias g='git'
  alias pla='g pull'
  alias pll='pla origin'
  alias psh='g push origin'
  alias gst='g status'
  alias gco='g checkout'
  alias gadd='g add'
  alias gcmt='g commit -m'
fi

if command_exists tmux ; then
  alias tm='tmux attach || tmux new'
fi

if command_exists qt5ct ; then
  export QT_QPA_PLATFORMTHEME="qt5ct"
  export QT_PLATFORM_PLUGIN="qt5ct"
fi

if command_exists clipmenud ; then
  export CM_LAUNCHER=bemenu
  export CM_DIR=$HOME/.cache/.clipmenud
fi

if command_exists bemenu ; then
  export BEMENU_OPTS='-I 0 -i --fn "Hack:26" --nb "#1e1e1e" --nf "#c0f440" --sf "#1e1e1e" --sb "#f4800d" --tb "#d7dd90" --tf "#111206" --hb "#49088c" --hf "#c2fbd3"'
fi

if command_exists reflector ; then
  alias gen_mirror='reflector --ipv4 --country Germany --age 12 -p https -l 10 --sort score --save /tmp/mirrorlist'
  alias gen_rsync='reflector --ipv4 --country Germany --age 12 -p rsync -l 10 --sort score --save /tmp/powerpill'
fi
# END SYSTEM TOOLS

# PROGRAMM LANGUAGES
## RUST

if command_exists cargo || [ -d $HOME/.rustup ]; then
  if [ ! -d $HOME/.cargo/bin ]; then
    mkdir -p $HOME/.cargo/bin
  fi
  export PATH=$PATH:$HOME/.cargo/bin
  alias crn='cargo run'
  alias cup='cargo update'
  alias cbd='cargo build'
  alias cbr='cargo build --release'
  if ! command_exists cargo-expand; then
    cargo install cargo-expand
  fi
  if ! command_exists cargo-audit; then
    cargo install cargo-audit
  fi
  if ! command_exists cargo-outdated; then
    cargo install cargo-outdated
  fi
fi

if [ -d /usr/src/rust ]; then
  export RUST_SRC_PATH=/usr/src/rust/src
fi

if command_exists bat ; then
  alias ct='bat'
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

if ! command_exists tldr ; then
  echo "install tealdeer"
fi

if ! command_exists rg ; then
  echo "install ripgrep"
else
  export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc
fi

if command_exists sk ; then
  alias fzf='sk'
  if [[ -d /usr/share/skim/completion.bash ]]; then
    source /usr/share/skim/completion.bash
  fi
  gdelbrs() {
    git branch |
      rg --invert-match '\*' |
      cut -c 3- |
      sk --multi --preview="git log {} --" |
      xargs --no-run-if-empty git branch --delete --force
  }
else
  echo "install sk"
fi

if command_exists zoxide; then
  eval "$(zoxide init --no-aliases zsh)"
  alias j='__zoxide_z' # cd to highest ranked directory matching path
  alias ja='__zoxide_za' # add path to the database
  alias ji='__zoxide_zi' # cd with interactive selection using fzf
  alias jr='__zoxide_zr' # remove path from the database
else
  echo "Please install zoxide"
fi

if command_exists lsd; then
  alias ls='lsd'
  alias ll='ls -ahlF --group-dirs=first'
fi
## END RUST

## GO
go16_path=/usr/lib/go-1.16/bin
if [ -d $go16_path ]; then
  export PATH=$PATH:$go16_path
fi

if command_exists go ; then
  export GOPATH=$HOME/go
  export PATH=$PATH:$GOPATH/bin
  if [ -d $GOPATH/goprojects ]; then
    export GOPATH=$GOPATH:$GOPATH/goprojects
  fi
fi

if command_exists fzf ; then
  gdelbrf() {
    git branch |
      rg --invert-match '\*' |
      cut -c 3- |
      fzf --multi --preview="git log {} --" |
      xargs --no-run-if-empty git branch --delete --force
  }
else
  echo "install fzf"
fi
if command_exists lf ; then
  lfcd () {
      tmp="$(mktemp)"
      lf -last-dir-path="$tmp" "$@"
      if [ -f "$tmp" ]; then
          dir="$(cat "$tmp")"
          rm -f "$tmp"
          [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
      fi
  }
  bind '"^O":lfcd'
fi
## END GO

## SCALA
if [ -d /usr/share/scala ]; then
  export SCALA_HOME=/usr/share/scala
  export PATH=$PATH:$SCALA_HOME/bin
fi

if command_exists scala ; then
  alias s='scala'
  alias sc='scalac'
  srun() {
    name=$@
    echo "Start compilation for $name"
    scalac "$name.scala"
    echo "Compilation done"
    scala $name
  }
  if command_exists coursier; then
    alias openapi-generator-cli="coursier launch org.openapitools:openapi-generator-cli:latest.release --"
  fi
fi
## END SCALA

## PYTHON
if [ -d "$HOME/.pyenv" ]; then
   export PYENV_ROOT="$HOME/.pyenv"
   export PATH="$PYENV_ROOT/bin:$PATH"
   export PYENV_VIRTUALENV_DISABLE_PROMPT=1
   eval "$(pyenv init --path)"
   eval "$(pyenv init -)"
   eval "$(pyenv virtualenv-init -)"
fi

clean_pyc (){
  find . | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf
}
### Determine active Python virtualenv details.
set_virtualenv () {
  if [ ! -z "$PYENV_VIRTUAL_ENV" ] ; then
    PYTHON_VIRTUALENV=" %YELLOW[$(pyenv version-name)]%NORMAL"
  fi
}
## END PYTHON

## NPM
if command_exists npm; then
  NPM_PACKAGES="${HOME}/.config/npm-packages"
  mkdir -p $NPM_PACKAGES
  export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
  export PATH=$PATH:$NPM_PACKAGES/bin
fi

# END PROGRAMM LANGUAGES

# PROMPT
function parse_git_branch(){
  branch=`git branch 2> /dev/null | sed -n 's/^\* //p'`
  if [ ! "${branch}" == "" ]; then
    staged_files=''
    unstaged_files=''
    new_status=`git status --porcelain`
    ahead=`git status -sb 2> /dev/null | grep -o "ahead [0-9]*" | grep -o "[0-9]*"`
    behind=`git status -sb 2> /dev/null | grep -o "behind [0-9]*" | grep -o "[0-9]*"`
    # staged files
    X=`echo -n "${new_status}" 2> /dev/null | cut -c 1-1`
    # unstaged files
    Y=`echo -n "${new_status}" 2> /dev/null | cut -c 2-2`
    modified_unstaged=`echo -n "${Y}" | grep "M" -c`
    deleted_unstaged=`echo -n "${Y}" | grep "D" -c`
    untracked_unstaged=`echo -n "${Y}" | grep "?" -c`
    modified_staged=`echo -n "${X}" | grep "M" -c`
    deleted_staged=`echo -n "${X}" | grep "D" -c`
    renamed_staged=`echo -n "${X}" | grep "R" -c`
    new_staged=`echo -n "${X}" | grep "A" -c`
    # unstaged_files
    if [ "${modified_unstaged}" != "0" ]; then
      unstaged_files="%${modified_unstaged}${unstaged_files}"
    fi
    if [ "${deleted_unstaged}" != "0" ]; then
      unstaged_files="-${deleted_unstaged}${unstaged_files}"
    fi
    if [ "${untracked_unstaged}" != "0" ]; then
      unstaged_files="*${untracked_unstaged}${unstaged_files}"
    fi
    # staged_files
    if [ "${modified_staged}" != "0" ]; then
      staged_files="%${modified_staged}${staged_files}"
    fi
    if [ "${deleted_staged}" != "0" ]; then
      staged_files="-${deleted_staged}${staged_files}"
    fi
    if [ "${renamed_staged}" != "0" ]; then
      staged_files="^${renamed_staged}${staged_files}"
    fi
    if [ "${new_staged}" != "0" ]; then
      staged_files="+${new_staged}${staged_files}"
    fi
    if [ ! "${staged_files}" == "" ]; then
      staged_files="|${GREEN}${staged_files}${NORMAL}"
    fi
    if [ ! "${unstaged_files}" == "" ]; then
      unstaged_files="|${YELLOW}${unstaged_files}${NORMAL}"
    fi
    if [ ! "${ahead}" == "" ]; then
      ahead="${LIGHT_GREEN}{>${ahead}}${NORMAL}"
    fi
    if [ ! "${behind}" == "" ]; then
      behind="${LIGHT_RED}{<${behind}}${NORMAL}"
    fi
    # Set the final branch string.
    echo "${branch}${ahead}${behind}${unstaged_files}${staged_files}"
  fi
}

## Determine the branch/state information for this git repository.
function set_git_branch() {
  BRANCH=''
  # Get the final branch string.
  if command_exists git_status ; then
    branch="$(git_status bash)"
  else
    branch="$(parse_git_branch)"
  fi

  if [ ! "${branch}" == "" ]; then
    BRANCH=" (${CYAN}$branch${NORMAL})"
  fi
}

function set_prompt_symbol () {
  if test $1 -eq 0 ; then
    P_SYMBOL="${BLUE}\n╰─➤${NORMAL} "
  else
    P_SYMBOL="${LIGHT_RED}[$1]$INSIDE_VIFM\n╰─➤${NORMAL} "
  fi
}

# Set the prompt.
function set_bash_prompt () {
  local EXIT_CODE="$?"
  local USERCOLOR="${GREEN}"

  # Set the P_SYMBOL variable. We do this first so we don't lose the
  # return value of the last command.
  set_prompt_symbol $EXIT_CODE

  # Set the PYTHON_VIRTUALENV variable.
  set_virtualenv

  # Set the BRANCH variable.
  set_git_branch

  # history -a
  # history -c
  # history -r
  if [[ $EUID -eq 0 ]] ; then
    USERCOLOR="${RED}"
  fi

  # Set the bash prompt variable.
  [[ $SSH_CONNECTION ]] && local uath="${YELLOW}@\h${NORMAL}"
  PS1="${BLUE}╭─\A${NORMAL}${PYTHON_VIRTUALENV} ${USERCOLOR}\u${NORMAL}${uath} ${PURPLE}{\w}${NORMAL}${BRANCH}${P_SYMBOL}"
}

# Tell bash to execute this function just before displaying its prompt.
export PROMPT_COMMAND=set_bash_prompt
