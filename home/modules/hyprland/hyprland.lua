--
-- Functions
--

function get_hostname()
  local handle = io.popen("hostname")
  local result = handle:read("*a")
  handle:close()

  -- Clean up trailing newlines
  return result:gsub("%s+$", "")
end

local function apply_workspace_layout(active_config)
  local active_monitors = hl.get_monitors()
  local target_secondary = active_config.secondary.output
  local target_primary = active_config.primary.output
  local target_description = target_secondary:gsub("^desc:", "")

  local is_secondary_connected = false
  for _, mon in ipairs(active_monitors) do
    if mon.description == target_description then
      is_secondary_connected = true
      break
    end
  end

  if is_secondary_connected then
    for ws = 1, 5 do
      hl.workspace_rule({ workspace = tostring(ws), monitor = target_secondary, persistent = true })
    end
    for ws = 6, 10 do
      hl.workspace_rule({ workspace = tostring(ws), monitor = target_primary, persistent = true })
    end
  else
    for ws = 1, 10 do
      hl.workspace_rule({ workspace = tostring(ws), monitor = target_primary, persistent = true })
    end
  end
end

--
-- Monitors
--

Hostname = get_hostname()
local monitor_configs = {
  default = {
    primary = { output = "", mode = "preferred", position = "auto", scale = "auto" },
    secondary = { output = "", mode = "preferred", position = "auto", scale = "auto" },
  },
  thinkpad = {
    primary = { output = "eDP-1", mode = "1920x1080@60", position = "0x0", scale = "1.25" },
    secondary = { output = "desc:Dell Inc. DELL U2715H 6VY7R735038S", mode = "2560x1440@60", position = "auto-center-up", scale = "1.25" },
  },
  night = {
    primary = { output = "DP-1", mode = "2560x1440@240", position = "0x0", scale = "1" },
    secondary = { output = "DP-2", mode = "2560x1440@144", position = "-2560x0", scale = "1" },
  },
}
local config = monitor_configs[Hostname] or monitor_configs["default"]

-- dynamically sets attached monitors to the default section for apply_workspace_layout
if config == monitor_configs["default"] then
  hl.notification.create({
    text = "Monitor config doesn't exist for " .. Hostname,
    duration = 5000,
    icon = 0,
  })
  local current_monitors = hl.get_monitors()
  local connected = {}
  for id, name in pairs(current_monitors) do
    table.insert(connected, name.name)
  end

  config.primary.output = connected[1] or ""
  config.secondary.output = connected[2] or ""
end

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
hl.monitor(config.primary)
hl.monitor(config.secondary)

--
-- Workspace rules
--

apply_workspace_layout(config)
hl.on("monitor.added", function()
  apply_workspace_layout(config)
end)
hl.on("monitor.removed", function()
  apply_workspace_layout(config)
end)

-- keeping so i know how to peel apart a lua key value pair (im stupid)
hl.bind("SUPER + N", function()
  apply_workspace_layout(config)
  -- Define your Lua function output
  -- local output = ""
  -- local my_output = hl.get_monitors()
  -- for id, name in pairs(my_output) do
  --   output = output .. tostring(id) .. ": " .. tostring(name) .. "\n"
  -- end
  --
  -- -- Send it as an on-screen notification
  -- hl.notification.create({
  --   text = output,
  --   duration = 8000, -- Duration in milliseconds
  --   icon = 0,
  -- })
end)

--
-- Devices
--

hl.device({
  name = "bcm5974",
  sensitivity = 0,
})
hl.device({
  name = "logitech-usb-receiver",
  sensitivity = -0.7,
})
hl.device({
  name = "logitech-pro-x-wireless",
  sensitivity = -0.7,
})
hl.device({
  name = "logitech-pro-x-wireless-1",
  sensitivity = -0.7,
})
hl.device({
  name = "logitech-pro-x-wireless-2",
  sensitivity = -0.7,
})

hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace",
})

--
-- Exec
--

hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 20")

hl.on("hyprland.start", function()
  hl.exec_cmd("firefox", { workspace = "1 silent" })
  hl.exec_cmd("foot", { workspace = "2 silent" })
end)

-- startup
-- hl.on("hyprland.start", function()
--   hl.exec_cmd(
--     "/nix/store/ai8mmqghspvnhv2jz12pfg6b6dqmg3b3-dbus-1.16.2/bin/dbus-update-activation-environment --systemd DISPLAY HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE && systemctl --user stop hyprland-session.target && systemctl --user start hyprland-session.target"
--   )
-- end)

