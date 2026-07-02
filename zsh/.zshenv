# ponytail: unified path
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

export PATH="$HOME/.local/bin:$HOME/.rbenv/shims:$HOME/.rbenv/bin:$HOME/.pdtm/go/bin:$HOME/.npm-global/bin:$HOME/go/bin:$HOME/.bun/bin:$HOME/.opencode/bin:$HOME/.foundry/bin:$HOME/.local/share/JetBrains/Toolbox/scripts:$PATH"

if [ -d "$HOME/.local/share/gem/ruby/3.4.0/bin" ]; then
    export PATH="$HOME/.local/share/gem/ruby/3.4.0/bin:$PATH"
fi

export NODE_PATH="/home/xaccefy/.npm-global/lib/node_modules"
