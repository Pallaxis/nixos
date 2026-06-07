--
-- Monitors
--

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
-- Home monitors
hl.monitor({ output = "desc:Samsung Electric Company LC32G7xT H4ZR900653", mode = "2560x1440@240", position = "0x0", scale = "1" })
hl.monitor({ output = "desc:Ancor Communications Inc ROG PG278Q", mode = "2560x1440@144", position = "-2560x0", scale = "1" })
-- Work monitors
hl.monitor({ output = "desc:InfoVision Optoelectronics (Kunshan) Co.Ltd China 0x0536", mode = "1920x1080@60", position = "0x0", scale = "1.25" })
hl.monitor({ output = "desc:Dell Inc. DELL U2715H 6VY7R735038S", mode = "2560x1440@60", position = "auto-center-up", scale = "1.25" })

--
-- Workspace rules
--

-- FIXME: need to add conditional logic per system
hl.workspace_rule({ workspace = "1", monitor = "DP-4", default = true })
hl.workspace_rule({ workspace = "2", monitor = "DP-4" })
hl.workspace_rule({ workspace = "3", monitor = "DP-4" })
hl.workspace_rule({ workspace = "4", monitor = "DP-4" })
hl.workspace_rule({ workspace = "5", monitor = "DP-4" })
hl.workspace_rule({ workspace = "6", monitor = "eDP-1", default = true })
hl.workspace_rule({ workspace = "7", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "8", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "9", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "10", monitor = "eDP-1" })

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
    initial_workspace_tracking = 1,
  },
  xwayland = {
    force_zero_scaling = true,
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
hl.bind("SUPER + C", hl.dsp.exec_cmd("hyprctl dispatch killactive"), { description = "Kills active window" })
-- hl.bind("SUPER + W", hl.dsp.togglefloating, { description = "Toggles window floating" })
-- hl.bindd("SUPER, W, Toggles window floating, togglefloating")
hl.bind("SUPER + G", hl.dsp.group.toggle(), { description = "Toggle focused window to group" })
hl.bind("ALT + return", hl.dsp.window.fullscreen({ action = "toggle" }), { description = "Toggle fullscreen" })
hl.bind("SUPER + SHIFT + F", hl.dsp.exec_cmd("~/.config/hypr/scripts/windowpin"), { description = "Pin focused window" })
hl.bind("CONTROL + ESCAPE", hl.dsp.exec_cmd("systemctl --user is-active waybar && systemctl --user stop waybar || systemctl --user start waybar"), { description = "Toggle waybar" })
-- hl.bind("CONTROL + ESCAPE", hl.dsp.exec_cmd("pkill waybar || waybar"), { description = "Toggle waybar" })
hl.bind("SUPER + ALT + W", hl.dsp.exec_cmd("~/.config/hypr/scripts/select-wp"), { description = "Wallpaper selection script" })
hl.bind("SUPER + T", hl.dsp.exec_cmd("foot"), { description = "Launch terminal" })
hl.bind("SUPER + F", hl.dsp.exec_cmd("firefox"), { description = "Launch browser" })
-- FIXME: btop
hl.bind("SUPER + ESCAPE", hl.dsp.exec_cmd("setsid -f $term -e btop"), { description = "Launch btop" })
-- FIXME: keybinds
hl.bind("SUPER + SHIFT + slash", hl.dsp.exec_cmd("setsid -f $term -T Keybindings -e $scr_path/keybindings"), { description = "Show keybinds" })
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("pkill -x fuzzel || fuzzel"), { description = "Program launcher" })
hl.bind("SUPER + backspace", hl.dsp.exec_cmd("logout-menu"), { description = "Logout menu" })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { description = "Toggle audio mute" })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/change-volume 5%-"), { description = "Lower volume" })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/change-volume 5%+"), { description = "Raise volume" })
hl.bind("SUPER + P", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot-tool freeze-area"), { description = "Copy selection to clipboard" })
hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot-tool freeze-area-save"), { description = "Saves selection to named file" })
hl.bind("SUPER + ALT + P", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot-tool copy-focused-monitor"), { description = "Copy focused monitor to clipboard" })
hl.bind("SUPER + CONTROL + P", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot-tool copy-all-monitors"), { description = "Copy all monitors to clipboard" })
hl.bind("SUPER + 1", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-workspace-number 1"), { description = "Switch to workspace 1" })
hl.bind("SUPER + 2", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-workspace-number 2"), { description = "Switch to workspace 2" })
hl.bind("SUPER + 3", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-workspace-number 3"), { description = "Switch to workspace 3" })
hl.bind("SUPER + 4", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-workspace-number 4"), { description = "Switch to workspace 4" })
hl.bind("SUPER + 5", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-workspace-number 5"), { description = "Switch to workspace 5" })
hl.bind("SUPER + 6", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-workspace-number 6"), { description = "Switch to workspace 6" })
hl.bind("SUPER + 7", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-workspace-number 7"), { description = "Switch to workspace 7" })
hl.bind("SUPER + 8", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-workspace-number 8"), { description = "Switch to workspace 8" })
hl.bind("SUPER + 9", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-workspace-number 9"), { description = "Switch to workspace 9" })
hl.bind("SUPER + 0", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-workspace-number 10"), { description = "Switch to workspace 10" })
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
hl.bind("SUPER + ALT + 1", hl.dsp.window.move({ workspace = 1 }), { description = "Move focused window to workspace 1" })
hl.bind("SUPER + ALT + 2", hl.dsp.window.move({ workspace = 2 }), { description = "Move focused window to workspace 2" })
hl.bind("SUPER + ALT + 3", hl.dsp.window.move({ workspace = 3 }), { description = "Move focused window to workspace 3" })
hl.bind("SUPER + ALT + 4", hl.dsp.window.move({ workspace = 4 }), { description = "Move focused window to workspace 4" })
hl.bind("SUPER + ALT + 5", hl.dsp.window.move({ workspace = 5 }), { description = "Move focused window to workspace 5" })
hl.bind("SUPER + ALT + 6", hl.dsp.window.move({ workspace = 6 }), { description = "Move focused window to workspace 6" })
hl.bind("SUPER + ALT + 7", hl.dsp.window.move({ workspace = 7 }), { description = "Move focused window to workspace 7" })
hl.bind("SUPER + ALT + 8", hl.dsp.window.move({ workspace = 8 }), { description = "Move focused window to workspace 8" })
hl.bind("SUPER + ALT + 9", hl.dsp.window.move({ workspace = 9 }), { description = "Move focused window to workspace 9" })
hl.bind("SUPER + ALT + 0", hl.dsp.window.move({ workspace = 0 }), { description = "Move focused window to workspace 10" })
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
hl.bind("SUPER + S", hl.dsp.focus({ workspace = "special" }), { description = "Toggle special workspace" })
hl.bind("SUPER + D", hl.dsp.focus({ workspace = "special" }), { description = "Toggle special workspace" })
-- hl.bindd("SUPER, D, Toggle layout, togglesplit,")

hl.bind("SUPER + SHIFT + H", hl.dsp.window.resize({ x = -30, y = 0 }), { repeating = true })
hl.bind("SUPER + SHIFT + J", hl.dsp.window.resize({ x = 0, y = 30 }), { repeating = true })
hl.bind("SUPER + SHIFT + K", hl.dsp.window.resize({ x = 0, y = -0 }), { repeating = true })
hl.bind("SUPER + SHIFT + L", hl.dsp.window.resize({ x = 30, y = 0 }), { repeating = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), { repeating = true, description = "Increase brightness" })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { repeating = true, description = "Decrease brightness" })

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
