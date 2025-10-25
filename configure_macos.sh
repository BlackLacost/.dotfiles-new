set -euo pipefail

DOTFILES_DIR=$(realpath $(dirname $0))

info() {
  printf "\n\033[1;34m%s\033[0m\n" "$1"
}

success() {
  printf "✅ \033[1;32m%s\033[0m\n" "$1"
}

debug() {
  printf "\033[1;37m%s\033[0m\n" "$1"
}

debug "dotfile root path: $DOTFILES_DIR"

error() {
  printf "💥 \033[1;31m%s\033[0m\n" "$1"
}

warning() {
  printf "⚠️ \033[1;33m%s\033[0m\n" "$1"
}


brew_install() {
  local dependency="$1"

  if ! brew ls --versions "$dependency" >/dev/null; then
    brew install "$dependency" \
      && success "brew installed $dependency" \
      || error "brew failed to install $dependency"
  else
    debug "brew $dependency already installed"
  fi
}

brew_cask_install() {
  local dependency="$1"

  if ! brew list --cask "$dependency" >/dev/null 2>&1; then
    brew install --cask "$dependency" \
      && success "brew cask installed $dependency" \
      || error "brew cask failed to install $dependency"
  else
    debug "brew cask $dependency already installed"
  fi
}

mas_install() {
  local dependency_id="$1"

  if ! mas list | grep "$dependency_id" >/dev/null; then
    debug "mas install $dependency_id"
    mas install "$dependency_id" \
      && success "mas installed $dependency_id" \
      || error "mas failed to install $dependency_id"
  else
    debug "mas $dependency_id already installed"
  fi
}

confirm_update() {
  local message=$1

  read -p "$message [y/n]: " answer

  if [[ $answer == "y" || $answer == "Y" ]]; then
    return 0  # Success, proceed with update
  else
    info "Skipping $message."
    return 1  # Skip update
  fi
}

setup_mac_using_brew() {
  info "🍺 Installing Homebrew packages..."
  local packages=(
    aichat
    aider
    # ast-grep
    bat
    # bison
    cmake
    # colima
    curl
    # docker
    # docker-compose
    fd
    ffmpeg
    # fswatch
    fzf
    gh
    libpq   # postgresql client tools
    kcat    # kafka cat
    mas
    neovim
    ollama
    pgcli
    # openai-whisper
    # openjdk
    # pass
    # pinentry-mac
    # pmd
    # pyenv
    # python
    ripgrep
    # sqlite
    stow
    tmux
    tree
    vim
    wget
    yazi
  )
  for pkg in "${packages[@]}"; do
    brew_install "$pkg"
  done

}

setup_mac_using_brew_cask() {
  info "🍺 Installing Homebrew casks packages..."
  local casks=(
    # aldente torrent
    alt-tab
    betterdisplay
    brave-browser
    chatgpt
    font-jetbrains-mono-nerd-font
    geekbench
    # jetbrains-toolbox # vpn
    hammerspoon
    iina
    karabiner-elements
    keepassxc
    lens                # Kubernetes IDE
    libreoffice
    linearmouse
    # little-snitch torrent
    mpv
    obsidian
    ollama-app
    qbittorrent
    rectangle
    stats
    syncthing
    visual-studio-code
    wezterm
  )
  for cask in "${casks[@]}"; do
    brew_cask_install "$cask"
  done
}

setup_mac_using_app_store() {
  info "🍎 Installing App Store applications..."

  if confirm_update "Install App Store applications"; then
    local apps=(
      937984704   # Amphetamine
      # 1091189122  # Bear
      # 571213070   # DaVinci Resolve
      1322465647  # Disk-O:
      # 1445910651  # Dynamo ads blocker for Safari
      408981434   # iMovie
      409183694   # Keynote
      409203825   # Numbers
      409201541   # Pages
      # 6714467650  # Perplexity
      # 1289119450  # URL Linker for Safari
      747648890   # Telegram
      585829637   # Todoist
      310633997   # Whatsapp
    )

    for app in "${apps[@]}"; do
      mas_install "$app"
    done
  fi
}

# Launch intel x86-64 on Apple arm64
if pkgutil --pkg-info com.apple.pkg.RosettaUpdateAuto > /dev/null 2>&1; then
  debug "Rosetta 2 already installed."
else
  softwareupdate --install-rosetta --agree-to-license \
    && success "softwareupdate installed Rosseta 2" \
    || error "softwareupdate failed to install Rosseta 2"
fi



# XCode command-line tools
# xcode-select --install
# echo "Wait for the xcode-select GUI installer and press enter"
# read -s
# if [ -e /opt/homebrew/bin/brew ]; then
#   echo "Homebrew already installed"
# else
#   # This will require sudo access and waits for confirmation
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# fi
# # Add homebrew to path for the rest of the script
# eval "$(/opt/homebrew/bin/brew shellenv)"

setup_mac_using_brew
setup_mac_using_brew_cask
setup_mac_using_app_store
