# Aliases

# alias rm='rm -i'
alias rm='rm -iv'
alias cp='cp -iv'
alias mv='mv -iv'
# alias nrs="sudo nixos-rebuild switch --flake .#nixlab"
# alias nrs="cd ~/dotfiles && sudo nixos-rebuild switch --flake .#laptop"
alias nrs="cd ~/dotfiles && nix flake update && sudo nixos-rebuild switch --flake .#laptop"
# alias nrs="cd ~/dotfiles && sudo nix flake update && sudo nixos-rebuild switch --flake .#laptop"
alias rmg="rclone mount --daemon gdrive: /home/jb/gdrive/"

# remove pervious aliases
# unalias -a

alias vi='vimx'
alias vim='vimx'
# alias vi='nvim -0'
# alias vim='nvim -0'
# alias nvim='nvim -0'
# alias ls='ls -alh --color=auto --group-directories-first --sort=extension'

# alias cd="z"
# alias cd="cd --"
alias lynx="lynx -cfg=~/.config/lynx/lynx.cfg"

# alias l="exa -laFh --time-style=long-iso"
# alias l="exa -aFhlg --time-style=long-iso --icons --group-directories-first"
# alias l="exa -Glah --color-scale --group-directories-first --icons --time-style=long-iso"
alias l="exa -ah --grid --long --color-scale --group-directories-first --icons --time-style=long-iso"
alias ls="exa -ah --grid --long --color-scale --group-directories-first --icons --time-style=long-iso"


# alias em="emacs -nw" # cli emacs
alias em="emacsclient -c -a emacs" # cli emacs
alias et="emacsclient -t" # cli emacs
# alias et="emacs -nw" # cli emacs
# alias emacs="em"
alias etn="et ~/documents/org/20220401030216-main-idx.org"
alias emn="em ~/documents/org/20220401030216-main-idx.org"


# alias nv="nvim -O --startuptime /tmp/nvim-startuptime"
# alias vi="nvim -O --startuptime /tmp/nvim-startuptime"
# alias nvw="nvim ~/wiki/000-master-index.md"
# alias nvw="nvim ~/Wiki/0-idx.md"
alias nvw="nv ~/Wiki/0-idx.md"
alias viw="vi ~/Wiki/0-idx.md"
alias nvw0="nvim ~/Wiki/0-inf/0-idx.md"
alias nvw1="nvim ~/Wiki/1-ppy/0-idx.md"
alias nvw1="nvim ~/Wiki/2-rel/0-idx.md"
# alias vinit="vi ~/.config/nvim/init.lua"
# alias vibrc="vi ~/.bashrc"

alias v="~/.config/vifm/scripts/vifmrun ."
alias vf="vifm"

alias cat="bat"

# alias shutdown="sudo openrc-shutdown -p 0"
# alias shutdown="sudo shutdown -p 0"
alias reboot="sudo reboot"

alias zat="devour zathura"

# Doom Emacs
alias doomsync="$HOME/.emacs.d/bin/doom sync"
alias doomupgrade="$HOME/.emacs.d/bin/doom upgrade"
alias doomdoctor="$HOME/.emacs.d/bin/doom doctor"
alias doompurge="$HOME/.emacs.d/bin/doom purge"
alias doomclean="$HOME/.emacs.d/bin/doom clean"
alias doombuild="$HOME/.emacs.d/bin/doom build"
