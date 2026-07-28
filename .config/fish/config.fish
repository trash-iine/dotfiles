# fish reads conf.d/*.fish before this file, so PATH, tool activation, the
# prompt and the abbreviations all live there -- adding a snippet needs no
# change to bootstrap.sh, because the whole directory is symlinked.

# Set outside the interactive guard so scripts and git see it too.
if type -q nvim
    set -gx EDITOR nvim
    set -gx VISUAL nvim
end
