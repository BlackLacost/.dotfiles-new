check_command() {
  local cmd="$1"

  if ! command -v "$cmd" &>/dev/null; then
    echo "ℹ️  Info: command '$cmd' not found in PATH." >&2
    return 1
  fi

  return 0
}

load_config_file() {
  local filepath="$1"   # full path to config file
  local name="$2"       # short description, e.g., "aliases"

  if [[ ! -e "$filepath" ]]; then
    echo "ℹ️  Info: $name config not found at '$filepath'." >&2
    return 1
  fi

  if [[ ! -r "$filepath" ]]; then
    echo "⚠️  Warning: '$filepath' exists but is not readable." >&2
    return 1
  fi

  source "$filepath"
  return 0
}

load_config_file "$HOME/.config/zsh/paths.sh" "paths"
load_config_file "$HOME/.config/zsh/aliases.sh" "aliases"
load_config_file "$HOME/.config/zsh/exports.sh" "exports"
check_command "zoxide" && load_config_file "$HOME/.config/zsh/zoxide.sh" "zoxide" 