-- replacing the one above with this
hl.on("hyprland.start", function()
  -- hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  -- NOTE: may need to change this somehow to avoid the instance sig not being updated on rebuild-switch
  hl.exec_cmd(
    "dbus-update-activation-environment --systemd DISPLAY HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE && systemctl --user stop hyprland-session.target && systemctl --user start hyprland-session.target"
  )
end)

hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")

--
-- Animations
--

hl.curve("wind", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("winIn", { type = "bezier", points = { { 0.1, 1.1 }, { 0.1, 1.1 } } })
hl.curve("winOut", { type = "bezier", points = { { 0.3, -0.3 }, { 0, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 1, 1 }, { 1, 1 } } })

hl.animation({ leaf = "workspaces", enabled = false })
hl.animation({ leaf = "specialWorkspace", enabled = false })
hl.animation({ leaf = "windows", enabled = true, speed = 6, bezier = "wind", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 6, bezier = "winIn", style = "popin" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "winOut", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = false })
hl.animation({ leaf = "border", enabled = true, speed = 1, bezier = "linear" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 30, bezier = "linear", style = "once" })
hl.animation({ leaf = "fade", enabled = true, speed = 10, bezier = "default" })

--
-- Config
--

hl.config({
  general = {
    gaps_in = 2,
    gaps_out = 5,
    border_size = 2,
    ["col.active_border"] = { colors = { "rgba(f5c2e7ff)", "rgba(cba6f7ff)", angle = "45deg" } },
    ["col.inactive_border"] = { colors = { "rgba(89b4faff)", "rgba(89b4fadf)", angle = "45deg" } },
    layout = dwindle,
    resize_on_border = true,
  },
  decoration = {
    dim_special = 0.3,
    rounding = 10,
    shadow = { enabled = false },
    blur = {
      enabled = false,
      special = true,
      size = 6,
      passes = 3,
      new_optimizations = true,
      ignore_opacity = true,
      xray = false,
    },
  },
  input = {
    kb_layout = "us",
    follow_mouse = 1,
    sensitivity = 0,
    touchpad = {
      natural_scroll = false,
      tap_and_drag = false,
    },
  },
  misc = {
    initial_workspace_tracking = 2,
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
  },
  xwayland = {
    force_zero_scaling = true,
  },
  debug = {
    disable_logs = true, -- Keep off for performace
  },
})

--
-- Keybinds
--

hl.bind("SUPER + H", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "d" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "r" }))

