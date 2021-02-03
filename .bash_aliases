# Reference in .bashrc:
# [ -r /home/noel/.bash_aliases ] && . /home/noel/.bash_aliases

alias python=python3
alias pip=pip3
alias config='/usr/bin/git --git-dir=$HOME/dotfiles.git/ --work-tree=$HOME'
# alias vim=nvim

alias gs='git status'
alias gco='git checkout'
alias gpu='git pull'
alias gp='git pull'
alias ga='git add'
alias gci='git commit'
alias gd='git diff'

# Alternative so C-r works correctly in Neovim Terminal
bind '"\C-t":"\C-r"'

export EDITOR=nvim
export GIT_EDITOR=nvim
export VISUAL=nvim
export DIFFPROG="nvim -d"
export MANPAGER='nvim +Man!'
export MANWIDTH=999

. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash
