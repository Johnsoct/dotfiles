local function launchOrCycle(appName)
	local app = hs.application.get(appName)
	if not app then
		hs.application.launchOrFocus(appName)
		return
	end

	local windows = app:allWindows()
	if #windows == 0 then
		hs.application.launchOrFocus(appName)
		return
	end

	local focused = hs.window.focusedWindow()
	if not focused or focused:application():name() ~= appName then
		windows[1]:focus()
		return
	end

	for i, win in ipairs(windows) do
		if win:id() == focused:id() then
			local next = windows[(i % #windows) + 1]
			next:focus()
			return
		end
	end
end

-- Brave Browser
hs.hotkey.bind({ "cmd" }, "1", function()
	launchOrCycle("Brave Browser")
end)

-- Terminal
hs.hotkey.bind({ "cmd" }, "2", function()
	launchOrCycle("Alacritty")
end)

-- Claude
hs.hotkey.bind({ "cmd" }, "3", function()
	launchOrCycle("Claude")
end)

-- Claude
hs.hotkey.bind({ "cmd" }, "4", function()
	launchOrCycle("Postman")
end)

-- Claude
hs.hotkey.bind({ "cmd" }, "5", function()
	launchOrCycle("Notion")
end)

-- Claude
hs.hotkey.bind({ "cmd" }, "6", function()
	launchOrCycle("Google Chrome")
end)

-- Claude
hs.hotkey.bind({ "cmd" }, "7", function()
	launchOrCycle("Microsoft Teams")
end)

-- Claude
hs.hotkey.bind({ "cmd" }, "8", function()
	launchOrCycle("Microsoft Visio")
end)

-- Claude
hs.hotkey.bind({ "cmd" }, "9", function()
	launchOrCycle("Microsoft Outlook")
end)

-- Claude
hs.hotkey.bind({ "cmd" }, "0", function()
	launchOrCycle("Spotify")
end)
