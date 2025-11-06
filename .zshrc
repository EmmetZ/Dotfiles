export EDITOR=nvim
export XDG_CONFIG_HOME="$HOME/.config"

# fix keybind issue
bindkey -e
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# vi mode keybind
bindkey -M vicmd 'H' vi-beginning-of-line
bindkey -M vicmd 'L' vi-end-of-line

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

autoload -Uz compinit
compinit

source "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

source $XDG_CONFIG_HOME/catppuccin_macchiato-zsh-syntax-highlighting.zsh

# User configuration
# zsh history
unsetopt HIST_APPEND
# unsetopt HIST_EXPAND
HISTFILE=
HISTSIZE=SAVEHIST=0
# HISTSIZE=10000       # Set the amount of lines you want saved
# SAVEHIST=$HISTSIZE       # This is required to actually save them, needs to match with HISTSIZE
# HISTFILE=~/.zsh_history
# setopt sharehistory             # Share history between all sessions.
# setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
# setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
# setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
# setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
# setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
# setopt INC_APPEND_HISTORY     # 在每次命令后立即追加到历史

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

alias nv=nvim
alias clr="precmd() { precmd() { echo } } && printf '\033[2J\033[3J\033[1;1H'"

code() {
	command code "$@" --enable-wayland-ime
	# command code --force-device-scale-factor=1.6 "$@" --enable-wayland-ime --enable-features=UseOzonePlatform --ozone-platform=wayland --disable-gpu-compositing
    # command code "$@" --enable-features=UseOzonePlatform --ozone-platform=x11 --enable-wayland-ime
}

alias kssh="kitten ssh"

# fzf
# set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
export FZF_DEFAULT_COMMAND="fd --hidden --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_DEFAULT_OPTS=" \
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 \
--color=selected-bg:#494d64 \
--multi
"
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview '$show_file_or_dir_preview'
  --preview-window hidden
  --bind 'ctrl-/:change-preview-window(wrap|down|hidden)'"

_fzf_complete_kssh() {
    local -a tokens
    tokens=(${(z)1})
    case ${tokens[-1]} in
        -i|-F|-E)
            _fzf_path_completion "$prefix" "$1"
            ;;
        *)
            local user
            [[ $prefix =~ @ ]] && user="${prefix%%@*}@"
            _fzf_complete +m -- "$@" < <(__fzf_list_hosts | awk -v user="$user" '{print user $0}')
            ;;
    esac

}

_fzf_complete_scp() {
    local -a tokens
    tokens=(${(z)1})
    case ${tokens[-1]} in
        -i|-F|-E)
            _fzf_path_completion "$prefix" "$1"
            ;;
        *)
            local user
            [[ $prefix =~ @ ]] && user="${prefix%%@*}@"
            _fzf_complete +m -- "$@" < <(__fzf_list_hosts | awk -v user="$user" '{print user $0}')
            ;;
    esac
}

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree -L 2 --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    kssh)         fzf --preview 'dig {}'                   "$@" ;;
    scp)         fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf "$@" ;;
  esac
}

# eza
alias ls="eza --color=always --icons=always"
alias lt="eza -T --color=always --icons=always"
alias l="eza --color=always --icons=always -a -l"

# yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
alias sy="sudo yazi"
export YAZI_ZOXIDE_OPTS="--no-exact"

# starship
eval "$(starship init zsh)"
precmd() { precmd() { echo "" } }
alias clear="precmd() { precmd() { echo } } && clear"
export VIRTUAL_ENV_DISABLE_PROMPT=1

# dae
edit-dae() {
    sudoedit /etc/dae/config.dae
    sudo dae reload
}

# peaclock
alias peaclock="peaclock --config-dir ~/.config/peaclock"

# lazygit
alias lg=lazygit

# 7zip
alias 7z=7zz

# direnv
eval "$(direnv hook zsh)"

# strongswan sjtu vpn
sjtuvpnon() {
    sudo systemctl start strongswan
    sudo swanctl -i --child vpn-student
}
sjtuvpnoff() {
    sudo swanctl -t --ike vpn-student
    sudo systemctl stop strongswan
}

# uv
eval "$(uv generate-shell-completion zsh)"
export UV_PYTHON_INSTALL_BIN=0
# Fix completions for uv run to autocomplete .py files
_uv_run_mod() {
    if [[ "$words[2]" == "run" && "$words[CURRENT]" != -* ]]; then
        _arguments '*:filename:_files -g "*.py"'
    else
        _uv "$@"
    fi
}
compdef _uv_run_mod uv

# podman
alias docker=podman

# atuin
eval "$(atuin init zsh)"
eval "$(atuin gen-completions --shell zsh)"

# function help atuin filter command
,() {
    eval "$@"
}

# function to auto add a comma at the beginning of the line
# and execute the command to help atuin filter
prepend_comma_and_execute() {
    LBUFFER=", $LBUFFER"
    zle accept-line
}
zle -N prepend_comma_and_execute
bindkey '\e[13;2u' prepend_comma_and_execute

# zoxide
export _ZO_EXCLUDE_DIRS="$HOME"
eval "$(zoxide init --cmd cd zsh)"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# typst
eval "$(typst completions zsh)"

# rustup and cargo
eval "$(rustup completions zsh)"