-- hl.bind(keys, dispatcher, { flag1 = true, flag2 = true })
hl.bind("SUPER + C", hl.dsp.window.kill(), { description = "Kills active window" })
-- hl.bind("SUPER + W", hl.dsp.togglefloating, { description = "Toggles window floating" })
-- hl.bindd("SUPER, W, Toggles window floating, togglefloating")
hl.bind("SUPER + G", hl.dsp.group.toggle(), { description = "Toggle focused window to group" })
hl.bind("ALT + return", hl.dsp.window.fullscreen({ action = "toggle" }), { description = "Toggle fullscreen" })
hl.bind("SUPER + SHIFT + F", hl.dsp.exec_cmd("windowpin"), { description = "Pin focused window" })
hl.bind("CONTROL + ESCAPE", hl.dsp.exec_cmd("systemctl --user is-active waybar && systemctl --user stop waybar || systemctl --user start waybar"), { description = "Toggle waybar" })
-- hl.bind("CONTROL + ESCAPE", hl.dsp.exec_cmd("pkill waybar || waybar"), { description = "Toggle waybar" })
hl.bind("SUPER + ALT + W", hl.dsp.exec_cmd("select-wp"), { description = "Wallpaper selection script" })
hl.bind("SUPER + T", hl.dsp.exec_cmd("foot"), { description = "Launch terminal" })
hl.bind("SUPER + F", hl.dsp.exec_cmd("firefox"), { description = "Launch browser" })
-- FIXME: btop
hl.bind("SUPER + ESCAPE", hl.dsp.exec_cmd("setsid -f $term -e btop"), { description = "Launch btop" })
-- FIXME: keybinds
hl.bind("SUPER + SHIFT + slash", hl.dsp.exec_cmd("setsid -f $term -T Keybindings -e $scr_path/keybindings"), { description = "Show keybinds" })
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("pkill -x fuzzel || fuzzel"), { description = "Program launcher" })
hl.bind("SUPER + backspace", hl.dsp.exec_cmd("logout-menu"), { description = "Logout menu" })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { description = "Toggle audio mute" })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true, description = "Lower volume" })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true, description = "Raise volume" })
hl.bind("SUPER + P", hl.dsp.exec_cmd("screenshot-tool freeze-area"), { description = "Copy selection to clipboard" })
hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd("screenshot-tool freeze-area-save"), { description = "Saves selection to named file" })
hl.bind("SUPER + ALT + P", hl.dsp.exec_cmd("screenshot-tool copy-focused-monitor"), { description = "Copy focused monitor to clipboard" })
hl.bind("SUPER + CONTROL + P", hl.dsp.exec_cmd("screenshot-tool copy-all-monitors"), { description = "Copy all monitors to clipboard" })
-- Disabling in favour of raw dispatcher for now (this has gross delay)
-- hl.bind("SUPER + 1", hl.dsp.exec_cmd("toggle-workspace-number 1"), { description = "Switch to workspace 1" })
-- hl.bind("SUPER + 2", hl.dsp.exec_cmd("toggle-workspace-number 2"), { description = "Switch to workspace 2" })
-- hl.bind("SUPER + 3", hl.dsp.exec_cmd("toggle-workspace-number 3"), { description = "Switch to workspace 3" })
-- hl.bind("SUPER + 4", hl.dsp.exec_cmd("toggle-workspace-number 4"), { description = "Switch to workspace 4" })
-- hl.bind("SUPER + 5", hl.dsp.exec_cmd("toggle-workspace-number 5"), { description = "Switch to workspace 5" })
-- hl.bind("SUPER + 6", hl.dsp.exec_cmd("toggle-workspace-number 6"), { description = "Switch to workspace 6" })
-- hl.bind("SUPER + 7", hl.dsp.exec_cmd("toggle-workspace-number 7"), { description = "Switch to workspace 7" })
-- hl.bind("SUPER + 8", hl.dsp.exec_cmd("toggle-workspace-number 8"), { description = "Switch to workspace 8" })
-- hl.bind("SUPER + 9", hl.dsp.exec_cmd("toggle-workspace-number 9"), { description = "Switch to workspace 9" })
-- hl.bind("SUPER + 0", hl.dsp.exec_cmd("toggle-workspace-number 10"), { description = "Switch to workspace 10" })
hl.bind("SUPER + 1", hl.dsp.focus({ workspace = 1 }), { description = "Switch to workspace 1" })
hl.bind("SUPER + 2", hl.dsp.focus({ workspace = 2 }), { description = "Switch to workspace 2" })
hl.bind("SUPER + 3", hl.dsp.focus({ workspace = 3 }), { description = "Switch to workspace 3" })
hl.bind("SUPER + 4", hl.dsp.focus({ workspace = 4 }), { description = "Switch to workspace 4" })
hl.bind("SUPER + 5", hl.dsp.focus({ workspace = 5 }), { description = "Switch to workspace 5" })
hl.bind("SUPER + 6", hl.dsp.focus({ workspace = 6 }), { description = "Switch to workspace 6" })
hl.bind("SUPER + 7", hl.dsp.focus({ workspace = 7 }), { description = "Switch to workspace 7" })
hl.bind("SUPER + 8", hl.dsp.focus({ workspace = 8 }), { description = "Switch to workspace 8" })
hl.bind("SUPER + 9", hl.dsp.focus({ workspace = 9 }), { description = "Switch to workspace 9" })
hl.bind("SUPER + 0", hl.dsp.focus({ workspace = 0 }), { description = "Switch to workspace 10" })
hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ workspace = 1, follow = true }), { description = "Move focused window to workspace 1" })
hl.bind("SUPER + SHIFT + 2", hl.dsp.window.move({ workspace = 2, follow = true }), { description = "Move focused window to workspace 2" })
hl.bind("SUPER + SHIFT + 3", hl.dsp.window.move({ workspace = 3, follow = true }), { description = "Move focused window to workspace 3" })
hl.bind("SUPER + SHIFT + 4", hl.dsp.window.move({ workspace = 4, follow = true }), { description = "Move focused window to workspace 4" })
hl.bind("SUPER + SHIFT + 5", hl.dsp.window.move({ workspace = 5, follow = true }), { description = "Move focused window to workspace 5" })
hl.bind("SUPER + SHIFT + 6", hl.dsp.window.move({ workspace = 6, follow = true }), { description = "Move focused window to workspace 6" })
hl.bind("SUPER + SHIFT + 7", hl.dsp.window.move({ workspace = 7, follow = true }), { description = "Move focused window to workspace 7" })
hl.bind("SUPER + SHIFT + 8", hl.dsp.window.move({ workspace = 8, follow = true }), { description = "Move focused window to workspace 8" })
hl.bind("SUPER + SHIFT + 9", hl.dsp.window.move({ workspace = 9, follow = true }), { description = "Move focused window to workspace 9" })
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = 0, follow = true }), { description = "Move focused window to workspace 10" })
hl.bind("SUPER + ALT + 1", hl.dsp.window.move({ workspace = 1, follow = false }), { description = "Move focused window to workspace 1 silently" })
hl.bind("SUPER + ALT + 2", hl.dsp.window.move({ workspace = 2, follow = false }), { description = "Move focused window to workspace 2 silently" })
hl.bind("SUPER + ALT + 3", hl.dsp.window.move({ workspace = 3, follow = false }), { description = "Move focused window to workspace 3 silently" })
hl.bind("SUPER + ALT + 4", hl.dsp.window.move({ workspace = 4, follow = false }), { description = "Move focused window to workspace 4 silently" })
hl.bind("SUPER + ALT + 5", hl.dsp.window.move({ workspace = 5, follow = false }), { description = "Move focused window to workspace 5 silently" })
hl.bind("SUPER + ALT + 6", hl.dsp.window.move({ workspace = 6, follow = false }), { description = "Move focused window to workspace 6 silently" })
hl.bind("SUPER + ALT + 7", hl.dsp.window.move({ workspace = 7, follow = false }), { description = "Move focused window to workspace 7 silently" })
hl.bind("SUPER + ALT + 8", hl.dsp.window.move({ workspace = 8, follow = false }), { description = "Move focused window to workspace 8 silently" })
hl.bind("SUPER + ALT + 9", hl.dsp.window.move({ workspace = 9, follow = false }), { description = "Move focused window to workspace 9 silently" })
hl.bind("SUPER + ALT + 0", hl.dsp.window.move({ workspace = 0, follow = false }), { description = "Move focused window to workspace 10 silently" })
hl.bind("SUPER + CTRL + L", hl.dsp.focus({ direction = "r" }), { description = "Go to next workspace" })
hl.bind("SUPER + CTRL + H", hl.dsp.focus({ direction = "l" }), { description = "Go to prev workspace" })
hl.bind("SUPER + mouse_down", hl.dsp.focus({ direction = "r" }), { description = "Scroll to next workspace" })
hl.bind("SUPER + mouse_up", hl.dsp.focus({ direction = "l" }), { description = "Scroll to prev workspace" })
hl.bind("SUPER + CTRL + SHIFT + H", hl.dsp.window.move({ direction = "l" }), { description = "Move window left" })
hl.bind("SUPER + CTRL + SHIFT + J", hl.dsp.window.move({ direction = "d" }), { description = "Move window down" })
hl.bind("SUPER + CTRL + SHIFT + K", hl.dsp.window.move({ direction = "u" }), { description = "Move window up" })
hl.bind("SUPER + CTRL + SHIFT + L", hl.dsp.window.move({ direction = "r" }), { description = "Move window right" })
hl.bind("SUPER + ALT + S", hl.dsp.window.move({ workspace = "special" }), { description = "Move window to special workspace" })
hl.bind("SUPER + SHIFT + S", hl.dsp.window.move({ workspace = "special", follow = true }), { description = "Move window to special workspace" })
hl.bind("SUPER + S", hl.dsp.workspace.toggle_special({ "special" }), { description = "Toggle special workspace" })
-- hl.bind("SUPER + D", hl.dsp.layout("togglesplit"), { description = "Toggle layout" }) -- requires preserve_split to be set

