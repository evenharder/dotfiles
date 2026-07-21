local wezterm = require("wezterm")
local act = wezterm.action
local config = {}
local launch_menu = {}

config.font = wezterm.font("FantasqueSansM Nerd Font Mono")
config.font_size = 10.0
config.cell_width = 1
config.line_height = 1.1
config.color_scheme = "flexoki-dark"
config.enable_wayland = false -- X11?
config.check_for_updates = true
config.check_for_updates_interval_seconds = 86400

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	table.insert(launch_menu, {
		label = "PowerShell",
		args = { "powershell.exe", "-NoLogo" },
	})
	config.default_prog = { "powershell.exe", "-NoLogo" }
end

-- https://github.com/danielcopper/wezterm-session-manager
local session_manager = require("wezterm-session-manager/session-manager")

wezterm.on("save_session", function(window)
	session_manager.save_state(window)
end)
wezterm.on("load_session", function(window)
	session_manager.load_state(window)
end)
wezterm.on("restore_session", function(window)
	session_manager.restore_state(window)
end)
wezterm.on("update-right-status", function(window, pane)
	window:set_right_status(window:active_workspace())
end)

config.launch_menu = launch_menu
-- config.window_background_opacity = 0.9

config.keys = {
	-- https://wezfurlong.org/wezterm/config/lua/keyassignment/PromptInputLine.html#example-of-interactively-renaming-the-current-tab
	{
		key = "e",
		mods = "ALT",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	-- FIXME: does the above 'workspace' scheme even work
	--
	-- https://github.com/danielcopper/wezterm-session-manager
	{ key = "s", mods = "ALT", action = wezterm.action({ EmitEvent = "save_session" }) },
	{ key = "l", mods = "ALT", action = wezterm.action({ EmitEvent = "load_session" }) },
	{ key = "r", mods = "ALT", action = wezterm.action({ EmitEvent = "restore_session" }) },
	-- workspace setup
	-- https://wezfurlong.org/wezterm/config/lua/keyassignment/SwitchToWorkspace.html
	-- Show the launcher in fuzzy selection mode and have it list all workspaces
	-- and allow activating one.
	{
		key = "9",
		mods = "ALT",
		action = act.ShowLauncherArgs({
			flags = "FUZZY|WORKSPACES",
		}),
	},
	-- Prompt for a name to use for a new workspace and switch to it.
	{
		key = "w",
		mods = "ALT",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter name for new workspace" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:perform_action(
						act.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},
}

-- `wezterm --config debug_key_events=true`
-- https://wezfurlong.org/wezterm/config/lua/keyassignment/ActivateTab.html
for i = 1, 8 do
	-- CTRL+ALT + number to activate that tab
	table.insert(config.keys, {
		key = "Keypad" .. tostring(i),
		mods = "CTRL|ALT",
		action = act.ActivateTab(i - 1),
	})
	-- support keypad as well
	table.insert(config.keys, {
		key = tostring(i),
		mods = "CTRL|ALT",
		action = act.ActivateTab(i - 1),
	})
	-- F1 through F8 to activate that tab
	table.insert(config.keys, {
		key = "F" .. tostring(i),
		action = act.ActivateTab(i - 1),
	})
end

return config
