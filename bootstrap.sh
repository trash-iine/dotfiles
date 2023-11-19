#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin main;

function syncDot() {
	rsync --include ".tmux.conf" \
		--include ".vimrc" \
		--include ".config/fish/config.fish" \
		--exclude "*" \
		-avh --no-perms . ~;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	syncDot;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		syncDot;
	fi;
fi;

unset syncDot;