hl.bind("SUPER + SHIFT + H", hl.dsp.window.resize({ x = -30, y = 0 }), { repeating = true })
hl.bind("SUPER + SHIFT + J", hl.dsp.window.resize({ x = 0, y = 30 }), { repeating = true })
hl.bind("SUPER + SHIFT + K", hl.dsp.window.resize({ x = 0, y = -0 }), { repeating = true })
hl.bind("SUPER + SHIFT + L", hl.dsp.window.resize({ x = 30, y = 0 }), { repeating = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightness increase_brightness"), { repeating = true, description = "Increase brightness" })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightness decrease_brightness"), { repeating = true, description = "Decrease brightness" })

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind("SUPER + mouse:272", hl.dsp.window.drag())
hl.bind("SUPER + mouse:273", hl.dsp.window.resize())
hl.bind("SUPER + Z", hl.dsp.window.drag())
hl.bind("SUPER + X", hl.dsp.window.resize())

--
-- Layer & Window rules
--

hl.layer_rule({ match = { namespace = "rofi" }, blur = true })
hl.layer_rule({ match = { namespace = "launcher" }, no_anim = true })
hl.layer_rule({ match = { namespace = "logout_dialog" }, blur = true })
hl.layer_rule({ match = { namespace = "notifications" }, blur = true })
hl.layer_rule({ match = { namespace = "swaync-control-center" }, blur = true })
hl.layer_rule({ match = { namespace = "swaync-notification-window" }, blur = true })
hl.layer_rule({ match = { namespace = "waybar" }, blur = true })
hl.layer_rule({ match = { namespace = "notifications" }, ignore_alpha = true })
hl.layer_rule({ match = { namespace = "rofi" }, ignore_alpha = true })
hl.layer_rule({ match = { namespace = "swaync-control-center" }, ignore_alpha = true })
hl.layer_rule({ match = { namespace = "swaync-notification-window" }, ignore_alpha = true })

