# See the note in .zshenv: fish is the login shell and this only covers zsh
# being invoked as macOS's system shell.

[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"  # Apple silicon
[ -x /usr/local/bin/brew ] && eval "$(/usr/local/bin/brew shellenv)"        # Intel

# pipx
[ -d "$HOME/.local/bin" ] && export PATH="$PATH:$HOME/.local/bin"

return 0
