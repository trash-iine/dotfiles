if status is-interactive
    # Commands to run in interactive sessions can go here
end

oh-my-posh init fish --config (brew --prefix oh-my-posh)/themes/easy-term.omp.json | source
