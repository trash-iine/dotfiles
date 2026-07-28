# fish is the login shell. This file exists because zsh is still macOS's system
# shell and runs for non-interactive invocations, so cargo has to be reachable
# from there. Interactive configuration belongs in .config/fish/conf.d/.
#
# WSL2 uses bash for the same role, and install.sh writes to ~/.profile and
# ~/.bashrc directly, so this file is only linked on macOS.

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

return 0
