#!/usr/bin/env bash
# Install desktop deps and deploy dotfiles with stow.
# Target: Arch/Arch-based with pacman + optional yay (for Cozette font)
# Personal use only (xacce); abort if run by another user.
set -euo pipefail

log() { printf "[install] %s\n" "$*"; }
warn() { printf "[install][warn] %s\n" "$*" >&2; }

die() { printf "[install][error] %s\n" "$*" >&2; exit 1; }

need_cmd() { command -v "$1" >/dev/null 2>&1 || die "Missing required command: $1"; }

# Personal guard
target_user="xacce"
if [[ "$(whoami)" != "$target_user" ]]; then
  die "This installer is scoped to user '$target_user'."
fi

# Detect package managers
PACMAN=$(command -v pacman || true)
YAY=$(command -v yay || true)

if [[ -z "$PACMAN" ]]; then
  die "pacman not found; this script targets Arch/Arch-based systems."
fi

if [[ -r /etc/os-release ]]; then
  . /etc/os-release
  if [[ "${ID:-}" != "arch" && "${ID_LIKE:-}" != *"arch"* ]]; then
    warn "OS reports ID=${ID:-unknown}; script expects Arch."
  fi
fi

# Packages (feel free to adjust)
PKGS=(
  hyprland hyprpaper hypridle hyprlock waybar rofi stow jq wl-clipboard cliphist dunst polkit-gnome
  network-manager-applet blueman brightnessctl playerctl pavucontrol swaybg
  ghostty firefox thunar code spotify-launcher webcord
  ttf-jetbrains-mono ttf-fira-code
  wlogout swappy grim slurp imagemagick qalculate-gtk xclip
)

# Optional/AUR packages
AUR_PKGS=(
  cozette-ttf
)

log "Updating package databases"
sudo pacman -Sy --needed || die "pacman -Sy failed"

log "Installing packages: ${PKGS[*]}"
sudo pacman -S --needed --noconfirm "${PKGS[@]}" || die "Package install failed"

if [[ -n "$YAY" ]]; then
  log "Installing AUR packages via yay: ${AUR_PKGS[*]}"
  yay -S --needed --noconfirm "${AUR_PKGS[@]}" || warn "Some AUR installs failed; install manually if needed"
else
  warn "yay not found; install AUR packages manually: ${AUR_PKGS[*]}"
fi

# Stow deployment
DOTFILES_DIR=$(cd "$(dirname "$0")" && pwd)
log "Using dotfiles directory: $DOTFILES_DIR"
need_cmd stow

log "Stowing core configs"
# Core Hyprland & UI
stow -d "$DOTFILES_DIR" -t "$HOME/.config" hypr hyprfloat waybar rofi dunst wlogout swappy scripts || die "stow failed for core configs"

log "Stowing starship.toml"
stow -d "$DOTFILES_DIR" -t "$HOME/.config" starship.toml || warn "stow starship.toml failed"

# Optional stows
if [[ -d "$DOTFILES_DIR/apps" ]]; then
  log "Stowing apps"
  stow -d "$DOTFILES_DIR" -t "$HOME/.config" apps || warn "stow apps failed"
fi

log "Done. Restart Hyprland/Waybar or relog to apply."

# Reminders
warn "Ensure wallpapers are in place and paths in hyprpaper.conf match."
warn "Check network interface in waybar (default: wlan0) and adjust if needed."
warn "VPN module expects tun0/wg0; adjust if different."
