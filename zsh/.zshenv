# ponytail: unified path — typeset -U dedupes PATH, so prepend freely
typeset -U path PATH
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

export PATH="$HOME/.foundry/bin:$HOME/go/bin:$HOME/.cargo/bin:$HOME/.local/bin:$HOME/.local/share/solana/install/active_release/bin:$HOME/.avm/bin:$HOME/.npm-global/bin:$HOME/.aptoscli/bin:$HOME/.rbenv/shims:$HOME/.rbenv/bin:$HOME/.pdtm/go/bin:$HOME/.bun/bin:$HOME/.opencode/bin:$HOME/.local/share/JetBrains/Toolbox/scripts:$HOME/flutter/bin:$HOME/tools/vol-rs/target/release:$HOME/tools/vol-rs/target/debug:$PATH"

if [ -d "$HOME/.local/share/gem/ruby/3.4.0/bin" ]; then
    export PATH="$HOME/.local/share/gem/ruby/3.4.0/bin:$PATH"
fi

export NODE_PATH="/home/xaccefy/.npm-global/lib/node_modules"

# Local-only secrets (API keys etc.). This file lives outside the dotfiles
# repo on purpose so keys can never be committed to the public remote.
[ -f "$HOME/.config/zsh/.zshenv.local" ] && . "$HOME/.config/zsh/.zshenv.local"
