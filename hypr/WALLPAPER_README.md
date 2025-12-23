# Hyprland Wallpaper Management

This configuration provides several ways to manage wallpapers in Hyprland using hyprpaper.

## Configuration Files

- `hyprpaper.conf`: Main configuration for wallpaper management
- `hyprpaper-blur-example.conf`: Example configuration with blur effects enabled

## Available Scripts

1. **change_wallpaper.sh** - Manually set a specific wallpaper
   ```bash
   ~/.config/hypr/scripts/change_wallpaper.sh /path/to/wallpaper.jpg
   ```

2. **random_wallpaper.sh** - Select and set a random wallpaper from your Pictures folder
   ```bash
   ~/.config/hypr/scripts/random_wallpaper.sh
   ```
   Or specify a directory:
   ```bash
   ~/.config/hypr/scripts/random_wallpaper.sh /path/to/wallpapers/
   ```

3. **set_wallpaper.sh** - Interactive script to choose a wallpaper from available ones
   ```bash
   ~/.config/hypr/scripts/set_wallpaper.sh
   ```

4. **preload_wallpapers.sh** - Preload all wallpapers from a directory in hyprpaper
   ```bash
   ~/.config/hypr/scripts/preload_wallpapers.sh
   ```

## Key Binding

- `SUPER + CTRL + W`: Change to a random wallpaper from your Pictures folder

## How to Use

1. Place your wallpapers in `~/Pictures/` or another directory of your choice
2. Update `hyprpaper.conf` to preload and set your desired wallpaper
3. Use any of the scripts to change wallpapers dynamically
4. Use the key binding for quick random wallpaper changes

## Notes

- The configuration uses hyprpaper which is efficient and integrates well with Hyprland
- You can enable blur effects by uncommenting the blur settings in the configuration
- For multiple monitors, add additional wallpaper lines with specific monitor names