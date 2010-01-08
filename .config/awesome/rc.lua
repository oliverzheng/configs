-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/home/oliver/.config/awesome/theme/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor
browser = "firefox"
screenlock = "slock"
musicpause = "mocp -G"
musicnext = "mocp -f"
musicprev = "mocp -r"
checkmail = "offlineimap -f INBOX"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating
}

-- Table of clients that should be set floating. The index may be either
-- the application class or instance. The instance is useful when running
-- a console app in a terminal like (Music on Console)
--    xterm -name mocp -e mocp
floatapps =
{
    -- by class
    ["MPlayer"] = true,
    ["pinentry"] = true,
    ["gimp"] = true,
    ["feh"] = true,
    -- by instance
    ["mocp"] = true
}

-- Applications to be moved to a pre-defined tag by class or instance.
-- Use the screen and tags indices.
apptags =
{
    -- ["mocp"] = { screen = 2, tag = 4 },
    ["Navigator"] = { screen = 1, tag = 1 },
    ["pidgin"] = { screen = 1, tag = 7 },
    ["OpenOffice.org 3.1"] = { screen = 1, tag = 4 },
}

-- Define if we want to use titlebar on all applications.
use_titlebar = false
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({"web", "email", "dev", "doc", "debug", "media", "im"}, s, awful.layout.suit.tile)
end
-- }}}

-- Create a Volume progressmeter
--------------------------------
cardid  = 0
channel = "Master"
function volume (mode, widget)
  if mode == "update" then
    local status = io.popen("amixer -c " .. cardid .. " -- sget " .. channel):read("*all")

    local volume = string.match(status, "(%d?%d?%d)%%")

    status = string.match(status, "%[(o[^%]]*)%]")

    if string.find(status, "on", 1, true) then
      widget:bar_properties_set("vol", {["bg"] = beautiful.pb_volume_vol_bg})
    else
      widget:bar_properties_set("vol", {["bg"] = "#cc3333"})
    end
    widget:bar_data_add("vol", volume)
  elseif mode == "up" then
    awful.util.spawn("amixer -q -c " .. cardid .. " sset " .. channel .. " 2%+")
    volume("update", widget)
  elseif mode == "down" then
    awful.util.spawn("amixer -q -c " .. cardid .. " sset " .. channel .. " 2%-")
    volume("update", widget)
  else
    awful.util.spawn("amixer -c " .. cardid .. " sset " .. channel .. " toggle")
    volume("update", widget)
  end
end

pb_volume =  widget({ type = "progressbar", align = "right" })
pb_volume.width = 10
pb_volume.height = 0.8
pb_volume.gap = 0
pb_volume.border_padding = 1
pb_volume.border_width = 1
pb_volume.ticks_count = 4
pb_volume.ticks_gap = 1
pb_volume.vertical = true

pb_volume:bar_properties_set("vol", 
{ 
  ["bg"] = beautiful.pb_volume_vol_bg,
  ["fg"] = beautiful.pb_volume_vol_fg,
  ["fg_center"] = beautiful.pb_volume_vol_fg_center,
  ["fg_end"] = beautiful.pb_volume_vol_fg_end,
  ["fg_off"] = beautiful.pb_volume_vol_fg_off,
  ["border_color"] = beautiful.pb_volume_vol_border_color,
  ["min_value"] = "0.0",
  ["max_value"] = "100.0",
  ["reverse"] = false
})

pb_volume:buttons({
    button({ }, 4, function () volume("up", pb_volume) end),
    button({ }, 5, function () volume("down", pb_volume) end),
    button({ }, 1, function () volume("mute", pb_volume) end),
})

vol_timer = timer { timeout = 3 }
vol_timer:add_signal("timeout", function() volume("update", pb_volume) end)
vol_timer:start()

myspace          = widget({ type = "textbox", name = "myspace", align = "right" })
myseparator      = widget({ type = "textbox", name = "myseparator", align = "right" })
myspace.text     = " "
myseparator.text = "|"
-- 
--
-- {{{ Wibox
-- Create a textbox widget
tb_time = widget({ type = "textbox" })
tb_mail = widget({type = "textbox"})
batterywidget = widget({type = 'textbox'})

--tb_mail.text = os.date("<span foreground='#FFFFFF'>%I:%M %p</span> ")
-- Set the default text in textbox
--tb_time.text = "<b><small> " .. AWESOME_RELEASE .. " </small></b>"

-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ format = "%I:%M %p", timeout = 30})

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mytaglist[s],
                           --myspace,
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        tb_time,
        myspace,
        tb_mail,
        myspace,
        pb_volume,
        myspace,
        batterywidget,
        myspace,
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, ",",      awful.tag.viewprev       ),
    awful.key({ modkey,           }, ".",      awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show(true)        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Shift"   }, "Return", function () awful.util.spawn(browser)  end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),

    -- Screen lock
    awful.key({ }, "#148",
              function ()
                  awful.util.spawn(screenlock)
              end),

    awful.key({ }, "#237",
              function ()
                  awful.util.spawn(screenlock)
              end),

    -- Music
    awful.key({ }, "#172",
              function ()
                  awful.util.spawn(musicpause)
              end),

    awful.key({ }, "#162",
              function ()
                  awful.util.spawn(musicpause)
              end),

    awful.key({ }, "#166",
              function ()
                  awful.util.spawn(musicprev)
              end),

    awful.key({ }, "#234",
              function ()
                  awful.util.spawn(musicprev)
              end),

    awful.key({ }, "#167",
              function ()
                  awful.util.spawn(musicnext)
              end),

    awful.key({ }, "#233",
              function ()
                  awful.util.spawn(musicnext)
              end),

    -- Volume
    awful.key({ }, "#176",
              function ()
                  volume("up", pb_volume)
              end),
    awful.key({ }, "#174",
              function ()
                  volume("down", pb_volume)
              end),
    awful.key({ }, "#160",
              function ()
                  volume("mute", pb_volume)
              end),
    awful.key({ }, "#123",
              function ()
                  volume("up", pb_volume)
              end),
    awful.key({ }, "#122",
              function ()
                  volume("down", pb_volume)
              end),
    awful.key({ }, "#121",
              function ()
                  volume("mute", pb_volume)
              end),

    -- Mail
    awful.key({ }, "#163",
              function ()
                  awful.util.spawn(checkmail)
              end),
    awful.key({ }, "#236",
              function ()
                  awful.util.spawn(checkmail)
              end)
)

