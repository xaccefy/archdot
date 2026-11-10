local wezterm = require 'wezterm'

local config = {
    font = wezterm.font('JetBrainsMono Nerd Font', { weight = 'Regular' }),
    font_rules = {
        { intensity = 'Bold', font = wezterm.font('JetBrainsMono Nerd Font', { weight = 'Bold' }) },
    },
    font_size = 16,
    default_cursor_style = 'SteadyBlock',
    window_background_opacity = 0.88,
    window_decorations = 'NONE',
    window_frame = { font = wezterm.font('JetBrainsMono Nerd Font'), font_size = 13.5 },
    window_padding = { left = 10, right = 10, top = 10, bottom = 10 },
    leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1000 },
    keys = {
        { key = 'LeftArrow',  mods = 'LEADER', action = wezterm.action.ActivateTabRelative(-1) },
        { key = 'RightArrow', mods = 'LEADER', action = wezterm.action.ActivateTabRelative(1) },
        {
            key = 'F2',
            mods = 'CTRL|SHIFT',
            action = wezterm.action.PromptInputLine {
                description = 'Rename tab',
                action = wezterm.action_callback(function(window, _, line)
                    if line then
                        window:active_tab():set_title(line)
                    end
                end),
            },
        },
        { key = '|', mods = 'LEADER|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
        { key = '-', mods = 'LEADER',       action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
        { key = 'p', mods = 'LEADER',       action = wezterm.action.PaneSelect },
        { key = 's', mods = 'LEADER',       action = wezterm.action.PaneSelect { mode = 'SwapWithActive' } },
        { key = 'z', mods = 'LEADER',       action = wezterm.action.TogglePaneZoomState },
    },
    colors = {
        foreground = '#f5f3ff',
        background = '#08080c',
        cursor_bg = '#ffffff',
        cursor_fg = '#08080c',
        selection_bg = '#292638',
        selection_fg = '#f5f3ff',
        tab_bar = {
            background = '#08080c',
            active_tab = { bg_color = '#191923', fg_color = '#00e5ff', intensity = 'Bold' },
            inactive_tab = { bg_color = '#0b0b10', fg_color = '#85829a' },
            inactive_tab_hover = { bg_color = '#171720', fg_color = '#f5f3ff', italic = true },
            new_tab = { bg_color = '#0b0b10', fg_color = '#77738f' },
            new_tab_hover = { bg_color = '#171720', fg_color = '#f5f3ff', italic = true },
        },
        ansi = {
            '#08080c', '#ff2e88', '#00ff41', '#ff8a00',
            '#00e5ff', '#a259ff', '#00e5ff', '#f5f3ff',
        },
        brights = {
            '#77738f', '#ff2e88', '#00ff41', '#ff8a00',
            '#00e5ff', '#a259ff', '#00e5ff', '#f5f3ff',
        },
    },
}

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_max_width = 512
config.unzoom_on_switch_pane = true

local tab_icons = {
    bash = wezterm.nerdfonts.cod_terminal_bash,
    docker = wezterm.nerdfonts.linux_docker,
    git = wezterm.nerdfonts.dev_git,
    nvim = wezterm.nerdfonts.custom_vim,
    vim = wezterm.nerdfonts.dev_vim,
    zsh = wezterm.nerdfonts.dev_terminal,
}

wezterm.on('format-tab-title', function(tab, tabs, _, _, _, max_width)
    local index = 1
    for i, candidate in ipairs(tabs) do
        if candidate.tab_id == tab.tab_id then
            index = i
            break
        end
    end

    local title = (tab.tab_title and #tab.tab_title > 0)
        and tab.tab_title or tab.active_pane.title
    local process, custom = title:match('^(%S+)%s*%-?%s*%s*(.*)$')
    if custom and custom ~= '' then
        title = custom
    end

    local metadata = tostring(index)

    local icon = tab_icons[(process or 'unknown'):lower()]
    local text = string.format('  %s %s%s  ', metadata, icon and (icon .. ' ') or '', title)
    max_width = math.max(1, max_width or config.tab_max_width)
    text = wezterm.truncate_right(text, max_width)
    local text_width = wezterm.column_width and wezterm.column_width(text) or #text
    local padding = math.max(0, max_width - text_width)
    text = string.rep(' ', math.floor(padding / 2)) .. text .. string.rep(' ', math.ceil(padding / 2))

    local style = tab.is_active and config.colors.tab_bar.active_tab or config.colors.tab_bar.inactive_tab
    return {
        { Background = { Color = style.bg_color } },
        { Foreground = { Color = style.fg_color } },
        { Attribute = { Intensity = tab.is_active and 'Bold' or 'Normal' } },
        { Text = text },
    }
end)

return config
