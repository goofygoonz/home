local wezterm = require 'wezterm';

wezterm.on("toggle-opacity", function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if not overrides.window_background_opacity then
    overrides.window_background_opacity = 1.0;
  else
    overrides.window_background_opacity = nil
  end
  window:set_config_overrides(overrides)
end)

return {
  color_scheme = "Gruvbox Dark",
  colors = {
    tab_bar = {
      -- The color of the strip that goes along the top of the window
      background = "#1d2021",
      -- The active tab is the one that has focus in the window
      active_tab = {
        -- The color of the background area for the tab
        bg_color = "#427b58",
        -- The color of the text for the tab
        fg_color = "#c0c0c0",
        -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
        -- label shown for this tab.
        -- The default is "Normal"
        intensity = "Normal",
        -- Specify whether you want "None", "Single" or "Double" underline for
        -- label shown for this tab.
        -- The default is "None"
        underline = "None",

        -- Specify whether you want the text to be italic (true) or not (false)
        -- for this tab.  The default is false.
        italic = false,

        -- Specify whether you want the text to be rendered with strikethrough (true)
        -- or not for this tab.  The default is false.
        strikethrough = false,
      },

      -- Inactive tabs are the tabs that do not have focus
      inactive_tab = {
        bg_color = "#181907",
        fg_color = "#36473A",

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `inactive_tab`.
      },

      -- You can configure some alternate styling when the mouse pointer
      -- moves over inactive tabs
      inactive_tab_hover = {
        bg_color = "#282828",
        fg_color = "#909090",
        italic = true,
      }
    }
  },
  enable_scroll_bar = true,
  enable_wayland = true,
  font = wezterm.font_with_fallback({"Hack Nerd Font Mono","Hack"}),
  font_size=18.0,
  hide_tab_bar_if_only_one_tab = true,
  keys = {
    {key="A"          ,mods="CTRL"       ,action="ActivateCopyMode"},
    {key="B"          ,mods="CTRL|SHIFT" ,action=wezterm.action{EmitEvent="toggle-opacity"}},
    {key="DownArrow"  ,mods="ALT"        ,action=wezterm.action{ActivatePaneDirection="Down"}},
    {key="LeftArrow"  ,mods="ALT"        ,action=wezterm.action{ActivatePaneDirection="Left"}},
    {key="RightArrow" ,mods="ALT"        ,action=wezterm.action{ActivatePaneDirection="Right"}},
    {key="Tab"        ,mods="CTRL"       ,action=wezterm.action{ActivateTabRelative=1}},
    {key="Tab"        ,mods="CTRL|SHIFT" ,action=wezterm.action{ActivateTabRelative=-1}},
    {key="UpArrow"    ,mods="ALT"        ,action=wezterm.action{ActivatePaneDirection="Up"}},
    {key="X"          ,mods="CTRL"       ,action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
    {key="Z"          ,mods="CTRL"       ,action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
    {key="t"          ,mods="CTRL"       ,action=wezterm.action{SpawnTab="CurrentPaneDomain"}},
    {key="w"          ,mods="CTRL"       ,action=wezterm.action{CloseCurrentPane={confirm=true}}},
    {key="z"          ,mods="CTRL"       ,action="Nop"},
  },
  ratelimit_mux_line_prefetches_per_second = 4289999998,
  scrollback_lines = 150000,
  tab_max_width = 46,
  window_background_opacity = 0.9,
}
