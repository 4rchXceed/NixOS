local terminal = "kitty"
local file_manager = "thunar"
local menu = "rofi -show drun"
local monitor = "eDP-1"
local anim_speed = 3

hl.config({
    	input = {
        	kb_layout = "ch",
		kb_variant = "fr",
		touchpad = {
			natural_scroll = true
		}
	},
	general = {
		gaps_in = 5,
		gaps_out = 10,
		border_size = 5,
		col = {
			active_border = { colors = { "rgba(137a7fee)", "rgba(86cecbee)" }, angle = 45 },
			inactive_border = "rgba(373b3eee)"
		},
		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle"
	},
	decoration = {
		rounding = 20,
		rounding_power = 2,
		active_opacity = 1.0,
		inactive_opacity = 0.9,
		shadow = {
			enabled = false
		},
		blur = {
			enabled = true,
			size = 10,
			passes = 1,

			vibrancy = 0.9696
		},
	},
	animations = {
		enabled = true,
		-- TODO
	},
	dwindle = {
		preserve_split = true
    },
    master = {
        new_status = "master",
    }
})

hl.monitor({
	output = monitor,
	position = "0x0",
	scale = 1
})

hl.on("hyprland.start", function ()
	hl.exec_cmd("systemctl start --user plasma-polkit-agent")
	hl.exec_cmd("waybar")
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("dunst")
	hl.exec_cmd("systemctl start --user hyprpolkitagent")
	hl.exec_cmd("systemctl start --user hyprpaper.service")
end)

hl.env("XCURSOR_SIZE", 24)
hl.env("HYPRCURSOR_SIZE", 24)

hl.bind("SUPER + mouse:272", hl.dsp.window.drag())
hl.bind("SUPER + mouse:273", hl.dsp.window.resize())
hl.bind("SUPER + O", hl.dsp.window.fullscreen())
hl.bind("SUPER + Q", hl.dsp.exec_cmd(terminal));
hl.bind("SUPER + C", hl.dsp.window.close());
hl.bind("SUPER + E", hl.dsp.exec_cmd(file_manager));
hl.bind("SUPER + F", hl.dsp.window.float());
hl.bind("SUPER + D", hl.dsp.exec_cmd(menu));
hl.bind("SUPER + Space", hl.dsp.exec_cmd(menu));
hl.bind("SUPER + P", hl.dsp.window.pseudo());

hl.bind("SUPER + left", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + right", hl.dsp.window.move({ direction = "r" }))
hl.bind("SUPER + up", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + down", hl.dsp.window.move({ direction = "d" }))

for i = 1, 9 do
    hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("scmd"))
hl.bind("SUPER + SHIFT + S", hl.dsp.window.move({ workspace = "special:scmd" }))

hl.bind("Print", hl.dsp.exec_cmd("grim -g \"$(slurp)\" | wl-copy"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("grim -o " .. monitor ..  " | wl-copy && notify-send \"Screenshot\""))
hl.bind("SUPER + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy"))

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"))

hl.curve("over", { -- 0.63,-1,0.3,1.42
    type = "bezier",
    points = {
        { 0.36, -1 },
        { 0.36, 1.3 },
    }
})

hl.curve("normal", {
    type = "bezier",
    points = {
        { 0.5, 0.69 },
        { 0.58, 1 },
    }
})

hl.animation({
    leaf = "global",
    enabled = true,
    speed = anim_speed,
    bezier = "over"
})

hl.animation({
    leaf = "windows",
    enabled = true,
    speed = anim_speed,
    bezier = "over",
    style = "slide"
})

hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = anim_speed,
    bezier = "over",
    style = "slide bottom"
})
