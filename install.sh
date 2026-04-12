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
install_if_missing "ffmpeg"
install_if_missing "7zip"
install_if_missing "jq"
install_if_missing "poppler-utils"
install_if_missing "fd-find"
install_if_missing "ripgrep"
install_if_missing "fzf"
install_if_missing "zoxide"
install_if_missing "imagemagick"
install_if_missing "clang"
install_if_missing "clangd"
install_if_missing "golang-go"

show_msg "installing rust"
if ! command -v rustc &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    echo "rust is already installed."
fi

show_msg "installing yazi from source"
if ! command -v yazi &> /dev/null; then
    git clone https://github.com/sxyazi/yazi.git
    cd yazi
    cargo build --release --locked
    sudo mv target/release/yazi target/release/ya /usr/local/bin/
    cd ..
    rm -rf yazi
else
    echo "yazi is already installed."
fi

show_msg "installing nvm and latest node"
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi

# Load nvm and install latest node
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm install node
nvm use node

show_msg "installing typescript language server"
npm i -g typescript typescript-language-server

show_msg "installing gopls"
go install golang.org/x/tools/gopls@latest

show_msg "all done :)"
