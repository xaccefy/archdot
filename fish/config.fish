# >>> plamen toolchain PATH >>>
# fish_add_path -g -p dedupes against the inherited PATH and skips dirs that
# don't exist, so nested fish shells stop stacking the same entries.
fish_add_path -g -p /home/xaccefy/.foundry/bin /home/xaccefy/go/bin /home/xaccefy/.cargo/bin /home/xaccefy/.local/bin /home/xaccefy/.local/share/solana/install/active_release/bin /home/xaccefy/.avm/bin /home/xaccefy/.npm-global/bin /home/xaccefy/.aptoscli/bin
# <<< plamen toolchain PATH <<<

# ponytail: starship prompt (starship.toml exists, binary at /usr/sbin/starship)
if status is-interactive; and command -q starship
    starship init fish | source
end
