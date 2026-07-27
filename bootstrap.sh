#!/usr/bin/env bash
set -eu

cd "$(dirname "${BASH_SOURCE}")" || exit 1;

git pull origin main;

function syncDot() {
	# rsync matches these rules against each path component as it descends, so
	# the parent directories need including before the nested file is reachable.
	rsync --include ".tmux.conf" \
		--include ".vimrc" \
		--include ".config/" \
		--include ".config/fish/" \
		--include ".config/fish/config.fish" \
		--exclude "*" \
		-avh --no-perms . ~;
}

if [ "${1:-}" = "--force" ] || [ "${1:-}" = "-f" ]; then
	syncDot;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		syncDot;
	fi;
fi;

unset -f syncDot;
