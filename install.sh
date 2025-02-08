# script to install pkg's i use on ubuntu

show_msg() {
  local msg="$1"
  local color="\e[1;32m"
  local reset="\e[0m"

  echo -e "${color}========== ${msg} ==========${reset}"
}

sys_maintenance() {
  show_msg "running sys maintenance"
  sudo apt update && sudo apt upgrade -y
}

install_if_missing() {
    if ! dpkg -l | grep -q "^ii  $1 "; then
        echo "Installing $1..."
        sudo apt update && sudo apt install -y "$1"
    else
        echo "$1 is already installed."
    fi
}

full_sys_maintenance() {
  show_msg "running full sys maintenance"
  sudo apt update && sudo apt full-upgrade -y
}

sys_maintenance

show_msg "running installs"

install_if_missing "lsd"
install_if_missing "git"
install_if_missing "vim"
install_if_missing "curl"
install_if_missing "wget"
install_if_missing "net-tools"
install_if_missing "build-essential"
install_if_missing "tmux"

show_msg "all done :)"
