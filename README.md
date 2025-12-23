# Dotfiles

This folder collects pushable desktop configs so you can sync them to GitHub and reapply with symlinks or `stow`.

## Contents
- `hypr/` — Hyprland core configs (`hyprland.conf`, `conf/*.conf`, `hyprpaper*.conf`, `hypridle.conf`, `hyprlock.conf`).
- `hyprfloat/` — floating rules for terminals.
- `waybar/` — bar configuration, styles, modules, scripts, launcher.
- `rofi/` — launchers, powermenu themes, images, scripts.
- `dunst/` — notification daemon configuration.
- `wlogout/` — logout menu configuration.
- `swappy/` — screenshot editing tool configuration.
- `starship.toml` — prompt configuration.
- `apps/` — optional tool configs (`cdncheck`, `uncover`).
- `scripts/` — helper scripts referenced by configs (`cliphist.sh`, `updates.sh`, `random_wallpaper.sh`, `screenshot.sh`, `gtk.sh`, `xdg.sh`).
- `wallpapers/` — put your wallpaper assets here or adjust paths in configs.

## Setup
You can use the provided installer or run Stow manually.

### Quick install (Arch/Arch-based, user xacce)
```bash
cd ~/dotfiles   # or wherever you cloned
chmod +x install.sh
./install.sh
```
The script installs packages via pacman (and yay for Cozette if available) and stows configs into `~/.config`. It aborts if not run as user `xacce`.

### Using Stow manually
From `dotfiles/` parent directory:
```bash
stow -t $HOME/.config hypr hyprfloat waybar rofi dunst wlogout swappy scripts
stow -t $HOME/.config starship.toml
stow -t $HOME/.config/apps apps   # optional
```
Adjust targets if you keep wallpapers elsewhere. For non-`.config` files, point `-t` to the correct root.

### Manual symlinks (examples)
```bash
ln -s $PWD/hypr ~/.config/hypr
ln -s $PWD/waybar ~/.config/waybar
ln -s $PWD/rofi ~/.config/rofi
ln -s $PWD/dunst ~/.config/dunst
ln -s $PWD/wlogout ~/.config/wlogout
ln -s $PWD/swappy ~/.config/swappy
ln -s $PWD/scripts ~/.config/scripts
ln -s $PWD/starship.toml ~/.config/starship.toml
ln -s $PWD/apps ~/.config/apps   # optional
```

## Restoring
1) Clone your repo. 2) Run `./install.sh` or use Stow/symlinks as above. 3) Log out/in or restart Hyprland/Waybar to apply.
