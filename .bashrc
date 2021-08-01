LinuxPenguin(){
green="\e[0;92m"
bold="\e[1m"
reset="\e[0m"

echo  -e "${green} ${bold}     .--.     ${reset} "
echo  -e "${green} ${bold}    |o_o |    ${reset} "
echo  -e "${green} ${bold}    |:_/ |    ${reset} "
echo  -e "${green} ${bold}   //   \ \   ${reset} "
echo  -e "${green} ${bold}  (|     | )  ${reset} " 
echo  -e "${green} ${bold} /:\_   _/:\  ${reset} "
echo  -e "${green} ${bold} \___)=(___/  ${reset} "
}

HISTCONTROL=ignoredups
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

alias dd=""

alias dd=""

alias dd=""

alias dd=""
# running custom scripts form c/Users/fucitol/bin
alias as='as.sh'
alias gp='gp.sh'


# Run the LinuxPenguin function on shell startup   
LinuxPenguin

### SETTING THE STARSHIP PROMPT ###
eval "$(starship init bash)"
