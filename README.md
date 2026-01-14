# Dotfiles

Personal desktop configuration for Hyprland on Arch Linux.

## Contents

### Window Manager & UI
- `hypr/` — Hyprland core configs (`hyprland.conf`, `conf/*.conf`, `hyprlock.conf`, `hypridle.conf`, `hyprpaper.conf`)
- `hyprfloat/` — floating rules for terminals
- `waybar/` — status bar configuration, styles, modules
- `rofi/` — launchers, powermenu themes, applets
- `dunst/` — notification daemon
- `wlogout/` — logout menu

### Shell & Terminal
- `zsh/` — zsh configuration (`.zshrc`, `.zshenv`) with zinit plugin manager
- `ghostty/` — Ghostty terminal emulator config
- `starship.toml` — prompt configuration

### Appearance
- `gtk-3.0/` — GTK3 theme settings
- `gtk-4.0/` — GTK4 theme settings
- `fastfetch/` — system info display config

### Utilities
- `swappy/` — screenshot editing tool
- `scripts/` — helper scripts (clipboard, wallpaper, screenshots, etc.)
- `apps/` — optional tool configs
- `wallpapers/` — wallpaper assets

## Setup

### Quick install (Arch/Arch-based)
```bash
cd ~/.config/dotfiles   # or wherever you cloned
chmod +x install.sh
./install.sh
```

The script automatically:
- Installs `yay` (AUR helper) if missing
- Installs packages via `pacman` and `yay`
- Stows configurations into `~/.config`
- Links shell configs to `$HOME`
- Enables system services (ly, NetworkManager, bluetooth)
- Sets zsh as default shell

**Note:** Run as a normal user with `sudo` privileges. Do not run as root.

### Using Stow manually
```bash
cd ~/.config/dotfiles
stow -t $HOME/.config hypr hyprfloat waybar rofi dunst wlogout swappy scripts apps ghostty astronvim fastfetch gtk-3.0 gtk-4.0
ln -sf $PWD/starship.toml $HOME/.config/starship.toml
ln -sf $PWD/zsh/.zshrc $HOME/.zshrc
ln -sf $PWD/zsh/.zshenv $HOME/.zshenv
```

### Manual symlinks
```bash
ln -s $PWD/hypr ~/.config/hypr
ln -s $PWD/waybar ~/.config/waybar
ln -s $PWD/rofi ~/.config/rofi
ln -s $PWD/ghostty ~/.config/ghostty
ln -s $PWD/astronvim ~/.config/astronvim
ln -s $PWD/zsh/.zshrc ~/.zshrc
# ... etc
```

## Key Features

- **Hyprland** with NVIDIA optimizations
- **Ghostty** terminal with 80% transparency, JetBrainsMono Nerd Font
- **Zsh** with zinit, syntax highlighting, autosuggestions, fzf-tab
- **Starship** minimal prompt
- **Arc-Dark** GTK theme
- **Waybar** with VPN status, caffeine toggle, system stats

## Restoring
1. Clone your repo
2. Run `./install.sh` or use Stow/symlinks
3. Log out/in or restart Hyprland to apply
