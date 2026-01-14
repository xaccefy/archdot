#!/usr/bin/env bash
# Install desktop deps and deploy dotfiles with stow.
# Target: Arch/Arch-based with pacman + yay (auto-installed)
set -euo pipefail

log() { printf "[install] %s\n" "$*"; }
warn() { printf "[install][warn] %s\n" "$*" >&2; }
die() { printf "[install][error] %s\n" "$*" >&2; exit 1; }

need_cmd() { command -v "$1" >/dev/null 2>&1 || die "Missing required command: $1"; }

# Check for Arch
if [[ -r /etc/os-release ]]; then
  . /etc/os-release
  if [[ "${ID:-}" != "arch" && "${ID_LIKE:-}" != *"arch"* ]]; then
    warn "OS reports ID=${ID:-unknown}; script is optimized for Arch Linux."
  fi
fi

# Ensure running as non-root (makepkg requirements)
if [[ $EUID -eq 0 ]]; then
   die "This script must be run as a normal user (with sudo privileges), not root."
fi

# Detect/Install yay
if ! command -v yay >/dev/null 2>&1; then
    log "yay not found. Installing yay-bin from AUR..."
    # Ensure git and base-devel are present for building
    sudo pacman -Sy --needed --noconfirm git base-devel
    
    TEMP_DIR=$(mktemp -d)
    git clone https://aur.archlinux.org/yay-bin.git "$TEMP_DIR/yay-bin"
    pushd "$TEMP_DIR/yay-bin"
    makepkg -si --noconfirm
    popd
    rm -rf "$TEMP_DIR"
else
    log "yay is already installed."
fi

# Core Packages
PKGS=(
  # System / Build
  git base-devel stow jq
  
  # Shell & Tools
  zsh fzf zoxide fastfetch starship
  go rustup npm rbenv pipx python
  
  # Display Manager
  ly
  
  # Wayland / Hyprland Core
  hyprland hyprpaper hypridle hyprlock waybar rofi wl-clipboard cliphist dunst polkit-gnome
  xdg-desktop-portal-hyprland xdg-desktop-portal qt5-wayland qt6-wayland swaybg
  
  # Audio (Pipewire)
  pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber pavucontrol playerctl
  
  # Connectivity
  network-manager-applet blueman
  
  # Apps
  ghostty firefox thunar code spotify-launcher webcord
  
  # Fonts
  ttf-jetbrains-mono ttf-fira-code ttf-font-awesome noto-fonts-emoji
  
  # Utils
  wlogout swappy grim slurp imagemagick qalculate-gtk xclip brightnessctl
)

# AUR Packages
AUR_PKGS=(
  cozette-ttf
)

log "Updating system and installing repo packages..."
sudo pacman -Sy --needed --noconfirm "${PKGS[@]}"

log "Installing AUR packages..."
yay -S --needed --noconfirm "${AUR_PKGS[@]}"

# Stow deployment
DOTFILES_DIR=$(cd "$(dirname "$0")" && pwd)
log "Using dotfiles directory: $DOTFILES_DIR"

# Ensure target directories exist
mkdir -p "$HOME/.config"

log "Stowing core configs..."
# Core Hyprland & UI
# Note: stow will stow the *contents* of these directories into ~/.config
STOW_PKGS=(hypr hyprfloat waybar rofi dunst wlogout swappy scripts apps ghostty fastfetch gtk-3.0 gtk-4.0)

for pkg in "${STOW_PKGS[@]}"; do
    if [[ -d "$DOTFILES_DIR/$pkg" ]]; then
        log "  - $pkg"
        stow -d "$DOTFILES_DIR" -t "$HOME/.config" "$pkg"
    else
        warn "Package directory '$pkg' not found, skipping."
    fi
done

# Handle starship.toml separately (it's a file, usually better to symlink directly or move to a stow dir)
if [[ -f "$DOTFILES_DIR/starship.toml" ]]; then
    log "Linking starship.toml..."
    ln -sf "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"
fi

# Handle zsh configs (these go to $HOME, not ~/.config)
log "Linking zsh configs..."
if [[ -d "$DOTFILES_DIR/zsh" ]]; then
    ln -sf "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
    [[ -f "$DOTFILES_DIR/zsh/.zshenv" ]] && ln -sf "$DOTFILES_DIR/zsh/.zshenv" "$HOME/.zshenv"
fi

# Enable Services
log "Enabling system services..."
SERVICES=(
  ly.service
  NetworkManager.service
  bluetooth.service
)

for service in "${SERVICES[@]}"; do
    if systemctl is-enabled --quiet "$service"; then
        log "  $service is already enabled."
    else
        log "  Enabling $service..."
        sudo systemctl enable "$service"
    fi
done

# Change Shell
if [[ "$SHELL" != */zsh ]]; then
    log "Changing default shell to zsh..."
    chsh -s "$(command -v zsh)"
fi

log "Done! Please restart your computer to enter the new desktop environment."