hl.window_rule({ match = { class = "^(app.drey.Warp)$" }, float = true })
hl.window_rule({ match = { class = "^(blueman-manager)$" }, float = true })
hl.window_rule({ match = { class = "^(com.github.rafostar.Clapper)$" }, float = true })
hl.window_rule({ match = { class = "^(com.github.unrud.VideoDownloader)$" }, float = true })
hl.window_rule({ match = { class = "^(eog)$" }, float = true })
hl.window_rule({ match = { class = "^(firefox)$", title = "^(Library)$" }, float = true })
hl.window_rule({ match = { class = "^(io.github.alainm23.planify)$" }, float = true })
hl.window_rule({ match = { class = "^(io.gitlab.theevilskeleton.Upscaler)$" }, float = true })
hl.window_rule({ match = { class = "^(kvantummanager)$" }, float = true })
hl.window_rule({ match = { class = "^(net.davidotek.pupgui2)$" }, float = true })
hl.window_rule({ match = { class = "^(nm-applet)$" }, float = true })
hl.window_rule({ match = { class = "^(nm-connection-editor)$" }, float = true })
hl.window_rule({ match = { class = "^(nwg-look)$" }, float = true })
hl.window_rule({ match = { class = "^(org.gnome.Calculator)$" }, float = true })
hl.window_rule({ match = { class = "^(org.kde.ark)$" }, float = true })
hl.window_rule({ match = { class = "^(org.kde.dolphin)$", title = "^(Copying — Dolphin)$" }, float = true })
hl.window_rule({ match = { class = "^(org.kde.dolphin)$", title = "^(Progress Dialog — Dolphin)$" }, float = true })
hl.window_rule({ match = { class = "^(org.kde.polkit-kde-authentication-agent-1)$" }, float = true })
hl.window_rule({ match = { class = "^(org.pulseaudio.pavucontrol)$" }, float = true })
hl.window_rule({ match = { class = "^(qt5ct)$" }, float = true })
hl.window_rule({ match = { class = "^(qt6ct)$" }, float = true })
hl.window_rule({ match = { class = "^(Signal)$" }, float = true })
hl.window_rule({ match = { class = "^(steam)", title = "negative:^(Steam.*)" }, float = true })
hl.window_rule({ match = { class = "^(org.mozilla.Thunderbird)$", title = "negative:^(Mozilla Thunderbird)$" }, float = true })
hl.window_rule({ match = { class = "^(xdg-desktop-portal-gtk)$" }, float = true })
hl.window_rule({ match = { class = "^(vlc)$" }, float = true })
hl.window_rule({ match = { class = "^(yad)$" }, float = true })
hl.window_rule({ match = { title = "^(Picture-in-Picture)$" }, float = true })
hl.window_rule({ match = { title = "^(Keybindings)$" }, float = true })

hl.window_rule({
  name = "OSRS tooltip fix",
  match = { class = "net-runelite-client-RuneLite", title = "^(wind+)$" },
  float = true,
  no_focus = 1,
})
hl.window_rule({
  name = "KeepassXC screenshare blocker",
  match = { class = "^(org.keepassxc.KeePassXC)$" },
  no_screen_share = true,
})
