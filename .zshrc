export EDITOR=nvim
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="powerlevel10k/powerlevel10k"
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

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

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

source $ZSH/oh-my-zsh.sh
source $ZSH/custom/plugins/zsh-syntax-highlighting/catppuccin_macchiato-zsh-syntax-highlighting.zsh

# User configuration
# zsh history
HISTSIZE=10000       # Set the amount of lines you want saved
SAVEHIST=$HISTSIZE       # This is required to actually save them, needs to match with HISTSIZE
HISTFILE=~/.zsh_history
setopt sharehistory             # Share history between all sessions.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt INC_APPEND_HISTORY     # 在每次命令后立即追加到历史

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

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
alias e=exit
alias nv=nvim
alias clr="precmd() { precmd() { echo } } && printf '\033[2J\033[3J\033[1;1H'"

code() {
	# command code "$@" --enable-wayland-ime --use-angle=vulkan
	# command code --force-device-scale-factor=1.6 "$@" --enable-wayland-ime --use-angle=vulkan
	# command code --force-device-scale-factor=1.6 "$@" --enable-wayland-ime --enable-features=UseOzonePlatform --ozone-platform=wayland --disable-gpu-compositing
    command code --force-device-scale-factor=1.6 "$@" --enable-features=UseOzonePlatform --ozone-platform=x11 --enable-wayland-ime
}

pause() {
	command playerctl pause
}

play() {
	command playerctl play
}


alias kssh="kitten ssh"
alias hg="kitten hyperlinked-grep"
source /home/baiyx/.config/fzf-git.sh

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

how_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else cat {}; fi"

export FZF_DEFAULT_OPTS=" \
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 \
--color=selected-bg:#494d64 \
--multi"
# export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"

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
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    kssh)         fzf --preview 'dig {}'                   "$@" ;;
    scp)         fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf "$@" ;;
  esac
}

# eza
alias ls="eza --color=always --icons=always"

# yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
alias sy="sudo yazi"

# zoxide
eval "$(zoxide init --cmd cd zsh)"

# tailscale
tailscale_start() {
    sudo systemctl start tailscaled
    sudo tailscale up
    echo tailscale start
}

tailscale_stop() {
    sudo tailscale down
    sudo systemctl stop tailscaled
    echo tailscale stop
}

# starship
eval "$(starship init zsh)"
precmd() { precmd() { echo "" } }
alias clear="precmd() { precmd() { echo } } && clear"
export VIRTUAL_ENV_DISABLE_PROMPT=1

# dae
edit-dae() {
    sudoedit /usr/local/etc/dae/config.dae
    sudo dae reload
}

# dua
alias duai="dua i"

# peaclock
alias peaclock="peaclock --config-dir ~/.config/peaclock"

# lazygit
alias lg=lazygit
