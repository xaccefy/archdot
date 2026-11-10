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
# gg/gga (git-gui launchers from OMZP::git) dropped per request 2026-10-16
zinit wait"0" lucid atload"unalias gg gga 2>/dev/null" for \
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

# ---- Drop failed commands from history ----
# zshaddhistory fires BEFORE the command runs, so it cannot know the exit
# status. Instead: never auto-add; re-add via print -s in precmd only when
# the command exited 0. Interrupted (Ctrl-C) commands are also dropped.
autoload -Uz add-zsh-hook
typeset -g __sc_history_last=""
function __sc_history_preexec() { __sc_history_last=$1 }
function __sc_history_precmd() {
  local __st=$?
  if (( __st == 0 )) && [[ -n "$__sc_history_last" ]]; then
    print -s -- "$__sc_history_last"
  fi
  __sc_history_last=
}
add-zsh-hook preexec __sc_history_preexec
add-zsh-hook precmd __sc_history_precmd
function zshaddhistory() { return 1 }

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
if [[ ! -f ~/.zsh_cache/fzf.zsh ]]; then
  fzf --zsh > ~/.zsh_cache/fzf.zsh
  # fzf snapshots the 'zle' option and evals it back; zle can't be set outside
  # a live ZLE so it errors in `zsh -i -c` ("can't change option: zle")
  sed -i 's/eval \$__fzf_key_bindings_options/eval "${${__fzf_key_bindings_options\/\/ zle on}\/\/ zle off}"/; s/eval \$__fzf_completion_options/eval "${${__fzf_completion_options\/\/ zle on}\/\/ zle off}"/' ~/.zsh_cache/fzf.zsh
fi
source ~/.zsh_cache/fzf.zsh

[[ ! -f ~/.zsh_cache/zoxide.zsh ]] && zoxide init --cmd cd zsh > ~/.zsh_cache/zoxide.zsh
source ~/.zsh_cache/zoxide.zsh

[[ ! -f ~/.zsh_cache/starship.zsh ]] && starship init zsh > ~/.zsh_cache/starship.zsh
source ~/.zsh_cache/starship.zsh

# blank line between prompts, but not before the first one (or after clear)
_newline_before_prompt() {
  if [[ -z "$_FIRST_PROMPT" ]]; then
    _FIRST_PROMPT=1
  else
    print
  fi
}
precmd_functions+=(_newline_before_prompt)
alias clear='unset _FIRST_PROMPT; command clear'


rbenv() {
  eval "$(command rbenv init - zsh)"
  rbenv "$@"
}

# Added by codebase-memory-mcp install

# bun completions
[ -s "/home/xaccefy/.bun/_bun" ] && source "/home/xaccefy/.bun/_bun"
export BROWSER=helium-browser

# Toolchain PATH lives in .zshenv (typeset -U dedupes; covers non-interactive shells too)
_ZO_DOCTOR=0
export DISABLE_AUTOUPDATER=true




# Zed: skip the NVIDIA Vulkan ICD on this hybrid laptop. Loading it blocks Zed's
# main thread for ~1.4s per launch for a GPU Zed never selects. See
# ~/.local/bin/zed-intel-gpu for details and how to switch back to the dGPU.
zed() { command /home/xaccefy/.local/bin/zed-intel-gpu "$@"; }

# Local-only secrets and machine-specific settings. This file lives outside
# the dotfiles repo on purpose: it holds API keys that must never be pushed
# to a public remote. `vercel ai-gateway setup` writes the gateway block.
[ -f "$HOME/.config/zsh/.zshrc.local" ] && source "$HOME/.config/zsh/.zshrc.local"

# claudebar command
claudebar() { ~/.claude/statusline.sh "$@"; }

# Devin CLI: start every session in Bypass (yolo) permission mode.
export DEVIN_PERMISSION_MODE=bypass
