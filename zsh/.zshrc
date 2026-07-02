# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# ponytail: async load almost everything
zinit ice wait"0" lucid
zinit light zsh-users/zsh-completions
zinit ice wait"0" lucid
zinit light Aloxaf/fzf-tab
zinit ice wait"0" lucid
zinit light andreacasarin/zsh-ask-opencode
zinit ice wait"0" lucid
zinit light zsh-users/zsh-autosuggestions
zinit ice wait"0" lucid atinit"zicompinit; zicdreplay"
zinit light zdharma-continuum/fast-syntax-highlighting

export NVM_COMPLETION=true
export NVM_SYMLINK_CURRENT="true"
zinit wait lucid light-mode for lukechilds/zsh-nvm

# ponytail: move snippets to wait
zinit wait"0" lucid for \
    OMZL::git.zsh \
    OMZP::git \
    OMZP::sudo \
    OMZP::archlinux \
    OMZP::command-not-found

# Load completions
fpath=("$HOME/.zsh/completions" $fpath)
# ponytail: cached compinit
autoload -Uz compinit
setopt extendedglob
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.m-1) ]]; then
  compinit -C
else
  compinit
fi

zinit cdreplay -q

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Common Aliases and Functions
[[ -f ~/.shell_common ]] && . ~/.shell_common

# ponytail: cached integrations (rm -rf ~/.zsh_cache to regenerate)
mkdir -p ~/.zsh_cache
[[ ! -f ~/.zsh_cache/fzf.zsh ]] && fzf --zsh > ~/.zsh_cache/fzf.zsh
source ~/.zsh_cache/fzf.zsh

[[ ! -f ~/.zsh_cache/zoxide.zsh ]] && zoxide init --cmd cd zsh > ~/.zsh_cache/zoxide.zsh
source ~/.zsh_cache/zoxide.zsh

[[ ! -f ~/.zsh_cache/starship.zsh ]] && starship init zsh > ~/.zsh_cache/starship.zsh
source ~/.zsh_cache/starship.zsh


rbenv() {
  eval "$(command rbenv init - zsh)"
  rbenv "$@"
}

# Added by codebase-memory-mcp install