-- Client awful tagging: this is useful to tag some clients and then do stuff like move to tag on them
clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "feh" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    { rule = { instance = "Navigator" },
       properties = { tag = tags[1][1] } },
    { rule = { instance = "Pidgin" },
       properties = { tag = tags[1][7] } },
    { rule = { class = "OpenOffice.org 3.1" },
       properties = { tag = tags[1][4] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    c.size_hints_honor = false
end)

client.add_signal("focus", function(c)
    c.border_color = beautiful.border_focus
    c.opacity = 1
end)
client.add_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
    c.opacity = 0.65
end)


-- Hook called every second
mytimer = timer { timeout = 1 }
mytimer:add_signal("timeout", function ()
    tb_time.text = os.date("<span foreground='#FFFFFF'>%I:%M %p</span> ");
    local f = assert(io.popen('cd /home/oliver/mail/oliverzheng/INBOX && find -path "*/new/*" | wc -l', 'r'))
    local s = assert(f:read('*a'))
    f:close()
    if raw then return s end
    s = string.gsub(s, '^%s+', '')
    s = string.gsub(s, '%s+$', '')
    s = string.gsub(s, '[\n\r]+', ' ')
    faint = "777777";
    if (s == '0') then
        c = faint;
    else
        c = "FFFFFF";

    end
    tb_mail.text = "<span foreground='#" .. faint .. "'></span><span weight='bold' foreground='#" .. c .. "'>" .. s .. "</span><span foreground='#" .. faint .. "'></span>"

end)
mytimer:start()

batterytimer = timer { timeout = 2 }
batterytimer:add_signal("timeout", function ()
    local f = io.open('/proc/acpi/battery/BAT0/info')
    local infocontents = f:read('*all')
    f:close()

    f = io.open('/proc/acpi/battery/BAT0/state')
    local statecontents = f:read('*all')
    f:close()

    local status, _
    -- Find the full capacity (from info)
    local full_cap

    status, _, full_cap = string.find(infocontents, "last full capacity:%s+(%d+).*")

    -- Find the current capacity, state and (dis)charge rate (from state)
    local state, rate, current_cap

    status, _, state = string.find(statecontents, "charging state:%s+(%w+)")
    status, _, rate  = string.find(statecontents, "present rate:%s+(%d+).*")
    status, _, current_cap = string.find(statecontents, "remaining capacity:%s+(%d+).*")

    local prefix, percent, time
    percent = current_cap / full_cap * 100
    if state == "charged" then
        percent = 100
        time = ""
    elseif state == "charging" then
        time = (full_cap - current_cap) / rate
    elseif state == "discharging" then
        time = current_cap / rate
    end

    percent = math.floor(percent)

    if state ~= "charged" then
        time_hour = math.floor(time)
        time_minute = math.floor((time - time_hour) * 60)
        time = string.format("(%02d:%02d)", time_hour, time_minute)
    end

    local color
    if state == "discharging" then
        if percent < 20 then
            color = "#FF2400"
        else
            color = "#FFA54F"
        end
    else
        color = "#9ACD32"
    end
    batterywidget.text = "<span color='" .. color .."'>" .. percent .. "% " .. time .. "</span>"
end)
batterytimer:start()

-- }}}

--table.insert(globalkeys, key({ }, "#176", function () volume("up", pb_volume) end))
--table.insert(globalkeys, key({ }, "#174", function () volume("down", pb_volume) end))
--table.insert(globalkeys, key({ }, "#160", function () volume("toggle", pb_volume) end))

--root.keys(globalkeys)
--
--keybinding({ }, "#176", function () volume("up", pb_volume) end):add()
--keybinding({ }, "#174", function () volume("down", pb_volume) end):add()
--keybinding({ }, "#160", function () volume("mute", pb_volume) end):add()


