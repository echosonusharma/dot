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

# simple alias
alias h='history'
alias c='clear'

# run fade script for ascii art
fade

### SETTING THE STARSHIP PROMPT ###
eval "$(starship init bash)"
