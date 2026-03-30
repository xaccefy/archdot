# Layout Switching Design

## Goal
Enable dynamic switching between the default `dwindle` layout and the new `scroller` (hyprscroller) layout using a keybind.

## Architecture
1. **Plugin Management**: Use `hyprpm` to manage `hyprscroller`.
   - Requires `exec-once = hyprpm reload -n` in autostart.
2. **Configuration**:
   - Add `plugin:scroller {...}` settings to a new config file `conf/scroller.conf` (or `conf/custom.conf`).
   - Define the switching logic.

## Switching Mechanism Options
1. **Direct Keybind (Recommended)**:
   - `bind = $mainMod, [Key], exec, hyprctl keyword general:layout scroller`
   - `bind = $mainMod SHIFT, [Key], exec, hyprctl keyword general:layout dwindle`
   - *Pros*: Simple, fast. *Cons*: Requires two binds or complex "switch" logic.

2. **Toggle Script**:
   - Create `scripts/switch_layout.sh`
   - Logic: Check current layout -> Switch to other.
   - Bind: `bind = $mainMod, Tab, exec, scripts/switch_layout.sh`
   - *Pros*: Single key toggle, can send notification.

## Decision
Use **Option 2 (Toggle Script)** for better UX (notifications + single key toggle).

## Implementation Details
- **Script Path**: `~/.config/hypr/scripts/switch_layout.sh`
- **Keybind**: `SUPER + Tab` (Currently used for `cyclenext`, might conflict. Will check `keybinding.conf` again. `cyclenext` is `ALT + Tab`. `SUPER + Tab` is free? No, `SUPER + Tab` is not bound in provided `keybinding.conf`).
- **Conflict Check**: `keybinding.conf` has `bind = ALT, Tab, cyclenext`. `SUPER + Tab` is available.

## Plan
1. Enable `hyprpm` in `autostart.conf`.
2. Create `switch_layout.sh`.
3. Add keybind to `keybinding.conf`.
4. Run `hyprpm add` and `enable` for hyprscroller.
