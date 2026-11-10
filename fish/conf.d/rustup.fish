# cargo/rustc are provided system-wide by the pacman `rustup` package (/usr/bin).
# Only source the rustup.rs env file if a user-local install ever adds it.
if test -f "$HOME/.cargo/env.fish"
    source "$HOME/.cargo/env.fish"
end
