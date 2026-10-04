# ~/.bashrc

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# append to the history file, don't overwrite it
shopt -s histappend

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
HISTTIMEFORMAT="%F %T "

# To set the number of lines in active history and to set the number of lines saved in Bash history
HISTSIZE=2000
HISTFILESIZE=2000

# navigation
up () {
  local d=""
  local limit="$1"

  # Default to limit of 1
  if [ -z "$limit" ] || [ "$limit" -le 0 ]; then
    limit=1
  fi

  for ((i=1;i<=limit;i++)); do
    d="../$d"
  done

  # perform cd. Show error if cd fails
  if ! cd "$d"; then
    echo "Couldn't go up $limit dirs.";
  fi
}

### ARCHIVE EXTRACTION
# usage: ex <file>
ex (){
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   unzstd $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# tmux handler
tx() {
  if ! command -v tmux >/dev/null 2>&1; then
    echo "tmux is not installed."
    return 1
  fi

  if [ -n "$TMUX" ]; then
    echo "Already inside a tmux session."
    return 0
  fi

  if tmux has-session 2>/dev/null; then
    tmux attach-session
  else
    tmux new-session
  fi
}

# kill ports
kill_port() {
  if [ -z "$1" ]; then
    echo "Usage: kill_port <port_number>"
    return 1
  fi
  port=$1
  pid=$(sudo lsof -t -i :"$port")
  if [ -n "$pid" ]; then
    sudo kill -9 "$pid"
    echo "Process on port $port (PID: $pid) has been killed."
  else
    echo "No process found on port $port."
  fi
}


# get git commit logs from a specif tag
gd() {
    git log --pretty=format:"%h: %s" $1..@
}


# ls aliases
alias ls='exa --icons'
alias ll='exa -alF --icons --git'
alias l='exa -l --icons'
alias la='exa -a --icons'
alias lla='exa -la --icons'
alias lt='exa --tree --icons'

alias f='yazi'
alias v='nvim'

alias rs='exec $0'
alias h='history'
alias c='clear'
alias grep='grep --color=auto'

alias cl='claude'
alias cld='claude --dangerously-skip-permissions'

alias gl='git log --pretty=format:"%C(yellow)%h\\ %ad%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --date=short'
alias gb='git branch'
alias gr='git remote'
alias gc='git clone'
alias gs='git status'
alias gw='git worktree'
alias gm='git merge'
alias gf='git fetch'
alias gck='git checkout'
alias gsw='git switch'
alias gpl='git pull'

alias nit='npm init'
alias ni='npm install'
alias nu='npm uninstall'
alias nr='npm run'


p1() {
  git config --global user.email "work@work.com"
  git config --global user.name "sonu sharma"
  echo "Git: sonu sharma <work@work.com>"
}

p2() {
  git config --global user.email "mail@mail.com"
  git config --global user.name "sonu sharma"
  echo "Git: sonu sharma <mail@mail.com>"
}
# RUN FADE SCRIPT
sh ~/fade
